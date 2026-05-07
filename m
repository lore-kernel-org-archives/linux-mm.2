Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B7A0CD343F
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 17:37:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CB376B008C; Thu,  7 May 2026 13:37:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 656196B0092; Thu,  7 May 2026 13:37:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E5A56B0093; Thu,  7 May 2026 13:37:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2D0366B008C
	for <linux-mm@kvack.org>; Thu,  7 May 2026 13:37:29 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B2E6DC209B
	for <linux-mm@kvack.org>; Thu,  7 May 2026 17:37:28 +0000 (UTC)
X-FDA: 84741330576.22.EC5811A
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf04.hostedemail.com (Postfix) with ESMTP id C768D40007
	for <linux-mm@kvack.org>; Thu,  7 May 2026 17:37:26 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NgPXcpcM;
	spf=pass (imf04.hostedemail.com: domain of gustavold@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=gustavold@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778175446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7VghPIaZzCAjxosZReVf3XTbKbvkZLjDIPPTIuyF9bg=;
	b=tNe/nYg5QIugh1xcMzPJzw6KmJJfdKGCAWptIEKRlzq1wYv5SJ0ymPp1TU6eM0Ndq3re+b
	gpb+ljkzaGTbeqgzJ4TUNY0tiohHk8XSdP/Ez8gGchUz8BQtLO20FaZ/E7JcHhdpExtSBe
	56wiJBXBVSjNjtkqlJiBT7tP+uc4WAk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NgPXcpcM;
	spf=pass (imf04.hostedemail.com: domain of gustavold@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=gustavold@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778175446; a=rsa-sha256;
	cv=none;
	b=rBG7V+Cwf8PM2NztxxC7BYeFrXZ19zu97Qw3RQ80S/bYavxiouhXSw2fLwrPu1AsSuKnH5
	aOyrbAG8xz1SjYPhVKG39MLpdiQJ6aB5MRg6xxDfYf5OtSTEj87UhmhPcEX/zYp4Up67jT
	UkF2+vu2+BL8MI0Ql3JJMNGG+AKPHRE=
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-44a786a9b8aso128796f8f.0
        for <linux-mm@kvack.org>; Thu, 07 May 2026 10:37:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778175445; x=1778780245; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7VghPIaZzCAjxosZReVf3XTbKbvkZLjDIPPTIuyF9bg=;
        b=NgPXcpcM5gZx0j+0IpvyqhWtRPWtnEaLNwmBxt9LvEW1Mdp+Hhtq1fNu7gpJ7Rssbu
         YSBiy/t7hsV3FJtxShYrf/UYoFxiNGB56v1lg8tIG50Ano3su4YETqXGRK8zoeV8IMqQ
         3x0IkzaLEVj5hqiSF+L5UWax3saFETEaY5gw4JeNKiAsx7TLuJ/J4nmFIvf2VOfqYzZW
         Xof8ScBTQImhosaJx+LD6AmnEvMzuMRWQtS3WavdmNA0lOVqxjygWRD+SLmVzA8L0Lv5
         ybbX3humgox9o5S6k5rv7bkNA1NNjzKMj8ueprp6g9ZFHnZWklpgEqSZK2ubGvLc7k5i
         9Z7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778175445; x=1778780245;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=7VghPIaZzCAjxosZReVf3XTbKbvkZLjDIPPTIuyF9bg=;
        b=jO38cS33Rr/3QxAmnMDRYn1sY8NHDB1FYAxMXHQB5/ldrKNsftHNTNDlFvP/4UnIlU
         o8FPeAzk0lzDDWG604JM8DnYz+Lj/lZnqKrPLQ283+f+gYs9AusKYvLXtXUs8y3dU75T
         qVbxiKinnfaRFHfDO+thj2OcwXUkHHYSU1BWKlS8xgMcqxu645ptgGJ9SzXGFtQ50ka3
         CO815BuG8Z5ygmZUrHbNy0K9fZ1q/5Pd/PIf9pf618BH7hlmM2z8R7nGPHsPYwTei6LR
         rGGfWlC0dhyNZEOsijw3jFbk7q1k6aRzPbtMbSInHnsQ5fjScfw9izIUVJpzA4Cgnzk4
         NXPA==
X-Forwarded-Encrypted: i=1; AFNElJ/wgjiQIMYTb74sofNLT865W22FXbfDTTNS7PZm3rxUxJTlExaq+Hrv8GrkPvFxAxPEC7ijuJVPlQ==@kvack.org
X-Gm-Message-State: AOJu0YytP4o5OMeBieCULOSpSj3xjPcecOgeA97sEyeC30CH95PXwxq4
	yA/CmaKqdiBovp3oEcnpJmwS35mjs7wXvnnm3a1YfwEIl9aIwfsCFEGN
X-Gm-Gg: AeBDievcyG5A2D3cc450qz7zKv7q2G2/P5LQT6Vxwsefag2KcldjQozOvmm8Q/vpnbN
	+qUHxYLtDrSplk10wW36wFoCeRXEPQPVGvaJQLkly5gQVXGVMZ9iXwbushqGqnackwYVDewnpZI
	P81hxInweX7yUAmG+mgzVl0lZN9PDmZ7RF0RRobWQETB3kq25Go1gbCSwdjsBzlBBJtXg+zwmb8
	o4fOCy12HXV2J0bwekSGHk8Mj34g8CXCu4tdY7E9mmm7/jVqugB0quSUCShYNhRCJvERvVOsmfk
	oTdUHCDKF4UFvOlRXvMADu54LvSbyy5UaQS7DNzYtqC6NBnZSIONlF/stPSaY+O8t5t5kwLJxUf
	mVjjpqPaH7uWpCXHWv1pzBCUR37qVuekwnMzoSXfDmVfqLaaERvCdmlraLWnrGqpQyiaofXII7U
	KSfKo41eda5+ObkDVMJz0aV9R5/Bi7eGy6j4BkNUSxPm9uEcP5
X-Received: by 2002:a05:600c:4f82:b0:489:1dc6:d6e with SMTP id 5b1f17b1804b1-48e5325025fmr65770315e9.1.1778175445266;
        Thu, 07 May 2026 10:37:25 -0700 (PDT)
Received: from localhost ([2a03:2880:31ff:2a::])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e64300592sm896785e9.13.2026.05.07.10.37.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2026 10:37:24 -0700 (PDT)
From: Gustavo Luiz Duarte <gustavold@gmail.com>
Date: Thu, 07 May 2026 10:37:08 -0700
Subject: [PATCH RFC 2/2] rcu: Include kfree_rcu/kvfree_rcu batched counts
 in pending_cbs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260507-rcu-pending-cbs-stats-v1-2-8f4eb3553bc9@gmail.com>
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
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C768D40007
X-Stat-Signature: k6cbukst7tkyuxqdst13ja84w5yrz319
X-HE-Tag: 1778175446-483676
X-HE-Meta: U2FsdGVkX18KR/wIRL4RuyNDbkPR+Zn5GOC6eQEiw9RvfwpCY+I+ZJtTcUlLlufYfSZfhcg+SJVV51aq8cDFjirvSB70ObDG1nlMbIULa86GA41ZX3iOtjLGHL/SghqB4qp6FzSzjgH9q5vSZNvzvc0+kUfry9ZHsOa9Pz9mnczJUcLsZrt/AZrhjN7lUbVQPyegf/aQFPdqwEWeLb/iRpCxbwxbGWSe8EfBEd3MJ5LSSHvJv7R9a4pR6S+nZCHrnTyca1m8o/lvk4VNatefcV8dCK2QYYUkUIp+XS+YlYfpoV3GjYhLlENQ8qoS4Ola3/d1lzVxs/bOJAuLLT6XXsTK9cqxvmQzx4jzqsYcQUESI3cTKAPErMmNIinK0kUCPv/vmQq9TdxDX8OR5of7CmzvSA044OUeZn1eSp8PZLHHJApmy4itlt08xEwsHfevsT/GED9DsMMwvo3lCX47lqemLropvrPxsyDjYWnQxohzE3u/Jxbv4BvKv52k14jkJep7U8YozYaUbFd39IFxeFojuptq2OsycROI1J+9oZKc5S6ziuxdUb8aMgLH0ab1TLhcfm/wCrCE2YVWRJryC2h/ztEoY2xCyoenmB31k9epoaaaqPQIGVIM70RJ0jNT15hYNSdrytseJXLocb6PhDe7m6PlmU28JerQFQvDdoHOvP8b5sxgBKJmiibCp56P+2HtlLN837UqCVRALsVa76fsOX1Kw4UfDbgKZqSIAQBUjS7ugluhngwWCCAbHCRxyZqEUHy4AN+ieXGEiavqZyfDlYGoah78M19GwpzSATojR7IzX6dLtoqBCm2f16qnXzQWM+pO8sQI4hw8+zoYEQzW9w3jJ3a35up222kPBMak2NJrRfsp4D2SSWTRvMFn9DCpD8NkuyAIoxfVojYDDu6VivANmoM9dtwZxQbI05EsSSQ4F0OKjuf5u3hSYa0745BrFjoi7J7aLmGj8Lq
 SHzon/WP
 oycC4g+qNQrlYrvK5A7h/GOneRfkc/pJ6kjyXk4LlmRdtyPMO4VF1XpWSPgBLekrlQT5cLB8kj83ZenK5Ih8wTKZZqbnjOkeZaR3KZzJFN+W1rMdKXeZSmt0J6KuAAg4yGoVskRlcgBhR/ZbIj3Y/VIiEP2GQdPvcB9ezb2sm0fZTC2w9YcAnsZN2K5Ep3uNGR5Ld+KPJ6PHZMcyiLymu8j1NSH213T0kKO4EjIQv+QJ30LUDsJ2c8Ek6f76Vw23yw9XlZfVpizkRDflLi3+hibBc2alzYmNR+EiOfM8y75s8zKoiPlaoP+nqKIw1C/oecJCMrd3wbUsTSrShI6VKWC78fxU/FZAdBSJCFeGJQiAV1Yjd3JJPa23oH3NtC2QJX865PhSPaR64ehs3FpFv/qcnpmE213Tg2R6rgqNHUVNIH1+pxHR6Ii2ZayE913slv2/xkm+4yZeo0Z+pJIFPVw0gvQQDzi4C3Ky4WXTv9jeRn5/fTmpUA4aIgoBoKWqHK+FGm4nHu7oPF27vKih3yt69hzTDBopUBwzjNbHGDNw9WWZVNBrNYqRo96MvVojaS00FibsPY1RsPZRzBq142UyT1cIuyqWtf2GvDRdKSxGkcgU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The batched kfree_rcu()/kvfree_rcu() path (CONFIG_KVFREE_RCU_BATCHED)
manages its own per-CPU queues in struct kfree_rcu_cpu, bypassing the
main RCU segmented callback list.  Objects queued through this path
were not visible in the debugfs pending_cbs file.

Add a kfree_rcu_pending() helper that returns the number of objects
waiting in the kfree_rcu batching layer for a given CPU, and include
this count as a "kfree_rcu" column in the debugfs output.

Example output:

  cpu            done       wait next_ready       next       lazy  kfree_rcu
  0                 0          0          0          5          5         12
  1                 0          0          0          3          3          8
  total             0          0          0          8          8         20

Signed-off-by: Gustavo Luiz Duarte <gustavold@gmail.com>
---
 kernel/rcu/rcu.h        |  1 +
 kernel/rcu/tree_stall.h | 17 +++++++++++------
 mm/slab_common.c        | 18 ++++++++++++++++++
 3 files changed, 30 insertions(+), 6 deletions(-)

diff --git a/kernel/rcu/rcu.h b/kernel/rcu/rcu.h
index fa6d30ce73d1..a28c3c7dc4da 100644
--- a/kernel/rcu/rcu.h
+++ b/kernel/rcu/rcu.h
@@ -652,6 +652,7 @@ void rcu_fwd_progress_check(unsigned long j);
 void rcu_force_quiescent_state(void);
 extern struct workqueue_struct *rcu_gp_wq;
 extern struct kthread_worker *rcu_exp_gp_kworker;
+int kfree_rcu_pending(int cpu);
 void rcu_gp_slow_register(atomic_t *rgssp);
 void rcu_gp_slow_unregister(atomic_t *rgssp);
 #endif /* #else #ifdef CONFIG_TINY_RCU */
diff --git a/kernel/rcu/tree_stall.h b/kernel/rcu/tree_stall.h
index d9fc9bfdaf96..5fd63730d5f5 100644
--- a/kernel/rcu/tree_stall.h
+++ b/kernel/rcu/tree_stall.h
@@ -84,14 +84,17 @@ late_initcall(kernel_rcu_stall_sysfs_init);
 static int rcu_pending_cbs_show(struct seq_file *m, void *v)
 {
 	int cpu;
+	int kfree;
 	long done, wait, nxtrdy, nxt, lazy;
 	long total_done = 0, total_wait = 0, total_nxtrdy = 0;
 	long total_nxt = 0, total_lazy = 0;
+	int total_kfree = 0;
 	struct rcu_data *rdp;
 	struct rcu_segcblist *rsclp;
 
-	seq_printf(m, "%-8s %10s %10s %10s %10s %10s\n",
-		   "cpu", "done", "wait", "next_ready", "next", "lazy");
+	seq_printf(m, "%-8s %10s %10s %10s %10s %10s %10s\n",
+		   "cpu", "done", "wait", "next_ready", "next", "lazy",
+		   "kfree_rcu");
 
 	for_each_possible_cpu(cpu) {
 		rdp = per_cpu_ptr(&rcu_data, cpu);
@@ -105,20 +108,22 @@ static int rcu_pending_cbs_show(struct seq_file *m, void *v)
 		nxtrdy = rcu_segcblist_get_seglen(rsclp, RCU_NEXT_READY_TAIL);
 		nxt    = rcu_segcblist_get_seglen(rsclp, RCU_NEXT_TAIL);
 		lazy   = READ_ONCE(rdp->lazy_len);
+		kfree  = kfree_rcu_pending(cpu);
 
-		seq_printf(m, "%-8d %10ld %10ld %10ld %10ld %10ld\n",
-			   cpu, done, wait, nxtrdy, nxt, lazy);
+		seq_printf(m, "%-8d %10ld %10ld %10ld %10ld %10ld %10d\n",
+			   cpu, done, wait, nxtrdy, nxt, lazy, kfree);
 
 		total_done   += done;
 		total_wait   += wait;
 		total_nxtrdy += nxtrdy;
 		total_nxt    += nxt;
 		total_lazy   += lazy;
+		total_kfree  += kfree;
 	}
 
-	seq_printf(m, "%-8s %10ld %10ld %10ld %10ld %10ld\n",
+	seq_printf(m, "%-8s %10ld %10ld %10ld %10ld %10ld %10d\n",
 		   "total", total_done, total_wait, total_nxtrdy,
-		   total_nxt, total_lazy);
+		   total_nxt, total_lazy, total_kfree);
 
 	return 0;
 }
diff --git a/mm/slab_common.c b/mm/slab_common.c
index d5a70a831a2a..93b5d64399f2 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -1280,6 +1280,11 @@ void kvfree_call_rcu(struct rcu_head *head, void *ptr)
 }
 EXPORT_SYMBOL_GPL(kvfree_call_rcu);
 
+int kfree_rcu_pending(int cpu)
+{
+	return 0;
+}
+
 void __init kvfree_rcu_init(void)
 {
 }
@@ -2216,4 +2221,17 @@ void __init kvfree_rcu_init(void)
 	shrinker_register(kfree_rcu_shrinker);
 }
 
+/**
+ * kfree_rcu_pending() - Return number of objects pending in kfree_rcu batches.
+ * @cpu: CPU number to query.
+ *
+ * Returns the number of objects queued in kfree_rcu()/kvfree_rcu() batches
+ * on @cpu that are waiting for a grace period.  These objects are tracked
+ * separately from the main RCU callback list.
+ */
+int kfree_rcu_pending(int cpu)
+{
+	return krc_count(per_cpu_ptr(&krc, cpu));
+}
+
 #endif /* CONFIG_KVFREE_RCU_BATCHED */

-- 
2.53.0-Meta


