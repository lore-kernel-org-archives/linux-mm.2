Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF97FCD98F2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 17:52:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9C336B0093; Wed, 17 Jun 2026 13:52:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D73A46B0095; Wed, 17 Jun 2026 13:52:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8A206B0098; Wed, 17 Jun 2026 13:52:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A46036B0093
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 13:52:42 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1FFE61A051A
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 17:52:42 +0000 (UTC)
X-FDA: 84890149764.03.E8F43A4
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7DC56C0004
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 17:52:40 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jHY73IPw;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781718760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iT3/EFWjQcFNWU8AZui0piojLffybLEkWSqmoNZTAr0=;
	b=bwbkFmgYxVT7qTDGpvPq8R3VActKUXe+DSfRRIW2Y5Q19YpVruLCpW9kaaE6baIybvgoNH
	+87RsX8ZNgS8vf+Y2/YP0ay4s8dvDd12HoeiSfbLjkFVafoUKN3wvEv8YAE3naSSH4U7GU
	JcnFE8bqDmb3zRh8rhpU7l/SluLPVl0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jHY73IPw;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781718760;
	b=kQN2PCKcxTg/xrMCICnhqsKEiwHNCI6xMH+uc4cTda/xEIYkrrOTKQomS/s8EwEMSRFtms
	CttPEyBflcF5wFuOljrcJTiGCfzKcTv6NEi+wx4Hof4O7oESf9PKVW7U6ehw5Dld8AaxAf
	w6iaKWQ+eF3SNXjIs2HVTAzo9Kztkm8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781718758;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iT3/EFWjQcFNWU8AZui0piojLffybLEkWSqmoNZTAr0=;
	b=jHY73IPwI4mKEO8XYiYFNaf4NQx8nholKnr9xjEOM86sr3tHDjl4Cc6Q2SdtUQDAM5Jpl3
	7oaiCztd70GO/zjNtSKRs1+Izogub3wQanuozLnLkMKGYlLGWIfEtXmi1GMjY9Lrfaa+9c
	1K//wasyi0osGPvoU4Ctsvav6FpBZw4=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	linux-mm@kvack.org,
	bsegall@google.com,
	dietmar.eggemann@arm.com,
	hannes@cmpxchg.org,
	juri.lelli@redhat.com,
	kprateek.nayak@amd.com,
	linux-kernel@vger.kernel.org,
	mgorman@suse.de,
	mingo@redhat.com,
	peterz@infradead.org,
	rostedt@goodmis.org,
	surenb@google.com,
	vincent.guittot@linaro.org,
	vschneid@redhat.com
Cc: shakeel.butt@linux.dev,
	riel@surriel.com,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH 1/1] sched/psi: skip irqtime accounting when no new irq time has elapsed
Date: Wed, 17 Jun 2026 10:50:06 -0700
Message-ID: <20260617175219.2494857-2-usama.arif@linux.dev>
In-Reply-To: <20260617175219.2494857-1-usama.arif@linux.dev>
References: <20260617175219.2494857-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: m98p6fabuszup4ik4pd3wep3m9pe8kux
X-Rspamd-Queue-Id: 7DC56C0004
X-HE-Tag: 1781718760-998508
X-HE-Meta: U2FsdGVkX1/CYOf4WB1/C6WX0Encvp5Op76ReVzy44FrrAQRDMBH69kVga/Nm+B7nQG5v+pEF4tXnWyOgIfx5WDYvSReiZpOYAhs91RafyspuRb2yHzN2psyiYzS/gOikF+opG0UdkWGezP6KBQ186SjY2kSVjIyIRzZc1TR/czstttAWQMBusi44toUFHN/L2JbvbP1CBEYX0LtKgGxaYf8yG1J4sx+V1XuoV8pvRW4ZARntILy0ZpcAm/M9NiURq/XRmvoHByRX19BrUJceq+cyVXEseZRpBhYY9FL0SRF+M4b98LuInksUzuWndzVSb5Ng4RkXVaez6nx8/PlgbkfXosokZJWPBCEjkgr2MmaBzMY3RTIk1JlY9inDRcWLwcXLHE1w74znwhn0y/O7rEWHG2QMxvLV4hfOC7O/Z6mOeENfT1OpyYHtDhzm+MwnAEdNhDSv2GUXJnT0jX0RAV6rCofCd32TmtcAAD9hzqSLJ4tssofLpWbTk+V6q9Yl7qanrwrgHv9RUa5RVx06NzgvyxIWVTTm480vDaS+iMwnPB7r9R+r/Y3RGWLla67ZmsL6VfJvCyK4uSZUU0S+H9DlQdhphMCJvyW8nZSr1xWwevrcGd6jG2kS5wKiCZQSVoiZWvP4nxd+tOb4jzeX5Ukarm3imO/mqg0o5p6nQbx39P07mYK7PXNgcDKr3Ek6fgVphZ+lkO5cITxvizeDGbMbMdhA23oSAMWopZMksB0sPBeRFq3Ei669MUoH4Kvd6HcvDzrWVPC2ElGczMG1e7UOwsIb9DOSU3halgpZd7Eykz4qlMjupZvx5Pf2XVSrF0D4LcE/zjedeSvQskGSKqYRB9/m4KtNtrOPi8RrI9FEoaHEWktvgWnTR98DHogHZxTBKVX0uIDm85gHNnp99zty+6l21k1KCOvh/avNuoFk08lhtt2BoUu9sYu7nEGKXD6QbAZlOU++SXwL2R
 WIjNH2pz
 f13p4GwqCumqspkV/mmeDCfsSIswJ/Q85E3/xrM/IpQoz9e3bMUR4kEn4vmYf2YMfVDaNKRWQL4ApmykE4SR2IPR52LtWrmjNa9bUwA7qydwK8Ukb0NnbMEsQrtpQG6L0PMF8aT5jx8Gk3od8FUhO1OucRW0dU36w5f3qOf1R1nj7wS2wv7Wge31VuZRM+jCm3nmk1rc/+Eh8uw8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

psi_account_irqtime() reads irq_time_read() into a per-rq cumulative
counter and only bails out when the delta vs. the previously accounted
amount is negative.  A delta of exactly zero is treated as "do the
work": psi_write_begin() is taken, cpu_clock(cpu) is read (which on
x86 ends up in native_sched_clock() / rdtsc) and the cgroup ancestor
chain is walked to add zero to every group's PSI_IRQ_FULL bucket.

The zero-delta case is common in practice -- it fires every time a
context switch crosses a PSI group boundary on a CPU that hasn't
serviced an interrupt between the two switches.

Measured on a 176-thread AMD EPYC 9D64 server running a compute
intensive production workload, instrumented with bpftrace over a 30s
window (irq_time_read() read directly from the per-CPU cpu_irqtime so
that delta == 0 and delta < 0 could be separated):

  @total              17,229,311    (100.0%)
  @ret_curr_swapper    7,864,195    ( 45.6%)  curr->pid == 0
  @ret_samegrp           323,299    (  1.9%)  same cgroup as prev
  @reached_delta       9,041,817    ( 52.5%)
    @delta_positive    6,358,192    ( 36.9%)  real work
    @delta_zero        2,683,625    ( 15.6%)  work wasted (this patch)
    @delta_negative          (0)    (  0.0%)  monotonic clock

So 15.6 % of all psi_account_irqtime() calls - and 29.7 % of the
calls that get past the early returns - hit the delta == 0 case;
delta < 0 did not occur once in the 30 s window.  Under the current
code each of those ~89 k calls per second performs the full seqcount
write + cpu_clock() read + cgroup-chain walk just to add 0 to every
group's PSI_IRQ_FULL counter.

Extend the early-return to also cover delta == 0.  rq->psi_irq_time
does not need updating in that case (it would store the same value
back) and no PSI bucket would change.  The existing behaviour for
delta > 0 is untouched.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 kernel/sched/psi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
index d9c9d9480a45..848955f8893d 100644
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -1023,7 +1023,7 @@ void psi_account_irqtime(struct rq *rq, struct task_struct *curr, struct task_st
 
 	irq = irq_time_read(cpu);
 	delta = (s64)(irq - rq->psi_irq_time);
-	if (delta < 0)
+	if (delta <= 0)
 		return;
 	rq->psi_irq_time = irq;
 
-- 
2.53.0-Meta


