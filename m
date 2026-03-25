Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 069BEFEA837
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 09:11:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67B676B00AD; Wed, 25 Mar 2026 05:11:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62BB06B00AF; Wed, 25 Mar 2026 05:11:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51AEC6B00B0; Wed, 25 Mar 2026 05:11:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3D72B6B00AD
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 05:11:18 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1802BC299D
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:11:18 +0000 (UTC)
X-FDA: 84584016636.27.B67CBE9
Received: from mail-dy1-f177.google.com (mail-dy1-f177.google.com [74.125.82.177])
	by imf18.hostedemail.com (Postfix) with ESMTP id 272DE1C0010
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:11:15 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XltB0HjY;
	spf=pass (imf18.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.177 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774429876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k0s0Dc7RCL/9ENJthFTImT096lJg25UlEll25yQMqG8=;
	b=Fwg1lq6ywsTG20G5I4w3yU91X3yDdYNR7uZSDarmuNYkbKpTxAhjzjCyXq9NOSTA24zrtZ
	BvDl3OQqKdik7m3vxeSAmD8JCGEGtMA8+301exUo/Kh9YfvoU2yoHWePwRDx2pPiV5Fnb9
	Vm2uGPIcsgFsWLDchUvF1FIoVuOyUII=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774429876; a=rsa-sha256;
	cv=none;
	b=xZH4tI5p0OyhOXlwwm0yKK0lxHgbUxYNTdWRbaVZs2jqN69oSHU+qUPJeynLl/INQWWEEi
	0zyLfgoUpSHHVKSqnkV46i47yC2PpLQFEVPedMhlcEgAZfPybIGNj2xeZDpXcvFOk+BPyC
	x86zumJdgky5+TbMiG1dX2rvHHQiHAY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XltB0HjY;
	spf=pass (imf18.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.177 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f177.google.com with SMTP id 5a478bee46e88-2ba895adfeaso2410663eec.0
        for <linux-mm@kvack.org>; Wed, 25 Mar 2026 02:11:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774429875; x=1775034675; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=k0s0Dc7RCL/9ENJthFTImT096lJg25UlEll25yQMqG8=;
        b=XltB0HjYVpMSqqS3LdCCmS3fSUK6JEeLswiABbbdvPzQhtTpup9Y34GovWKx7O5HwX
         QPDcWVFiLZJMVz9WA1iuCl6E/WjQljjR+vGIzG6JnY93B/s10guyOSL+quS/xOISW61c
         IR8MrrWZGOGoFBTHW5naHyxhsADq22kF2iVIot+1XC6/cpBq4zC8wRv1wfdcrIXgjwgH
         WIUz0LACK9yaX3/sdPJ715MtArJq/5fWR6ero6YXvYcTrFukHGr3poV0I4+9b7ByKap7
         p40ITC1IH/i0UhA45PwK2ZWPqow7PnFl59gC4OdUf5hAbDVJU8Lb4ObvS+wLzEh/WMDX
         EdyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774429875; x=1775034675;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=k0s0Dc7RCL/9ENJthFTImT096lJg25UlEll25yQMqG8=;
        b=mLwKj1uE/TpgpHF3fLHp9H8v//VaMy829Yk+9av3uSJANKPy9YA4Pa2C9E1fH79Eux
         E7Ji7lkg+W9cbu9b3nXRAquoJqAueBMUvQZvGMkQAzjkoePV1l4dSMdej4hSLKfJaKGW
         GcYR9hqZN027bPZ1UeaJql11+p7br+udN43GVUCZKKVxltIdiqHOUwGyQ+fAFRH653Q6
         aHq4gg3IjJ2lG9Ytzm/0ieAyBipKe683o0A6QC3ZkbROCVCLQMOWr2t9eF/n4276gWI4
         nBRn126U2JrtpY58mbukxWreBo01wWwmUEPorVzqcwU71vgjW/N2GQFCrTG93kKoaHZq
         +eOA==
X-Forwarded-Encrypted: i=1; AJvYcCXs/iymx/v3l91cwhU1QKc79qXWtKinX+kC2F40lWQv+cNTH2O9+IOeFaBhblDASNtBzytWIek2fw==@kvack.org
X-Gm-Message-State: AOJu0YxeepP42raUPnHTh0i4DS63DTjYX6CGPeZ6z7f7a8z7WPqjiBKL
	/X6FH8Vdw8uT1FSyo65O/QeNZcskbrkSdZT4ga+tDlRNmjBzUFuDYfog
X-Gm-Gg: ATEYQzwYwmKD03CIU1e4Q7X16b1WEjQ2xShaelkEvRhI28RQlPtguCZBHN2PBOJqwql
	4k7UBVmMMiHoqlw0VPYiqkJduBVLMRHrA9klCYyInxbM14aWhO0bAdfi51/BbJdQ5pyAHK3H2Eq
	2W7EwHcwECW037E/lwNyWYTAQ7cHK5bQ32TulvJX4pU0WLGSX+xIIk0gZKZd7/iFseDKa0NltU1
	rVY6bG4XRXhP+b3i++OusgxHE7+pW6AVwyJaNoOYLSQAoMvoeY0ChM9sTEF+mm8hz2t0yDDqJ47
	k0eIOkeaCvrMEOEJmBDcqD7T/pdfolfTlWkIgD9RYDgNP9eN3BZiksIOjPLpWxC/cNNs7vmOTfb
	xzrVza3SbHAn8k4otirTGAIIinVasYDaRhQzndH0xgcF5hGcDjS0U1nvccWWoJM2yIB+FdvH6/0
	t6FH2utSH4GzDLz7dR
X-Received: by 2002:a05:7301:9f13:b0:2be:1946:857e with SMTP id 5a478bee46e88-2c15d35c829mr1429438eec.12.1774429874937;
        Wed, 25 Mar 2026 02:11:14 -0700 (PDT)
Received: from wujing. ([74.48.213.230])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2c159e25dc7sm2786389eec.27.2026.03.25.02.11.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2026 02:11:14 -0700 (PDT)
From: Qiliang Yuan <realwujing@gmail.com>
Date: Wed, 25 Mar 2026 17:09:43 +0800
Subject: [PATCH 12/15] sched/isolation: Bridge boot-time parameters with
 dynamic isolation
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260325-dhei-v12-final-v1-12-919cca23cadf@gmail.com>
References: <20260325-dhei-v12-final-v1-0-919cca23cadf@gmail.com>
In-Reply-To: <20260325-dhei-v12-final-v1-0-919cca23cadf@gmail.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, 
 Thomas Gleixner <tglx@kernel.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
 Frederic Weisbecker <frederic@kernel.org>, 
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
 Joel Fernandes <joelagnelf@nvidia.com>, 
 Josh Triplett <josh@joshtriplett.org>, Boqun Feng <boqun.feng@gmail.com>, 
 Uladzislau Rezki <urezki@gmail.com>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>, 
 Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
 Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
 Anna-Maria Behnsen <anna-maria@linutronix.de>, 
 Ingo Molnar <mingo@kernel.org>, Shuah Khan <shuah@kernel.org>
Cc: linux-kernel@vger.kernel.org, rcu@vger.kernel.org, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, Qiliang Yuan <realwujing@gmail.com>
X-Mailer: b4 0.13.0
X-Rspamd-Queue-Id: 272DE1C0010
X-Stat-Signature: kj4m9bkop5qwy5n66s4jerucn4ez76oz
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774429875-237072
X-HE-Meta: U2FsdGVkX19tLrSFxyHGv2L1X0pvdgjNcubH6NTWQaE4qmQHwBcZR2QESz48Qw+qAUFHxsZsm6d7HdBMvGhdyigpRKPuanAuABiIkmggDmIqpkePYZ9SDs3L0LYKaCNqIeOi0eGVoijSIbqXKLAADIuN7eO9/NAMtitCqmsJhPx87iDQ2RMzLwzQGFn64I7sBaVHx5WfutkDRhUAJgaLp1KSI1mMPj7o39MMci32ud4c7Ys/jUL25HVoRpLtkuCMbF9aTJrSG0o/Kt5s0RKzgrOOqe3igHCDsv1+gF3dXCiSHnwaKQA3XCi3ZPaFDj3D/shcLCMA/BJKzJXqUPOMCcTkxR3ef5xQoO1F5lmNBLCKhy4X/EJabHszQPTY/tAD+hn710pwkQKUI6rUA7UwcKh9jwA70NgXP4wOMVI5UVygE59RJDnTmcfKi1etA6TW/Mhvfl08ADstJK6mPVYrvYRzSF+h/NzYMy9aikrT0F6J031cRQU7MXxzsMhxEaM7qK/F9KLgv5FgOPcmG0BSZXjER97hDx+z8NrhXZqMqbgpigUeQ1PnFrQ4jMoOD4BcIHGipFg+PQ4Et1wE2bsCZ1flfQR6D2SFIjA6sPN2RxV4CwWf9A9oyxTL1Q9uqd/02L55X4RlA2/p19TrdKFW36GOs7QELkeHh6BS9YXp6NgWbrvU/BeHYP4lnx67Nc9WiznkrtuVgP78EdmqpcH9HW06wM90kcOQbKic7wEzsr0sOxxYRCRTO2BN84mWEFL9Q/bbQceCdclEbjoQR0/603VV646RQswPVhJRcLZUdZN54xi0i0az2bN8lAVmUZ6yheE3p6lu0bgi/Dpd99vhMtAIV3hVmMdSYQ2EI4EFROYhC7FNVNlKIHlfn4tA5cdDkGltnFJovhMKMN4lwXKTVhcc1Dxma9HJ5BCfHJPgdN0M3a7WuqDkDXAvCz45vbuEVH5kED4bq6senwCTu+X
 jntLvveP
 0eGzRew5foKoc3wzzR1fgyuEf2XPUd8sNqvlV6r59NaRwed73XJFFRGZkDJkuDhTM3axcVELVzQ3ARMHMpx8bDUBgiSuqe/ah620XoFFUl806X8o9Cm9DGpuQamHHw/MV2dsKNSxP5qMEyAGhbbtpdkeAXbXX4SZAXbPBA2lUe63BAQNAKTnJEAyWcoi8HRFLvMO6rPOJ7czLmDl9g5Q4r2R2dRI6V01fuj3y+iNQVqp/BGjixwSL436L9RbJydvrbNVfezfDlFiWd3VU5WaqzbE5sE4obZrqA9sH/7e6S0sHl5rWof7HIjvwfF0RnyqJEB09u7CFzPx57aHmuHXeWV0Ug9SklHnDoJgwK0XuMCGYt98rFREasdnfXXsuTEn7ZMAMmVqK2wnGEpOyZB+OFOnWDEGJkVdiywXgTWHTlqMGhlsgrRXIAWNoCgIqQsnq3po9nbTTttocmZvkDe/+Rp76PRC39jt3U1AY7Pupcr7r+SlRh6mHblgmR5SYyG+YU5GYt0e1x/wpMQJeMtvEA9dej5Ah4MsRu9ccUJ8mHz9yOyJpuW00osicAtzxzuKTEyJlaP2jrGq5bTI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The boot-time parameters 'isolcpus' and 'nohz_full' currently initialize
housekeeping masks that cannot be easily updated at runtime. To support
DHEI, the scheduler's tick offload infrastructure must be ready for
dynamic enablement even if no isolation was requested at boot.

Enable unconditional boot-time initialization for tick offload.

This ensures that the infrastructure for remote ticks is always present,
allowing DHEI to safely toggle full dynticks mode at runtime.

Signed-off-by: Qiliang Yuan <realwujing@gmail.com>
---
 kernel/sched/core.c      | 5 +++++
 kernel/sched/isolation.c | 3 ---
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index ddf9951f1438c..d987ce03e7cc6 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5688,6 +5688,9 @@ static void sched_tick_stop(int cpu)
 
 int __init sched_tick_offload_init(void)
 {
+	if (tick_work_cpu)
+		return 0;
+
 	tick_work_cpu = alloc_percpu(struct tick_work);
 	BUG_ON(!tick_work_cpu);
 	return 0;
@@ -8509,6 +8512,8 @@ void __init sched_init_smp(void)
 	current->flags &= ~PF_NO_SETAFFINITY;
 	sched_init_granularity();
 
+	sched_tick_offload_init();
+
 	init_sched_rt_class();
 	init_sched_dl_class();
 
diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
index 4a5967837e8de..685cc0df1bd9f 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -299,9 +299,6 @@ void __init housekeeping_init(void)
 
 	static_branch_enable(&housekeeping_overridden);
 
-	if (housekeeping.flags & HK_FLAG_KERNEL_NOISE)
-		sched_tick_offload_init();
-
 	for_each_set_bit(type, &housekeeping.flags, HK_TYPE_MAX) {
 		/* We need at least one CPU to handle housekeeping work */
 		WARN_ON_ONCE(cpumask_empty(housekeeping.cpumasks[type]));

-- 
2.43.0


