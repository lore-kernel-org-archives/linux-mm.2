Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BADECD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 17:52:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8A296B0088; Wed, 17 Jun 2026 13:52:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3B1B6B0092; Wed, 17 Jun 2026 13:52:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2ABE6B0093; Wed, 17 Jun 2026 13:52:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8C65F6B0088
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 13:52:35 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0742F1C4871
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 17:52:35 +0000 (UTC)
X-FDA: 84890149470.02.3B13395
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf17.hostedemail.com (Postfix) with ESMTP id 52C0140004
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 17:52:33 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=k2iAMXhi;
	spf=pass (imf17.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781718753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=cKw8FJF+qidvImrMgGPSUuMVzanR5YCMoXKmktrT1J0=;
	b=6oqTOvyX9vnoXUIDkGlJFZiyZhuRDeRQj4MsF7iqLePUaYINtVHjfX1fLjCHJzwsBaXaGa
	PfjSeWOTQVc0kzkYb95+nGOOm2xBRMEhFr40f8xgbrPABmxPIqEed37tqbOT88fEeheYhW
	ej817mzGnJEcCsNLjtw7KP71Pt5Ij3g=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=k2iAMXhi;
	spf=pass (imf17.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781718753;
	b=Wwxouhh0+xaNS+HZ79dCafzZ5eidooJlYbvhIgRlirS5bGGK0V9ATnr8mpcyhrZb2Rx2IF
	ATggedb6hna2YewVSUuNjkv+dBsn+cYI2iDYM98m1VYU5/4Lc4zm0TdvIrn1TngBQafKKG
	ov/62peF2MquV2UpZStGJ6HGea+ROwI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781718751;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=cKw8FJF+qidvImrMgGPSUuMVzanR5YCMoXKmktrT1J0=;
	b=k2iAMXhic8L3Q1IPgGhWs3uPV5fDXQXGKAc+7mgrHLG3azpDNzO6JcD0OYdXN+GTNDlNag
	WX7Dv5awnHVpmCuP55/n9YNNRnXL6OS5L36cifkLyN0E2xaVajQ8cg7u0opRIVlEfg/oSi
	efiPgjMqK8HIAl8vRCVt9PvtWIWvRaA=
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
Subject: [PATCH 0/1] sched/psi: skip irqtime accounting when no new irq time has elapsed
Date: Wed, 17 Jun 2026 10:50:05 -0700
Message-ID: <20260617175219.2494857-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 52C0140004
X-Stat-Signature: o3ko4s971egyjxra7a8irtdyya7igrxu
X-Rspam-User: 
X-HE-Tag: 1781718753-436355
X-HE-Meta: U2FsdGVkX1/dd/VESIY9Fa6HV8qBzeAJvTw/tjylmZmJYGnT2weLu2uuiMqR8Nv7NodIXbzc4AYUb3de0Z0Mifp4TTmCfqpBxLehOmf/EhViBpv/K7hC6KzRo4sdDW7k9AfxqIJV6jyvODZW7tY9wLgahST4IUzFoZebIMPq4CrlJL5bYlvhobMHp1jYtVYX1yXrTMzXqpdui9ukecn9XqrYsKXzTxbyPo65i2h6OBXiAlDSD6teCIzRWUql8G5iJ9s06rSlrSd3Y7QI1cudP2uAfuyDiEUcHhirxq9M32+y9f/kPyDrskUeX8ZtvzJHl5Vi+Aot7hoLuCy1oiMBaNDR2v9O6HdBaTQ/qTEu01s95Stbbf3egSdwZ1+783NislUumM2WcVY4/fVmUIkyZXanYRRFBJ4gRCKx2u+PEKCuUEjVdH8MEc5qggjp9U6DpAIJsE2JoDFiWpTi7zMA3sR8QkhpluyhHiKLIeAaQHn9JOZF3w0biO4+kflq5+Vpv5XzRKq0BOG5l05MZqR7CQ/5p4mLTQxneYR+Sjjx7h3rMjnvHeE8BAS/dVMrhWx+iRTnaaIP3WVwjuaBPNA9DvFHZLM2WMCfm0YzbiL/c3tww+PEGXPvt7qq7skbobzz4ozChAHMKaH5GmOMk5zjiH8X0MhlyiiFsGPbuXmx6pBVKnVWBtoDWDk3myodl3alHgNnutbRUHienJBw6AzQBN33uYE7DNkb3KmTcKsqRGG0BpAMlbo/IwPLNh11Oa3xJ4/v7CTtcvbh73OtXXa9Gyg9iBBdRvkNo4tpQXbBjdnDrcMBuN63Ay/qqaERdg8CxvommZ/VNXJ2s3xST/DueC0zs2FcJKtjYy38zqVuFgpG2h1asuI3R2pVyypun4FaJW7hWoye6xl10/gdcSFjvv1f2avV7ywCKw5rrVbjGdzdiS+JAY+26XlQyNZuYV7CTt8pd5ND8bmZXgl1A8r
 pw9j6Q3o
 TiyBzzPkaYtywC0e4LHvehX9Vmu78Aj8+1uPsUnTp0DQ6dxDcW3kYrQrCk08Qwe5vpLGLc6sffrg2kuwSxqwL2EnwQs+8FgVOUWaUiInpvB8m9AuFibO50F56PDfWkjMonixilmA3rEHOZLWU4mZoDC7FQ1Z8MNIbOchreWnJNcOTIrOSieurlPofLhXDsl/LQkbk
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

To find out how often this actually fires in the wild, I attached a
bpftrace probe to psi_account_irqtime() on a 176-thread AMD EPYC 9D64
server running an compute intensive workload.
The probe also reads irq_time_read(cpu) directly from the per-CPU
cpu_irqtime variable so it can separate delta == 0 from delta < 0.
The bpftrace script was generated by claude and is at the end
of the coverletter.

Over a 30 s window under steady-state load:

  @total              17,229,311    (100.0%)
  @ret_curr_swapper    7,864,195    ( 45.6%)  curr->pid == 0
  @ret_samegrp           323,299    (  1.9%)  same cgroup as prev
  @reached_delta       9,041,817    ( 52.5%)
    @delta_positive    6,358,192    ( 36.9%)  real work
    @delta_zero        2,683,625    ( 15.6%)  work wasted (this patch)
    @delta_negative          (0)    (  0.0%)  monotonic clock

15.6 % of all psi_account_irqtime() calls -- and 29.7 % of the calls
that get past the early returns -- hit the delta == 0 case.  delta < 0
did not occur once in the 30 s window.  That works out to ~89 k calls/sec
on this host that today take the full seqcount write + cpu_clock() +
cgroup-chain walk purely to add 0 to every group's PSI_IRQ_FULL counter.

Extend the early-return to also cover delta == 0.  rq->psi_irq_time
does not need updating in that case (it would store the same value
back) and no PSI bucket would change.  The existing behaviour for
delta > 0 is untouched.

--------- psi_delta_exact.bt -------
#!/usr/bin/env bpftrace

#include <linux/sched.h>

kprobe:psi_account_irqtime
{
	$rq = (struct rq *)arg0;
	$curr = (struct task_struct *)arg1;
	$prev = (struct task_struct *)arg2;

	@total = count();

	if ($curr->pid == 0) {
		@ret_curr_swapper = count();
		return;
	}

	if ($prev != 0) {
		$pg_curr = $curr->cgroups->dfl_cgrp;
		$pg_prev = $prev->cgroups->dfl_cgrp;
		if ($pg_curr == $pg_prev) {
			@ret_samegrp = count();
			return;
		}
	}

	@reached_delta = count();

	$pcpu_off  = *(uint64 *)(kaddr("__per_cpu_offset") + cpu * 8);
	$irq_time  = *(uint64 *)(kaddr("cpu_irqtime") + $pcpu_off);
	$prev_time = $rq->psi_irq_time;
	$delta     = (int64)($irq_time - $prev_time);

	if ($delta == 0) {
		@delta_zero = count();
	} else if ($delta > 0) {
		@delta_positive    = count();
	} else {
		@delta_negative = count();
	}
}

interval:s:30 { exit(); }
--------- end bpftrace ---------
 
Usama Arif (1):
  sched/psi: skip irqtime accounting when no new irq time has elapsed

 kernel/sched/psi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
2.53.0-Meta


