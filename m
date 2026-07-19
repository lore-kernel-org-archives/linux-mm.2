Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE2E6C44512
	for <linux-mm@archiver.kernel.org>; Sun, 19 Jul 2026 18:55:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BB506B0088; Sun, 19 Jul 2026 14:55:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 794526B008C; Sun, 19 Jul 2026 14:55:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 548AD6B0088; Sun, 19 Jul 2026 14:55:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 66DD86B0088
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 14:55:26 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D5CC416061F
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 18:55:25 +0000 (UTC)
X-FDA: 85006429410.24.15A68A2
Received: from sender-pp-o93.zoho.in (sender-pp-o93.zoho.in [103.117.158.93])
	by imf02.hostedemail.com (Postfix) with ESMTP id 847E380002
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 18:55:23 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=KxhcUFcb;
	arc=pass ("zohomail.in:s=zohoarc:i=1");
	spf=pass (imf02.hostedemail.com: domain of adi.sharma@zohomail.in designates 103.117.158.93 as permitted sender) smtp.mailfrom=adi.sharma@zohomail.in;
	dmarc=pass (policy=reject) header.from=zohomail.in
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784487324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2WFeeZ7KFA8P2LraO+LyQSTzhNZOCYdC5G9o/v637Mc=;
	b=TW9ujaAtgiFl5K8dGMRr5blDxOEPZO1Lz7oI1rd720R2HuyewcES2OpUXhqUQSmIqefNjw
	cshRHXRtTSSWRrcqJwq0d9LqxH6wIjELF7v+L5csk+vX9KzrXatUkeTp/Tfm8QWTX6Cx6a
	Ophas/KOVeuZb7LJCOzfguKTlc6VUe0=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=KxhcUFcb;
	arc=pass ("zohomail.in:s=zohoarc:i=1");
	spf=pass (imf02.hostedemail.com: domain of adi.sharma@zohomail.in designates 103.117.158.93 as permitted sender) smtp.mailfrom=adi.sharma@zohomail.in;
	dmarc=pass (policy=reject) header.from=zohomail.in
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784487324;
	b=i/CTxbajHls4VAEd9QGkjonbZAA1tWQ2RFUAfbMMhCEX1uBvy8pQmeF6vv/UCgnYpeLS3M
	ZSyJ6wiZsPW7+OTBiDE2msYQi4PATNO/FiZA4/JofMFzFfxbCdY22BklyplgX2rpjJ1GU9
	bzrH8TBkub7+l5fs1gGPoxs1BnH4pz0=
ARC-Seal: i=1; a=rsa-sha256; t=1784487280; cv=none; 
	d=zohomail.in; s=zohoarc; 
	b=XEiIyIz5mE0Bp26X0wV6jXA/VaVEDP0Vsd8y+wtWApSpa0QnNb1QflaNTLWFhUnGhhhtxzfJCuzo0fiHM9keOIa6/HZdzmITOPROxQGgPC+KqksvGbqDzNUa3EBFq+euvnUukms+YSB2J5UPUhW16rYMvfndG0EowDoBNKl6VhE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
	t=1784487280; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=2WFeeZ7KFA8P2LraO+LyQSTzhNZOCYdC5G9o/v637Mc=; 
	b=N/saLD1un8BAWR2AyHmL00UBCNQGgS9/mzsoMKFPls2nqPvcQd+TE66HlrKt8RGiL89qVR9M5f6W4l12uUOC2nvBrukr1+OWVMMtyIRcFb7CXatipTkE8sSZF+7gU4erUjorKMdKAeU6W7rF8Y7xqAnl9zXd6GUjmF2aCGtfdpU=
ARC-Authentication-Results: i=1; mx.zohomail.in;
	dkim=pass  header.i=zohomail.in;
	spf=pass  smtp.mailfrom=adi.sharma@zohomail.in;
	dmarc=pass header.from=<adi.sharma@zohomail.in>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1784487280;
	s=zoho; d=zohomail.in; i=adi.sharma@zohomail.in;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:In-Reply-To:MIME-Version:Content-Transfer-Encoding:Reply-To;
	bh=2WFeeZ7KFA8P2LraO+LyQSTzhNZOCYdC5G9o/v637Mc=;
	b=KxhcUFcbC6fZlSEYws8W0Ligew3B89Dy34756H9Y+FnvLbM3HTHSHcq86uuSw8oE
	n0Ztxv6GW1uqGFGw83uoBxi03Di1KvQYhCIeLO3m80kIr5Uz1H/Sh6dVKWRaGyqsAVD
	lbsjcFg5UpRN2pbF/Is6Fg7wpUjH+nwu2Tyjw80g=
Received: by mx.zoho.in with SMTPS id 1784487278994775.8847779555358;
	Mon, 20 Jul 2026 00:24:38 +0530 (IST)
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
Subject: [RFC PATCH 1/7] mm: add CONFIG_ASYNC_MM_TEARDOWN scaffolding for off-CPU exit teardown
Date: Mon, 20 Jul 2026 00:24:03 +0530
Message-Id: <20260719185409.409685-2-adi.sharma@zohomail.in>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260719185409.409685-1-adi.sharma@zohomail.in>
References: <20260719185409.409685-1-adi.sharma@zohomail.in>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 847E380002
X-Stat-Signature: g669d3gwh51tyeje1z8tktr1toitgxfp
X-HE-Tag: 1784487323-796190
X-HE-Meta: U2FsdGVkX1/SeMofqZsVCNJAWo2WEBMLHbSbw333CEriBxuBZfkqUmaIDtC8g5cHRHQ+Fi6gsxDUY/EzsXCM5hoDFEIn+aF7Lid4qAt6y5KxL8j+hN385Gg/XSHyV97R4294/qpyGdkAusM5Ab7AV1NX4dnpL7BHrByLKimRd17Z0S4uJB2TLzxggWSUORZMLlU43JkdAmlS1I9oKTvotvBMnB7SeJXAyhuTS3vV4ZPylhi+9+y3jBtoMXalEoLTy+87tUOnLUYm/2iBc0vHBj8Z56WnaYfi2GHtuAwkTndTy8yIyhbQZdyLpfhq+bjSCShRebGuIxX3PY7KW3zHSjG075U93skNjT1EP/LnX/lGWRhpR8wd6KIsS+e1IrtQnNpitdm1xCfltKhtnTa5df3FiyPCmbJEjtxaQgj+kF8MVUSjiRBrMIhzpAW22VWhe+n47YZjciT3YVvrWJM9pVgTp1Tr4cIHckbqUTVbIWY1nXC/rHLqBNhJJCC/K9MkSadvzHe1vOSdDHLga+B2Wlf4acZtAUpW9hf8LtbXx9rykh3VeP/dRItd6zxRg/5qqf2CCe+NUdag8t/dGJ12QnJ6IQsomGEuMHh8PJtmdBZVVIQCSLQnch5HZBp/cvYi/RWDgicifIG3OrdezAVTMuo/pkqf7fw3t2AYR5t+A7+KRcWLwpSyPxK85RHwGL8JoE/VShE+jE6IvUs32MKSqfMgAudJ4W37Rn0APCOBy1l46DogKqukJuxXzK0+1mt2pkZi9PekDdNoyz+9PKpacPPNsi8Sha2bFZn4u6DfcgZ//OadM93n2dFzV+wTs6JBEtebfzngnrHrlkQUybcjImNaBAqzPEIX9BWlJ//FF8xIn4hRHXthKrnWpbATFmx6AB6o+O8VDLdvJMjAo6O7vtWNqdL/2GfXYd47fpQJhHGj6TrRKhMeNB6IQ/Ax/LcP/QWtH5BNAznIAayCjkk
 3Hh8uxVn
 WXuej1FTPO9r6Fb2NflEwSIeACwmO5CY3P3DLP0ec7F+fo4cyesZUrztXnoMZz1jb/h3VjNzICbXvifZbbitGiF0Wyt5dDZpRT62sRn91gM4ySj2TCFQQ4Y6iAdOz0FxgHvLF6/r9u4tNhLb3CSCF3v7DVG9ny2IbSAouB/OmudLudyJFaSlkzf8elj6R6kG75ALThuy8Kw5auBH5driFhRA5GPaOnUYtAp3JYZzTukQ5uiDoTSnAPrnJ0JH5Zm0cIvE7B+X6C+46zWlqy+yVcCj4t8hNULQDex2FpjeEZKILvP4HEm2qItc0P99JOM3GRBkd8gpZaBkmCEsn5Pd4DvP2WwhFYOm8mMFDCLxpAFgR88M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Address-space teardown on process exit runs synchronously in the dying
task's context: exit_mm() -> mmput() -> __mmput() -> exit_mmap() walks
page tables, updates rmap, frees the RSS and drops file refs, all on the
exiting CPU.

Add the scaffolding to later move __mmput() off-CPU for large exiting
address spaces, with no functional change in this patch:
  - new config ASYNC_MM_TEARDOWN (bool, depends on MMU, default n)
  - struct mm_struct::async_reap_node (llist_node), CONFIG-gated, with
    an explicit <linux/llist.h> include (it was only ever available
    transitively via spinlock.h)
  - mmput_exit() declaration, with a static inline fallback that is a
    plain mmput

When the config is disabled mmput_exit() compiles to mmput() with zero
delta, so nothing changes until the kthread and dispatch land.

Signed-off-by: Aditya Sharma <adi.sharma@zohomail.in>
---
 include/linux/mm_types.h |  4 ++++
 include/linux/sched/mm.h |  6 ++++++
 mm/Kconfig               | 11 +++++++++++
 3 files changed, 21 insertions(+)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 939b5ea8c..fffa285ef 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -7,6 +7,7 @@
 #include <linux/auxvec.h>
 #include <linux/kref.h>
 #include <linux/list.h>
+#include <linux/llist.h>
 #include <linux/spinlock.h>
 #include <linux/rbtree.h>
 #include <linux/maple_tree.h>
@@ -1367,6 +1368,9 @@ struct mm_struct {
 		atomic_long_t hugetlb_usage;
 #endif
 		struct work_struct async_put_work;
+#ifdef CONFIG_ASYNC_MM_TEARDOWN
+		struct llist_node async_reap_node;
+#endif /* CONFIG_ASYNC_MM_TEARDOWN */
 
 #ifdef CONFIG_IOMMU_MM_DATA
 		struct iommu_mm_data *iommu_mm;
diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
index 10be8a54b..20aeb1d7e 100644
--- a/include/linux/sched/mm.h
+++ b/include/linux/sched/mm.h
@@ -147,6 +147,12 @@ extern void mmput(struct mm_struct *);
 void mmput_async(struct mm_struct *);
 #endif
 
+#ifdef CONFIG_ASYNC_MM_TEARDOWN
+void mmput_exit(struct mm_struct *);
+#else
+static inline void mmput_exit(struct mm_struct *mm) { mmput(mm); }
+#endif
+
 /* Grab a reference to a task's mm, if it is not already going away */
 extern struct mm_struct *get_task_mm(struct task_struct *task);
 /*
diff --git a/mm/Kconfig b/mm/Kconfig
index c52ab6afc..296b16ad4 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1500,6 +1500,17 @@ config LAZY_MMU_MODE_KUNIT_TEST
 
 	  If unsure, say N.
 
+config ASYNC_MM_TEARDOWN
+	bool "Async off-CPU address space teardown on exit"
+	depends on MMU
+	default n
+	help
+	  Defer the address space teardown (exit_mmap()) of large exiting processes
+	  to a kernel thread instead of running it on the exiting CPU. The feature
+	  is off by default.
+
+	  If unsure, say N.
+
 source "mm/damon/Kconfig"
 
 endmenu
-- 
2.34.1


