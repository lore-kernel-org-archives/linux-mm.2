Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C8A9CD343F
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 17:37:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D34226B008A; Thu,  7 May 2026 13:37:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0CB46B008C; Thu,  7 May 2026 13:37:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFA686B0092; Thu,  7 May 2026 13:37:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AE74D6B008A
	for <linux-mm@kvack.org>; Thu,  7 May 2026 13:37:27 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 581D01C0E2B
	for <linux-mm@kvack.org>; Thu,  7 May 2026 17:37:27 +0000 (UTC)
X-FDA: 84741330534.04.5832D10
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf16.hostedemail.com (Postfix) with ESMTP id 62152180002
	for <linux-mm@kvack.org>; Thu,  7 May 2026 17:37:25 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MYgn5DyM;
	spf=pass (imf16.hostedemail.com: domain of gustavold@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=gustavold@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778175445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T4m72sXmjSg5D7jXc6/EKa8YJmIxljirw3qApIHaCe8=;
	b=FvhWB54+oX5kjDDgoA5tp00GEcLq7iFHREfYRicjzwUtgjvrY8ZhHd6pqx4obMOaTcoEHX
	PDEoawEfWANzV1ncRGt4kq8JfCkW0TJxhuo9gLVgBM99XGgZVkV2/XeViXf3ghhDwS7/ek
	XpHxgne9sU4IgqP3OPSKbDIM+29998s=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MYgn5DyM;
	spf=pass (imf16.hostedemail.com: domain of gustavold@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=gustavold@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778175445; a=rsa-sha256;
	cv=none;
	b=ZlaS00t/Yj2CxSAZsZOxkTXGMVi5Z7NK2aYSHaMmheQc29p2r+u0nLoQnUaLsR7xASSFA7
	bQiwWCx3dH0drI5k12x3yADtTQ3iei4skLcxOy53I07nbpZyG0fpFGbJ2SUXJO+mYxp1I6
	rE76fTTvJnhXgQnV+hW0LLttyQkDrzw=
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-43d7dab87e1so126022f8f.3
        for <linux-mm@kvack.org>; Thu, 07 May 2026 10:37:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778175444; x=1778780244; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T4m72sXmjSg5D7jXc6/EKa8YJmIxljirw3qApIHaCe8=;
        b=MYgn5DyMCXybW+AgX/1al4c9AqRSQKLreiMsiY7nfMBN/LKmx7t0rk4Ydpqcb1FaWr
         etbji1i3wP98DbthvAaHqXZdTDZyZfMmyqJqpnozY2OV0GhxSDfqgX9jfd9FVPbr8e/W
         EoDFEe7h+E3Kj8E4slq2ZxbNfLCsLoUIE2NgdoV6CpHjzYf1sPWhEArU+PLFmltNzc+Q
         eF0I+XhTJrBSQtt5dSo7j5OAUq8RDJ434lrYV+d+TuHu3BC5lQyAgwDMycQ8pY51BSgr
         b0g883n/N+NYdE0LZR0y/HSyuL6GARj8dDI8UqcZUQW4YYakY/VuNPTbtXNJrV6cpQe4
         kLCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778175444; x=1778780244;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=T4m72sXmjSg5D7jXc6/EKa8YJmIxljirw3qApIHaCe8=;
        b=A7OMlag1i2hl8w/YCFDmW0KF9x5xQU2r4eE93qRQXoW6nmWUj5FMEBsdKFtPnjIbj1
         sZSCPMLjSuQGzvLlwDUuZavoKI8+Fld1DwucueUkzIiprhj2yuKwGF/2H8ElMhaE/3bT
         YGIbTX7amYFBhpGqHmR3a+4VYBMhZz1CBEDh8+T50lbs5nLH1m9Nb+zJFu+EIEYyAOff
         6fDuN0oXGXfq6vvs/r+5ts575V/mUn6BpIsO7T8mcIj+C6n1AIk0OeqWs395sAQe4zx5
         J8XwMYw3shMzujYO6kjwbjHY5NmzPP76TKTk0EoQqp93HXlGdE/JzYrRrmRUbyEfONVa
         TV8Q==
X-Forwarded-Encrypted: i=1; AFNElJ81GVzpV3jh0r+ycTYxvjNhpLum2dczWe13Y2OwRFX2BFroLd1W2nTaQwh/GCdbvM1c/r+BZmIaAg==@kvack.org
X-Gm-Message-State: AOJu0Yx5dr5Dext0mZ8UIIA03KZ4Yz+nEc0d1DGPy6gQMDiqOeEHR0dk
	ortCm550bNJKd8tZKQuFVd0eMMhCWGbxFfL68eljhoVhN2c4+lQFn0dT
X-Gm-Gg: AeBDies/R8KJ22+Sdc5uBc/+RLdugyNgDE/5pqzXMTZ6KkT/r1pHVJXOtZAQwIoLJCY
	FHn8ETUGOFTvPtzdljWm+tmp1xBxS04VkXs6FlhM4Ba0T7FT2ZX9yqyJZ1Jl+NFebdCbtpIBSLJ
	3awIvFPhNGqG6afVWnaiRCbAu7EDuKhaq1r2u4soLzrY44ETHUCdI2jBkbpAt4bwIBl2PFmxBBk
	SnPepDB0E3elvAnGAuoCYfVlmZmXbJMcaiwLEFBY4Y0+98498DyeFSkdY+1xX3vBXWzGbUfoWeO
	TaFu88bGfCJ31EwXnKD+CxWgcMm4O3Zo47uXrflJ3TqsxZ2jOJW5QLSMCPVyEJk7qzTEayvBcMb
	9cURKB/C+ao85ghrMhAr+qVPp471ljW7F9CnMKv5R6n1oW97wiGHXMKmlxz+r2iXRj84I0y3TN2
	gZNCsqMIi/WuBYVBGLl1vOAoje5yYyOHu/uhPbN6hDVJLODW9h
X-Received: by 2002:a05:600c:4f82:b0:489:1dc6:d6e with SMTP id 5b1f17b1804b1-48e5325025fmr65769755e9.1.1778175443552;
        Thu, 07 May 2026 10:37:23 -0700 (PDT)
Received: from localhost ([2a03:2880:31ff:31::])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e642e2b29sm1783655e9.1.2026.05.07.10.37.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2026 10:37:23 -0700 (PDT)
From: Gustavo Luiz Duarte <gustavold@gmail.com>
Date: Thu, 07 May 2026 10:37:07 -0700
Subject: [PATCH RFC 1/2] rcu: Expose per-CPU segmented callback counts via
 debugfs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260507-rcu-pending-cbs-stats-v1-1-8f4eb3553bc9@gmail.com>
References: <20260507-rcu-pending-cbs-stats-v1-0-8f4eb3553bc9@gmail.com>
In-Reply-To: <20260507-rcu-pending-cbs-stats-v1-0-8f4eb3553bc9@gmail.com>
To: "Paul E. McKenney" <paulmck@kernel.org>, 
 Frederic Weisbecker <frederic@kernel.org>, 
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
 Joel Fernandes <joelagnelf@nvidia.com>, 
 Josh Triplett <josh@joshtriplett.org>, Boqun Feng <boqun@kernel.org>, 
 Uladzislau Rezki <urezki@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, Breno Leitao <leitao@debian.org>
Cc: rcu@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Gustavo Luiz Duarte <gustavold@gmail.com>
X-Mailer: b4 0.13.0
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 62152180002
X-Rspam-User: 
X-Stat-Signature: p6tgb45qc63jctunf7nkmd4jewdkma4y
X-HE-Tag: 1778175445-194893
X-HE-Meta: U2FsdGVkX1/ahwtV4zeiQpkx8Pgigr+VU6IbZNDBL5KgomL/n9Je+tu7Fe32B3HDbKi4hwPXPdQ0JEAJyUV/GFPF/IbPhSpCaMfTNAk6AjbofmQLeNzUXxT/4+pyHVpstkvQTpg4c4DfrcQ+WcC5z70JqDBRwsBF5hGsF1Aa5p3il+i0MnLJscVfv7RXMAfQULyFIwv93CE6CGqgFi/+FZqZyNzxAZfb53FmRjo99SDtFcpOAqnUaUEBCgD3f+tPuXDjy1OjAH6Cu2iiNhIJU32rr8Kb7GPeaK2U0UzbHghyFiWYs9QZlUmJ7mhoEAiKUOmZLm/JnQHZdUaR6+N8rdNdPugvMgqfl0ltUTerqAaRpM4Po/y84sVlf63VVxEGCgXwYvx76Ft+0xiNDWId4DUxGGhT5oU6A5xC1N2rBL58AYjODCqiQfdgd2kx58cpc0+Dx0bFY+3CSvAszMAdU4BIT3BUGmWz4Sir0LGd959Rk28DJR+/MHQDnPF1BBecMSNBJCFbE3xTiEqY6A2NaMs0wQN0CF8cHV0CKv34SVfuEZ2lD4rcAn0QLSuxphqUIWMmzjgTdfLTdZF260biYDN1FQ/bdbeccvhZG+axInd8hBVuYQHoWxinakvX+8hwMN2+KMOmwncH0CHru+TxTQr7NXlYCIeMmOf14pd1Yg1sWhauvFJeUOqaBawRpjAlZX8gK4Haon4QNxqAU1xuDihGIy0XqRV0hQiANhBH/zwqBUM9aXLa5Q1Ly6M+6+v35lolCPprQaOuTkhnbu7vqPCxemoj6addbg1ByQ2gPG7riqvMvqv3L2B5xHj6rNcgBUIWaxdOBgBMH+F6Xjo4S8FmT6QGUkTzzglNPA2IZi1vLJiXSbzWW/Wo+V4LhP0n5KPDPGohACjRZcEOa+2Sk2ziKcF7zgNQHfzN5Eh+FGv1y51vWnFGPsRyS6E1zngKKUlspIuT/wDfBopNK7m
 uzUTUB5Q
 X8mTx1vPlZ+cx8zv/znirFi6WnwklbgqWCqOnIaO2+iB771bCopML9dIO+L4VjCFgmiWZFR/5U6N24q679tbrYq8DhPdGBBuLzs+7inEt8b01PhiWe/qkpngE9gVHdyqL8vs89rDjTlBP8elpTr+Qrk+kSCFMPqgfLc0H0YRgYXFQLH9wBNVNB3rdP774LMlu23BzPsiMzqptOk2rHsUVdw9jI1b7ZrDkDpURpXPNlNdf35StghWSJQlmN9w9VfNGpQ00VivKnkcuulB/zNQjH05lN54qT+WQYNq8ti+r/bujANbFprXYUiiDSPfwf3Fwl4oT2redF54votDX6U7DlvkhcJxfGzHNtj5xIQBRoT9hcTy4DrlNkulTm2gQNbq1qKbwQ7E7GkrmgkLsCSbHWMXLMlPddrh8qHge+8knPtg2ChBXi/lXsjXd4w6PlBp5cog6hf9R8NIKVjdr0hCTPG2hYHDYd80qM0vE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The existing rcu_segcb_stats tracepoint requires active tracing, so
there is no always-on, low-overhead way to inspect how many callbacks
are pending on each CPU and at which stage of the grace-period
pipeline.

Add a debugfs file at /sys/kernel/debug/rcu/pending_cbs
that prints per-CPU callback counts broken down by segcblist segment,
plus a "total" row aggregating across CPUs:

  - done:       Callbacks ready to invoke (GP completed).
  - wait:       Callbacks waiting for the current GP.
  - next_ready: Callbacks to be handled by the next GP.
  - next:       Newly queued callbacks not yet assigned a GP.
  - lazy:       Callbacks deferred via the RCU lazy mechanism.

The interface has zero steady-state overhead: it reads the existing
per-CPU rcu_segcblist.seglen[] counters on demand. These counters are
already maintained by the RCU callback infrastructure for its own
bookkeeping, so no new runtime accounting is introduced.

Example output:
  cpu            done       wait next_ready       next       lazy
  0                 7         11          0          0          0
  1                 0          3          2          0          0
  2                 0          1          8          0          0
  3                 0          1          1          0          0
  total             7         16         11          0          0

Signed-off-by: Gustavo Luiz Duarte <gustavold@gmail.com>
---
 kernel/rcu/tree_stall.h | 67 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 67 insertions(+)

diff --git a/kernel/rcu/tree_stall.h b/kernel/rcu/tree_stall.h
index b67532cb8770..d9fc9bfdaf96 100644
--- a/kernel/rcu/tree_stall.h
+++ b/kernel/rcu/tree_stall.h
@@ -71,6 +71,73 @@ late_initcall(kernel_rcu_stall_sysfs_init);
 
 #endif // CONFIG_SYSFS
 
+#ifdef CONFIG_DEBUG_FS
+
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+
+/*
+ * Debugfs interface for displaying per-CPU RCU callback counts broken down
+ * by callback-list segment.  This allows monitoring how many callbacks are
+ * waiting for grace periods without any steady-state overhead.
+ */
+static int rcu_pending_cbs_show(struct seq_file *m, void *v)
+{
+	int cpu;
+	long done, wait, nxtrdy, nxt, lazy;
+	long total_done = 0, total_wait = 0, total_nxtrdy = 0;
+	long total_nxt = 0, total_lazy = 0;
+	struct rcu_data *rdp;
+	struct rcu_segcblist *rsclp;
+
+	seq_printf(m, "%-8s %10s %10s %10s %10s %10s\n",
+		   "cpu", "done", "wait", "next_ready", "next", "lazy");
+
+	for_each_possible_cpu(cpu) {
+		rdp = per_cpu_ptr(&rcu_data, cpu);
+		rsclp = &rdp->cblist;
+
+		if (!rcu_segcblist_is_enabled(rsclp))
+			continue;
+
+		done   = rcu_segcblist_get_seglen(rsclp, RCU_DONE_TAIL);
+		wait   = rcu_segcblist_get_seglen(rsclp, RCU_WAIT_TAIL);
+		nxtrdy = rcu_segcblist_get_seglen(rsclp, RCU_NEXT_READY_TAIL);
+		nxt    = rcu_segcblist_get_seglen(rsclp, RCU_NEXT_TAIL);
+		lazy   = READ_ONCE(rdp->lazy_len);
+
+		seq_printf(m, "%-8d %10ld %10ld %10ld %10ld %10ld\n",
+			   cpu, done, wait, nxtrdy, nxt, lazy);
+
+		total_done   += done;
+		total_wait   += wait;
+		total_nxtrdy += nxtrdy;
+		total_nxt    += nxt;
+		total_lazy   += lazy;
+	}
+
+	seq_printf(m, "%-8s %10ld %10ld %10ld %10ld %10ld\n",
+		   "total", total_done, total_wait, total_nxtrdy,
+		   total_nxt, total_lazy);
+
+	return 0;
+}
+DEFINE_SHOW_ATTRIBUTE(rcu_pending_cbs);
+
+static struct dentry *rcu_debugfs_dir;
+
+static int __init rcu_debugfs_init(void)
+{
+	rcu_debugfs_dir = debugfs_create_dir("rcu", NULL);
+	debugfs_create_file("pending_cbs", 0444, rcu_debugfs_dir,
+			    NULL, &rcu_pending_cbs_fops);
+
+	return 0;
+}
+late_initcall(rcu_debugfs_init);
+
+#endif // #ifdef CONFIG_DEBUG_FS
+
 #ifdef CONFIG_PROVE_RCU
 #define RCU_STALL_DELAY_DELTA		(5 * HZ)
 #else

-- 
2.53.0-Meta


