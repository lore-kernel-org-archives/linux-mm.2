Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 271EAC79FBF
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 17:16:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C96B6B0099; Thu, 10 Sep 2026 13:16:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17ADF6B009B; Thu, 10 Sep 2026 13:16:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0422F6B009D; Thu, 10 Sep 2026 13:16:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C00816B0099
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 13:16:41 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D4FF5120461
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 17:16:40 +0000 (UTC)
X-FDA: 85198506960.23.2CC3857
Received: from mail-yx2-f8.google.com (mail-yx2-f8.google.com [74.125.224.136])
	by imf08.hostedemail.com (Postfix) with ESMTP id ED8AB160012
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 17:16:38 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sF5WwGEn;
	spf=pass (imf08.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.224.136 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789060598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zMEUYLHKFTDtmBUPkol17qRzghIejz62eMVx/UbdsHE=;
	b=IIQWYAZzcQ00jxh/Nj7XFBr78+Qe3FmsuyyirHj8HnSiBT/l5ABa6hePESZpCjW5eGNjqy
	AVv+f4/SLAJhBodTTNKVxZyoXQGRwulo1JRWhNinEm0U+I+4g+LL0yGhV82Sqk/7MJ12UI
	txzf+lJmPVfvph9bQHPtfmC/2JBCjns=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789060598;
	b=GG1hWBcBNYGDc3Nmezxh1GY3FU0QFrfMr96XTL2l3Re5fWr6Ot4X/atjeM6k3t6Rk5s97L
	U4A079kEynefzO52cTbFcQv8OMoLx+gU9UQZHNpKI2VS0PdOnGLtbvorLdU3to06Z/Cfo+
	5n23MHX2OON4DHs7ZniPJWENZyEQhvI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sF5WwGEn;
	spf=pass (imf08.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.224.136 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yx2-f8.google.com with SMTP id 956f58d0204a3-66cde2e181cso2538112d50.0
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:16:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789060598; x=1789665398; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zMEUYLHKFTDtmBUPkol17qRzghIejz62eMVx/UbdsHE=;
        b=sF5WwGEnt/+D71ZZBZrabRCZYtbPdvxiIP2HQCKS2u2JACCv3g+HArzGPq/lQkEjUv
         4afb8ve7vg8DOWEyZMGjBspm3LYmceeluFIxpFIoLjuBCEW6+IMG7v4pohUZ4A63MedA
         TeAL3ZWj8meZQmZhSviTzewtChOMFNHejYuds/HRugSeJ1lQK44FcJFZcLEZlONlpBwP
         8KQnujUXeRcxZyU0Ze3JcoJzc59EG2dXq02dBqywEcSVHS28jgYUcaspXHUhsvFl4NEe
         I/ar4XRex7xUmNiNqr+yZ9/NJmco0L6dben6qVZiY1pprL0iyEoKW+abkW85NbZD2iv/
         DGfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789060598; x=1789665398;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zMEUYLHKFTDtmBUPkol17qRzghIejz62eMVx/UbdsHE=;
        b=D6Fj30d0+Xaj6JmkfskUfD+zE9wXtC5WNxjy3uwJD5HeS+QOSoa7ELgfDVxFOTANHq
         EfxLWk5HhFoVJ74erqkrS1JY46+j2K+KjZ7iuCnDtq/iHGh/fHZ8lt89uDD63QVMASQ+
         IpeAS+tQPU7cgbpXKbqlpIf8FJRLygLeXPuA3j0MAjxMWDJurM4ap5B+6PQUT43h0re8
         saN0DC7D7sJdQXyt2O4JmWfkvHaLpbsgvhPGF0F3Vnv3FuGH64BDy3ooeep12p32NaOF
         E2WryM0rK4PaWUFUg0braD8Zel8HvygscZbHCj/WcyF/mIidxu6fCowsSJqZl6XlCBs+
         FYEA==
X-Forwarded-Encrypted: i=1; AKwUvByUBsA8kYL35bymcDLJ9Oud6wxB6SVHfSlJOou/a3amXL/1Am4ntmKnpA2+/PgJOGVU+FKUMb7u6Q==@kvack.org
X-Gm-Message-State: AFuF++kujeMb4eGyuLj7c9EJR4Pm5DTIv0aihVbbEroNQjMhtuQ2UL7b
	Zod578UrkOJpPMTaH5ROFHAvh4tc1ewq8DhKfgNJcJbGre8ka0v9KmY=
X-Gm-Gg: AYBFou0it6CTzhTy9Fad6a+oA1VC0CG1GhYnYz3N7nf73yva6TallgQ+PDguF7OEYHn
	+UDPhvo30gE6vkBLLmuPkp118DanxSDbet0v4iLUxMNWs5+nrG+kD45tbcDn+dXK1RuNnnfzoU1
	hayfHTV7RjKdvyuKqg62d9rZac0hO7nt+iMNNJDiDun5lUpopuvWD6Ii4OSLpa6ORvtVkHdcmjj
	lFf15KY4ou6rKqvyfy/1CxvJK/S1VMiTq/1kEju6NrJH3ntUu1Pst5t5o+nxZigjK7iCh5XEjAO
	C2RvPZAcAK6SpWx9a70Z0gSu3J9Dcm2vEt+oLkfbDOmCuN87cCizXATZYo38zP4rlpvPUwrOFCK
	FkyJyQKTXCUQU6BCpe3rATklNyNXqAg3gve0PjN+nhgg7L/hhzU6w7wpw7R63M3HwMIgEj80ZVi
	N9+KYfg0ITeYz/qgw+F5s5TH9eZJrEPYG7UVtd1M3ZJF2LXlAjA94rT1e/c90SsZ3Wr60Qmrh46
	BZElS+aK5JXFYU0e/a6HQc05hB/K87geH5YSt5ci8WsvV5oaEk=
X-Received: by 2002:a05:690e:2386:b0:66e:5f27:b411 with SMTP id 956f58d0204a3-671246e41afmr92855d50.42.1789060597587;
        Thu, 10 Sep 2026 10:16:37 -0700 (PDT)
Received: from localhost (23-116-43-216.lightspeed.sntcca.sbcglobal.net. [23.116.43.216])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-66fb4939b30sm14271624d50.15.2026.09.10.10.16.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 10:16:37 -0700 (PDT)
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
To: sj@kernel.org,
	akinobu.mita@gmail.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org
Cc: akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com,
	ravis.opensrc@gmail.com,
	rientjes@google.com,
	weixugc@google.com,
	jic23@kernel.org,
	gourry@gourry.net
Subject: [RFC PATCH v2 5/9] mm/damon/core: add per-probe-class report rings and unified drain
Date: Thu, 10 Sep 2026 10:16:19 -0700
Message-ID: <20260910171623.6638-6-ravis.opensrc@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260910171623.6638-1-ravis.opensrc@gmail.com>
References: <20260910171623.6638-1-ravis.opensrc@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ihyyf9rxprtuq953br9tn3mkjct3jjj7
X-Rspam-User: 
X-Rspamd-Queue-Id: ED8AB160012
X-Rspamd-Server: rspam03
X-HE-Tag: 1789060598-358448
X-HE-Meta: U2FsdGVkX1/KRCHffEam2wVpYSWHiuyJcO3hzrmq8KG7pOnB0rs0toEpgWUEyK9G1Ac6mp7AEIO+6mkTinJDisXFpBgwdz7qzbTYhzlhqGbFJxT7eN2GJ4Y/WgdMHxIHVdSAfZV03qsiQiVldrDhgkWZ1FyjnV5p+McjeLYPZ/QiNWkKEjijqCtOV6CKrZml7Nnu1SFqSbbSPJqM5Jf1Gu2Ob3lPAo1w9l5ANu9n+XOhS5lNS2es+M/7lTJgZT54MvumbjXFPjGZVdZ7Qj39B/2477mtcuvDid637ugrHhiy9iyQjVtNYofHUy8jEwWZtOTvrMmiktFm/khnzxc7pXJH8u+E25yJ2fARnq3LReftnrlJio4Zep42M5HFRrqbYkFINnU9Z0cHUrtQgx8fn6O0A/Rqn51RkkRNKjKQQLr14FmhDPDIN2yiwbJbU2ZXtWpu4kufygr4Ar9jPiNDm0j+fgspTwySpdYvR9yO/Wze2PUTaiJZ+r/7wH+fQCI3bfGrMH607rOQZhrK7Y0GpzVDjjiqJJleX0z9szSpk/gPTo4ngo0o8ZsFn5tEnwFORQq58OezL+uHoQhjWnrUbbYUPJ1YjicDSqV1wkzyAGrLsptEcdxuQMeeLiIBbD/5uRzkIM/AhLFhSwHfP2QxRedb60ZsxxrV6ybB+ysZJtDcaqEW/HDzUc+4xN/6jDkgwSPZrPgMkdcI1MDwUyjLVJbEmUe0yGkgRXF33VCiy5fNpvF5JU3xkvtLgke1SGhBI5gzK7LBMdjwl49BuTGk6HAoi3SeR9pewIt2p7VqEN+zs1Xf3vtighW44hZZMHWA9AsPjdw0NW8Yy0R8ZsywGEZ8xlAHQSpsJVg7fr2PpPlm2A7oHDbpr5HPcaPm4agEXQThI87ZPYUuro1MOls8m6V++U63o5i3ieDSoyZHYZiuG2IkMYi2+yhSv11oJq/fJxsbZWRpjselHdfnYxi
 ZDJUs6AB
 xlF6gyHAlO0ikMHw8jY8Y4S0mLmUkmLI7NqAOZ8x2BInWXFEY0saXQU8tAnQrnzIgH9WDPBu1jgCJguImoMnphPiiKaJzDg4CkDZM52cq+3LSsLelY3/4/DXYSp4PqhJ6Att1T7LmobS8w2QDwABfF0gkgCG5ZiV4NCgZb6Est5wX4cFmi1mk1OiW/Xe/vWzPeO3us62B4mq3qvawfKpR4oVL3UPfF/bE4qVdm2JYKpQJnp6NnroxpdlwFvJ821XddwiB/oHRa8gsjuGcudzwy3uOpIUCMBNfoHrmtPQmvxKyqVJfadFB291N1DXZOtJ0pI0IEjMYXqQ91PMh2QCiffHOo4FRwT2YTKzz67Jiqm1k6ANWvIIEY/q2+p8U/neHVdVuI0IDfAZYArOL407LvtLMB/AxdZC4HCADSGUefJS8TJVy6OOUO0beKjxjzq3pfWiGnF8fxoRCmI3QaeqrnBp58VHfjuGi45r9RYh3I6j7Ds3pwhew9LdDUbjGZDwF5bVV12rjztwHowOC+iiqPn3SDCyRsx6K824efxN79j686rJhfxrd6osbfzpBOsL92NED
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_report_access() takes a mutex, so it cannot be called from NMI
context, which is where a perf-event overflow handler runs.  Provide
per-CPU SPSC rings instead, partitioned by the globally-meaningful
probe_idx boundary into two classes:

 - Page-fault reports (probe_idx == DAMON_PROBE_IDX_NONE) use a global
   per-CPU ring.  The page_fault primitive has no damon_ctx at report
   time, so a per-context ring is not expressible; the global ring is
   drained by the single context whose page_fault primitive is enabled.

 - Perf-event reports (probe_idx >= 1) use a per-context per-CPU ring.
   The overflow handler carries a pointer to its owning ctx, so each
   perf-driven context enqueues into and drains only its own ring, and no
   cross-context ring owner is needed.

The per-ctx perf ring is allocated when the first perf probe is armed and
freed in damon_destroy_ctx() after all perf events are released, so no
in-flight NMI can reach freed storage.

damon_report_access() routes each report to the global pf ring or to the
report's ctx perf ring by probe_idx, sharing one copy of the NMI-safe
publish sequence so the barrier pairing cannot drift between the two.
Each ring has a per-CPU busy counter to detect and drop re-entrant NMI
nesting on the same CPU.  The producer writes the entry, issues smp_wmb(),
then advances head with WRITE_ONCE(); the consumer reads head and pairs
with smp_rmb() before reading the entry.

Add the kdamond consumer, kdamond_check_reported_accesses(): a dispatcher
that drains the ring(s) the context's enabled primitives feed, with the
per-ring drain body parameterised only by ring and pending mask.  Each
entry carries its own probe_idx, so the drain resolves the probe_hits[]
slot without a list walk.  damon_drains_ring_pf() and
damon_drains_ring_perf() name which ring a context drives, so which ring
is drained and which access-check path runs follow from the enabled
primitive rather than from whether probe weights are set.

Build a per-target sorted region snapshot once per drain so each entry is
matched to its region by binary search rather than a linear region walk.
Reports straddling a region boundary are rejected.  The address space of
the monitoring target selects which address of a report is matched, so a
context whose targets carry a pid matches the virtual address and the
others match the physical address; a report carrying no address for that
space is dropped.  For pid-target contexts, filter by thread group id so
entries from unrelated processes are not credited to the wrong target.  The
report carries that id in a field of its own, beside the thread id the
threads type sample filter matches against.

Ownership of the global pf ring is enforced under damon_lock at
damon_start(), on the live commit path, and cleared on kdamond exit.  The
perf ring needs no such guard because it is per-ctx.  Staleness uses
sample_interval rather than aggr_interval, so stale data does not inflate
hot scores across aggregation boundaries.

Co-developed-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
---
 include/linux/damon.h | 106 +++++-
 mm/damon/core.c       | 820 ++++++++++++++++++++++++++++++++++++------
 2 files changed, 817 insertions(+), 109 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 33929a400aa7a..88a459a60b296 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -6,6 +6,7 @@
 #ifndef _DAMON_H_
 #define _DAMON_H_
 
+#include <asm/local.h>
 #include <linux/math64.h>
 #include <linux/memcontrol.h>
 #include <linux/mutex.h>
@@ -17,9 +18,19 @@
 #define DAMON_MIN_REGION_SZ	PAGE_SIZE
 /* Maximum number of monitoring probes. */
 #define DAMON_MAX_PROBES	(4)
+/*
+ * Sentinel value for damon_access_report.probe_idx: 0 means no probe
+ * attribution (matches zero-init of struct damon_access_report on the stack).
+ * Perf-event probe indices start at 1.
+ */
+#define DAMON_PROBE_IDX_NONE	0
 /* Max priority score for DAMON-based operation schemes */
 #define DAMOS_MAX_SCORE		(99)
 
+/* Per-CPU SPSC ring: size must be a power of two. */
+#define DAMON_REPORT_RING_SIZE	256
+#define DAMON_REPORT_RING_MASK	(DAMON_REPORT_RING_SIZE - 1)
+
 /**
  * struct damon_addr_range - Represents an address region of [@start, @end).
  * @start:	Start address of the region (inclusive).
@@ -110,7 +121,15 @@ struct damon_target {
  * @size:		The size of the accessed address range.
  * @cpu:		The id of the CPU that made the access.
  * @tid:		The task id of the task that made the access.
+ * @tgid:		The thread group id of the task that made the access.  A
+ *			monitoring target created for a process carries this id,
+ *			so it is the id a report is matched against.
  * @is_write:		Whether the access is write.
+ * @probe_idx:		Index into probe_hits[] for the reporting probe; set by
+ *			the perf-event overflow handler so the drain can credit
+ *			the correct slot without a list walk.
+ *			0 is reserved (no probe attribution; matches zero-init);
+ *			perf-event probe indices start at 1.
  *
  * Any DAMON API callers that notified access events can report the information
  * to DAMON using damon_report_access().  This struct contains the reporting
@@ -122,11 +141,53 @@ struct damon_access_report {
 	unsigned long size;
 	unsigned int cpu;
 	pid_t tid;
+	pid_t tgid;
 	bool is_write;
+	int probe_idx;
+	/*
+	 * Owning context for perf-event reports (probe_idx >= 1): the overflow
+	 * handler sets this so the producer enqueues into that ctx's own perf
+	 * ring.  NULL for page_fault reports (probe_idx == DAMON_PROBE_IDX_NONE),
+	 * which route to the global pf ring by address at drain time.
+	 */
+	struct damon_ctx *ctx;
 /* private: */
 	unsigned long report_jiffies;	/* when this report is made */
 };
 
+/**
+ * struct damon_report_ring - Per-CPU SPSC ring for NMI-safe access reports.
+ *
+ * @head:	Write index; updated by the NMI producer.
+ * @tail:	Read index; updated by the kdamond consumer.
+ * @entries:	Ring buffer entries.
+ *
+ * One ring per CPU: page-fault reports use a global set, and each context
+ * with a perf-event probe has its own set.  The producer (NMI overflow
+ * handler) writes to @head; the consumer (kdamond) reads from @tail.  Both
+ * indices are unsigned and wrap modulo DAMON_REPORT_RING_SIZE.
+ */
+struct damon_report_ring {
+	unsigned int head;	/* written by producer (NMI) */
+	unsigned int tail	/* written by consumer (kdamond) */
+		____cacheline_aligned_in_smp;
+	struct damon_access_report entries[DAMON_REPORT_RING_SIZE]
+		____cacheline_aligned_in_smp;
+};
+
+/*
+ * struct damon_target_lookup - Cached, sorted region snapshot for one target.
+ * @regions:	Array of region pointers, sorted by ar.start (address order).
+ * @nr_regions:	Number of entries in @regions.
+ *
+ * Built once per aggregation tick by damon_build_target_lookup() so the ring
+ * drain can binary-search a target's regions instead of walking the list.
+ */
+struct damon_target_lookup {
+	struct damon_region **regions;
+	unsigned int nr_regions;
+};
+
 /**
  * enum damos_action - Represents an action of a Data Access Monitoring-based
  * Operation Scheme.
@@ -874,6 +935,7 @@ struct damon_filter {
  */
 struct damon_probe {
 	unsigned int weight;
+	bool event_driven;	/* hits arrive via ring drain, not apply_probes */
 /* private: */
 	/* Preparation actions to apply to each probing memory. */
 	struct list_head preps;
@@ -1090,6 +1152,34 @@ struct damon_ctx {
 
 	/* @rnd_state:	Per-ctx PRNG state for damon_rand(). */
 	struct rnd_state rnd_state;
+
+	/* Reusable drain-loop snapshot buffer (avoids per-tick kmalloc). */
+	struct {
+		struct damon_target_lookup *lookups;
+		unsigned int nr_lookups;
+		struct damon_region **region_buf;
+		unsigned int region_buf_cap;
+	} drain_snapshot;
+
+	/*
+	 * Per-context perf-event report ring.  Unlike the page_fault primitive
+	 * (which has no ctx at report time and so uses a global ring), a perf
+	 * overflow handler is armed by -- and carries a pointer to -- its owning
+	 * ctx (damon_access_report.ctx), so its reports route to this per-ctx
+	 * ring.  This gives full per-context isolation (two perf-driven ctxs
+	 * never share a ring) and removes any need for a cross-ctx perf ring
+	 * owner guard.
+	 *
+	 * Allocated lazily when the first perf probe is armed
+	 * (damon_ctx_alloc_perf_ring, from damon_perf_probe_setup) and freed in
+	 * damon_destroy_ctx() AFTER all perf events are released, so no in-flight
+	 * NMI can reach freed storage.  perf_rings == NULL means "no perf ring
+	 * yet" and any perf report is dropped, so a build/config without a perf
+	 * source simply never allocates it (lazy alloc = zero cost when unused).
+	 */
+	struct damon_report_ring __percpu *perf_rings;
+	int __percpu *perf_ring_busy;
+	cpumask_t perf_pending;
 };
 
 /* Get a random number in [@l, @r) using @ctx's lockless PRNG. */
@@ -1208,6 +1298,7 @@ void damon_destroy_filter(struct damon_filter *f);
 
 struct damon_probe *damon_new_probe(void);
 void damon_add_probe(struct damon_ctx *ctx, struct damon_probe *probe);
+bool damon_has_event_driven_probes(struct damon_ctx *ctx);
 
 struct damon_region *damon_new_region(unsigned long start, unsigned long end);
 unsigned int damon_nr_accesses_mvsum(struct damon_region *r,
@@ -1297,7 +1388,8 @@ int damon_kdamond_pid(struct damon_ctx *ctx);
 int damon_call(struct damon_ctx *ctx, struct damon_call_control *control);
 int damos_walk(struct damon_ctx *ctx, struct damos_walk_control *control);
 
-void damon_report_access(struct damon_access_report *report);
+bool damon_report_access(struct damon_access_report *report);
+int damon_ctx_alloc_perf_ring(struct damon_ctx *ctx);
 #ifdef CONFIG_MMU
 void damon_report_page_fault(struct vm_fault *vmf, bool huge_pmd);
 #else
@@ -1311,16 +1403,22 @@ int damon_set_region_system_rams_default(struct damon_target *t,
 				unsigned long addr_unit,
 				unsigned long min_region_sz);
 
-#ifdef CONFIG_ACMA
 
+unsigned long damon_get_report_overflow(void);
+unsigned long damon_get_report_ring_full(void);
+unsigned long damon_get_report_busy_drop(void);
+unsigned long damon_get_samples_drained(void);
+unsigned long damon_get_samples_stale_drained(void);
+unsigned long damon_get_samples_no_region(void);
+#ifdef CONFIG_ACMA
 unsigned long damon_alloced_bytes(void);
-
 #endif
 
 #else	/* CONFIG_DAMON */
 
-static inline void damon_report_access(struct damon_access_report *report)
+static inline bool damon_report_access(struct damon_access_report *report)
 {
+	return false;
 }
 static inline void damon_report_page_fault(struct vm_fault *vmf, bool huge_pmd)
 {
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 6b56a3e961c4e..850880f791c9e 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -22,22 +22,136 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/damon.h>
 
-#define DAMON_ACCESS_REPORTS_CAP 1000
+/*
+ * Report rings are partitioned by the globally-meaningful probe_idx boundary,
+ * and the two classes live in different places:
+ *
+ *   page-fault reports (probe_idx == DAMON_PROBE_IDX_NONE, 0): a GLOBAL per-CPU
+ *     ring (damon_report_rings_pf).  The page_fault primitive has no damon_ctx
+ *     at report time, so a per-context ring is not expressible; the global ring
+ *     is drained by the single context whose page_fault primitive is enabled
+ *     (damon_report_ring_owner_pf).
+ *   perf-event reports (probe_idx >= 1): a PER-CONTEXT per-CPU ring
+ *     (ctx->perf_rings).  The overflow handler carries the owning ctx, so each
+ *     perf-driven context drains only its own ring -- no global ring and no
+ *     cross-context owner needed.  See struct damon_ctx.
+ *
+ * Each ring (the global pf ring, and every context's perf ring) has its OWN
+ * per-CPU storage, per-CPU busy flag, pending cpumask, and overflow counter;
+ * the producer/consumer barrier sequence in damon_report_access() is shared so
+ * the pairing cannot drift between the two.
+ */
+/*
+ * Report drops are counted per reason.  A ring-full drop means the consumer
+ * did not keep up with the producer; a busy-guard drop means an NMI nested on
+ * top of a same-CPU producer.
+ */
+static DEFINE_PER_CPU(unsigned long, damon_report_ring_full_pf);
+static DEFINE_PER_CPU(unsigned long, damon_report_ring_full_perf);
+static DEFINE_PER_CPU(unsigned long, damon_report_busy_drop_pf);
+static DEFINE_PER_CPU(unsigned long, damon_report_busy_drop_perf);
+static DEFINE_PER_CPU(unsigned long, damon_samples_drained);
+static DEFINE_PER_CPU(unsigned long, damon_samples_stale_drained);
+static DEFINE_PER_CPU(unsigned long, damon_samples_no_region);
+
+static DEFINE_PER_CPU(struct damon_report_ring, damon_report_rings_pf);
+static DEFINE_PER_CPU(int, damon_report_ring_busy_pf);
+/*
+ * Producer (NMI) sets after publishing a report; consumer (kdamond) clears
+ * before draining the corresponding ring.  Hot-write under sampling load -
+ * do NOT mark __read_mostly.  One pending mask per ring.
+ */
+static cpumask_t damon_rings_pending_pf;
+
+unsigned long damon_get_report_ring_full(void)
+{
+	unsigned long sum = 0;
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		sum += per_cpu(damon_report_ring_full_pf, cpu);
+		sum += per_cpu(damon_report_ring_full_perf, cpu);
+	}
+	return sum;
+}
+EXPORT_SYMBOL_GPL(damon_get_report_ring_full);
+
+unsigned long damon_get_report_busy_drop(void)
+{
+	unsigned long sum = 0;
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		sum += per_cpu(damon_report_busy_drop_pf, cpu);
+		sum += per_cpu(damon_report_busy_drop_perf, cpu);
+	}
+	return sum;
+}
+EXPORT_SYMBOL_GPL(damon_get_report_busy_drop);
+
+/* Reports dropped for either reason.  Kept so existing users need no change. */
+unsigned long damon_get_report_overflow(void)
+{
+	return damon_get_report_ring_full() + damon_get_report_busy_drop();
+}
+EXPORT_SYMBOL_GPL(damon_get_report_overflow);
+
+unsigned long damon_get_samples_drained(void)
+{
+	unsigned long sum = 0;
+	int cpu;
+
+	for_each_possible_cpu(cpu)
+		sum += per_cpu(damon_samples_drained, cpu);
+	return sum;
+}
+EXPORT_SYMBOL_GPL(damon_get_samples_drained);
+
+unsigned long damon_get_samples_stale_drained(void)
+{
+	unsigned long sum = 0;
+	int cpu;
+
+	for_each_possible_cpu(cpu)
+		sum += per_cpu(damon_samples_stale_drained, cpu);
+	return sum;
+}
+EXPORT_SYMBOL_GPL(damon_get_samples_stale_drained);
+
+unsigned long damon_get_samples_no_region(void)
+{
+	unsigned long sum = 0;
+	int cpu;
 
+	for_each_possible_cpu(cpu)
+		sum += per_cpu(damon_samples_no_region, cpu);
+	return sum;
+}
+EXPORT_SYMBOL_GPL(damon_get_samples_no_region);
 static DEFINE_MUTEX(damon_lock);
 static int nr_running_ctxs;
 static bool running_exclusive_ctxs;
 
+/*
+ * Single-consumer owner of each global report ring.  A ring is a destructive
+ * SPSC channel that must be drained by exactly one kdamond.  The pf ring is
+ * claimed by the (single) ctx whose page_fault primitive is enabled; the perf
+ * ring by the (single) ctx that has event-driven probes.  Because the two
+ * rings are independent, they have independent owners: distinct ctxs may
+ * concurrently own the pf ring and the perf ring, but no ring may be shared
+ * by two draining ctxs.  Accessed only under damon_lock.
+ *
+ * Only the pf ring has a global owner: it is a global ring with no ctx at
+ * report time.  The perf ring is per-ctx (ctx->perf_rings), so it needs no
+ * cross-ctx owner -- each ctx drains exclusively its own perf ring.
+ */
+static struct damon_ctx *damon_report_ring_owner_pf;
+
 static DEFINE_MUTEX(damon_ops_lock);
 static struct damon_operations damon_registered_ops[NR_DAMON_OPS];
 
 static struct kmem_cache *damon_region_cache __ro_after_init;
 
-static DEFINE_MUTEX(damon_access_reports_lock);
-static struct damon_access_report damon_access_reports[
-	DAMON_ACCESS_REPORTS_CAP];
-static int damon_access_reports_len;
-
 /* Should be called under damon_ops_lock with id smaller than NR_DAMON_OPS */
 static bool __damon_is_registered_ops(enum damon_ops_id id)
 {
@@ -288,6 +402,38 @@ static bool damon_has_probe_weights(struct damon_ctx *c)
 	return false;
 }
 
+/**
+ * damon_has_event_driven_probes() - return true if @ctx has any event-driven
+ * probes registered.
+ *
+ * Event-driven probes (e.g. perf-event IBS/PEBS) populate probe_hits[] via
+ * the SPSC ring drain rather than the apply_probes vtable.  Callers use this
+ * to decide whether to arm hardware sampling.
+ */
+bool damon_has_event_driven_probes(struct damon_ctx *ctx)
+{
+	struct damon_probe *p;
+
+	damon_for_each_probe(p, ctx) {
+		if (p->event_driven)
+			return true;
+	}
+	return false;
+}
+EXPORT_SYMBOL_GPL(damon_has_event_driven_probes);
+
+/* Does @ctx drive (and thus need exclusive drain of) the pf report ring? */
+static bool damon_drains_ring_pf(struct damon_ctx *ctx)
+{
+	return ctx->sample_control.primitives_enabled.page_fault;
+}
+
+/* Does @ctx drive (and thus need exclusive drain of) the perf report ring? */
+static bool damon_drains_ring_perf(struct damon_ctx *ctx)
+{
+	return damon_has_event_driven_probes(ctx);
+}
+
 /*
  * damon_mvsum() - Returns pseudo moving sum value for a time window.
  * @current_nr:		The value of the current aggregation window.
@@ -973,13 +1119,6 @@ static struct damon_sample_filter *damon_nth_sample_filter(int n,
 	return NULL;
 }
 
-static struct damon_sample_filter *damon_last_sample_filter_or_null(
-		struct damon_sample_control *ctrl)
-{
-	return list_last_entry_or_null(&ctrl->sample_filters,
-			struct damon_sample_filter, list);
-}
-
 struct damon_ctx *damon_new_ctx(void)
 {
 	struct damon_ctx *ctx;
@@ -1024,6 +1163,40 @@ struct damon_ctx *damon_new_ctx(void)
 	return ctx;
 }
 
+/*
+ * Lazily allocate the per-ctx perf report ring.  Called from the perf probe
+ * setup path BEFORE any perf event is armed, so an overflow can never observe
+ * a half-built ring.  Idempotent: a ctx with several perf probes allocates
+ * once.  The ring is freed in damon_destroy_ctx() after all perf events are
+ * released (damon_perf_probe_teardown), so no in-flight NMI can reach it.
+ */
+int damon_ctx_alloc_perf_ring(struct damon_ctx *ctx)
+{
+	if (ctx->perf_rings)
+		return 0;	/* already allocated for an earlier probe */
+	ctx->perf_rings = alloc_percpu(struct damon_report_ring);
+	if (!ctx->perf_rings)
+		return -ENOMEM;
+	ctx->perf_ring_busy = alloc_percpu(int);
+	if (!ctx->perf_ring_busy) {
+		free_percpu(ctx->perf_rings);
+		ctx->perf_rings = NULL;
+		return -ENOMEM;
+	}
+	cpumask_clear(&ctx->perf_pending);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(damon_ctx_alloc_perf_ring);
+
+/* Free the per-ctx perf ring.  Caller must ensure no perf event is armed. */
+static void damon_ctx_free_perf_ring(struct damon_ctx *ctx)
+{
+	free_percpu(ctx->perf_rings);
+	ctx->perf_rings = NULL;
+	free_percpu(ctx->perf_ring_busy);
+	ctx->perf_ring_busy = NULL;
+}
+
 static void damon_destroy_targets(struct damon_ctx *ctx)
 {
 	struct damon_target *t, *next_t;
@@ -1049,6 +1222,16 @@ void damon_destroy_ctx(struct damon_ctx *ctx)
 	damon_for_each_sample_filter_safe(f, next_f, &ctx->sample_control)
 		damon_destroy_sample_filter(f, &ctx->sample_control);
 
+	/*
+	 * All perf events were released by damon_perf_probe_teardown() in the
+	 * probe loop above, so no overflow handler can still reach the ring.
+	 * Safe to free now, before kfree(ctx).  No-op if never allocated.
+	 */
+	damon_ctx_free_perf_ring(ctx);
+
+	/* Free the reusable ring-drain region snapshot buffers. */
+	kfree(ctx->drain_snapshot.lookups);
+	kfree(ctx->drain_snapshot.region_buf);
 	kfree(ctx);
 }
 
@@ -2061,7 +2244,8 @@ static int damon_commit_sample_control(
 	return damon_commit_sample_filters(dst, src);
 }
 
-static int __damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src)
+static int __damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src,
+		bool commit_live)
 {
 	int err;
 	struct damos *scheme;
@@ -2116,6 +2300,37 @@ static int __damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src)
 			&src->sample_control);
 	if (err)
 		return err;
+
+	/*
+	 * A running ctx that (still) drives a global report ring must hold sole
+	 * ownership of it; enforce it here since damon_start()'s claim only
+	 * covers the not-running -> running transition.  This runs only for the
+	 * live commit (commit_live) into the running dst; dst's probes and
+	 * sample_control were already committed above, so damon_drains_ring_*()
+	 * reflect the post-commit config.  A not-running dst claims ownership
+	 * later, in damon_start().  Each ring is claimed/released independently.
+	 */
+	if (commit_live && damon_is_running(dst)) {
+		mutex_lock(&damon_lock);
+		if (damon_drains_ring_pf(dst)) {
+			if (damon_report_ring_owner_pf &&
+					damon_report_ring_owner_pf != dst) {
+				mutex_unlock(&damon_lock);
+				return -EBUSY;
+			}
+			damon_report_ring_owner_pf = dst;
+		} else if (damon_report_ring_owner_pf == dst) {
+			damon_report_ring_owner_pf = NULL;
+		}
+		/*
+		 * No perf ring owner check: the perf ring is per-ctx, so a live
+		 * commit that (re)configures perf probes never contends a shared
+		 * ring.  This is what lets a running perf-driven ctx accept a
+		 * commit without the cross-ctx -EBUSY the global ring imposed.
+		 */
+		mutex_unlock(&damon_lock);
+	}
+
 	dst->addr_unit = src->addr_unit;
 	dst->min_region_sz = src->min_region_sz;
 
@@ -2131,7 +2346,7 @@ static struct damon_ctx *damon_new_test_ctx(struct damon_ctx *dst)
 	test_ctx = damon_new_ctx();
 	if (!test_ctx)
 		return NULL;
-	err = __damon_commit_ctx(test_ctx, dst);
+	err = __damon_commit_ctx(test_ctx, dst, false);
 	if (err) {
 		damon_destroy_ctx(test_ctx);
 		return NULL;
@@ -2160,10 +2375,10 @@ int damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src)
 	test_ctx = damon_new_test_ctx(dst);
 	if (!test_ctx)
 		return -ENOMEM;
-	err = __damon_commit_ctx(test_ctx, src);
+	err = __damon_commit_ctx(test_ctx, src, false);
 	if (err)
 		goto out;
-	err = __damon_commit_ctx(dst, src);
+	err = __damon_commit_ctx(dst, src, true);
 out:
 	damon_destroy_ctx(test_ctx);
 	return err;
@@ -2257,6 +2472,37 @@ static int __damon_start(struct damon_ctx *ctx)
 	return err;
 }
 
+/*
+ * Claim the owner of ONE global report ring for a damon_start() batch.
+ * @drains:	per-ring predicate (damon_drains_ring_pf / _perf).
+ * @owner:	per-ring owner slot.
+ *
+ * A ring is a destructive drain owned by exactly one kdamond.  Reject the
+ * start (-EBUSY) if another already-running ctx owns this ring, or if more
+ * than one ctx in this batch drains it.  On success @owner points at the sole
+ * draining ctx (or is left NULL if no batch ctx drains this ring).
+ * Must be called under damon_lock.  Returns 0 or -EBUSY.
+ */
+static int damon_claim_ring_owner_start(struct damon_ctx **ctxs, int nr_ctxs,
+		bool (*drains)(struct damon_ctx *), struct damon_ctx **owner)
+{
+	int i, j;
+
+	for (i = 0; i < nr_ctxs; i++) {
+		if (!drains(ctxs[i]))
+			continue;
+		if (*owner)
+			return -EBUSY;
+		for (j = i + 1; j < nr_ctxs; j++) {
+			if (drains(ctxs[j]))
+				return -EBUSY;
+		}
+		*owner = ctxs[i];
+		break;
+	}
+	return 0;
+}
+
 /**
  * damon_start() - Starts the monitorings for a given group of contexts.
  * @ctxs:	an array of the pointers for contexts to start monitoring
@@ -2284,7 +2530,7 @@ int damon_start(struct damon_ctx **ctxs, int nr_ctxs, bool exclusive)
 		if (!test_ctx)
 			return -ENOMEM;
 
-		err = __damon_commit_ctx(test_ctx, ctxs[i]);
+		err = __damon_commit_ctx(test_ctx, ctxs[i], false);
 		damon_destroy_ctx(test_ctx);
 		if (err)
 			return err;
@@ -2297,11 +2543,43 @@ int damon_start(struct damon_ctx **ctxs, int nr_ctxs, bool exclusive)
 		return -EBUSY;
 	}
 
-	for (i = 0; i < nr_ctxs; i++) {
-		err = __damon_start(ctxs[i]);
-		if (err)
-			break;
-		nr_running_ctxs++;
+	/*
+	 * Each global report ring is drained by exactly one kdamond.  Claim the
+	 * pf and perf ring owners independently; distinct ctxs may own the two
+	 * rings, but neither ring may be shared by two draining ctxs.  Remember
+	 * whether this batch newly set each owner so the failure paths release
+	 * only those, never another batch's still-running owner.
+	 */
+	{
+		struct damon_ctx *prev_owner_pf = damon_report_ring_owner_pf;
+
+		err = damon_claim_ring_owner_start(ctxs, nr_ctxs,
+				damon_drains_ring_pf,
+				&damon_report_ring_owner_pf);
+		if (err) {
+			/* Release only owners this batch just claimed. */
+			if (damon_report_ring_owner_pf != prev_owner_pf)
+				damon_report_ring_owner_pf = prev_owner_pf;
+			mutex_unlock(&damon_lock);
+			return err;
+		}
+
+		for (i = 0; i < nr_ctxs; i++) {
+			err = __damon_start(ctxs[i]);
+			if (err)
+				break;
+			nr_running_ctxs++;
+		}
+		/*
+		 * A ctx that failed to start has no running kdamond, so its
+		 * exit path will not release the ring owner assigned above.
+		 * Release each owner set above whose kdamond is not running.
+		 */
+		if (err) {
+			if (damon_report_ring_owner_pf != prev_owner_pf &&
+					!damon_report_ring_owner_pf->kdamond)
+				damon_report_ring_owner_pf = prev_owner_pf;
+		}
 	}
 	if (exclusive && nr_running_ctxs)
 		running_exclusive_ctxs = true;
@@ -2483,30 +2761,121 @@ int damos_walk(struct damon_ctx *ctx, struct damos_walk_control *control)
  * damon_report_access() - Report identified access events to DAMON.
  * @report:	The reporting access information.
  *
- * Report access events to DAMON.
+ * Report access events to DAMON via a per-CPU SPSC lockless ring.  Producer
+ * is the local CPU (typically NMI from a hardware-sampling backend);
+ * consumer is the kdamond drain in kdamond_check_reported_accesses().
+ *
+ * The destination ring is selected by this_cpu_ptr(), i.e. by the CPU calling
+ * this function, not by @report->cpu, which is sample metadata used by the
+ * drain-side filter.  The two coincide for a sample delivered by an interrupt
+ * on the CPU that produced it.
  *
- * Context: May sleep.
+ * A backend whose PMU writes a record stream into a memory buffer instead of
+ * raising a per-sample interrupt, or one reading a device counter table, must
+ * therefore decode CPU N's buffer on CPU N -- for example by queueing per-CPU
+ * work with queue_work_on() -- rather than calling this function in a loop
+ * from one thread.  A single-thread loop puts every report in that thread's
+ * ring, which caps machine-wide capacity at DAMON_REPORT_RING_SIZE - 1
+ * reports per drain regardless of the number of producing CPUs, and does not
+ * satisfy the single-producer invariant if the thread can migrate.
  *
- * NOTE: we may be able to implement this as a lockless queue, and allow any
- * context.  As the overhead is unknown, and region-based DAMON logics would
- * guarantee the reports would be not made that frequently, let's start with
- * this simple implementation.
+ * Context: any (NMI-safe).  An NMI nesting on top of a process-context
+ * producer on the same CPU would otherwise stomp the same entries[head]
+ * slot; the busy guard detects and drops in that case.
+ *
+ * If the ring is full, the sample is dropped and the per-CPU ring-full
+ * counter incremented; a busy-guard drop increments the busy-drop counter.
+ *
+ * Return: true if the report was queued, false if it was dropped.  A producer
+ * holding a single report may ignore this.  A producer decoding a batch out
+ * of a hardware buffer should stop on false and leave the remainder in that
+ * buffer for the next round, since a report released from the buffer but not
+ * queued here is not delivered.
  */
-void damon_report_access(struct damon_access_report *report)
+bool damon_report_access(struct damon_access_report *report)
 {
-	struct damon_access_report *dst;
+	/*
+	 * Route by the globally-meaningful probe_idx boundary:
+	 *   probe_idx == DAMON_PROBE_IDX_NONE (0) -> pf ring   (page_fault)
+	 *   probe_idx >= 1                        -> perf ring (event probes)
+	 * The two rings are fully independent (own storage, busy flag, pending
+	 * mask, overflow counter); only the selected per-CPU symbols differ.
+	 * The NMI ordering sequence below is a single copy shared by both rings
+	 * so the subtle producer/consumer barrier pairing cannot drift.
+	 */
+	bool is_perf = report->probe_idx != DAMON_PROBE_IDX_NONE;
+	struct damon_report_ring *ring;
+	cpumask_t *pending;
+	int __percpu *busy_pcpu;
+	unsigned int head, next;
+	int busy;
+	bool queued = false;
+	struct damon_ctx *pctx = is_perf ? report->ctx : NULL;
 
-	/* silently fail for races */
-	if (!mutex_trylock(&damon_access_reports_lock))
-		return;
-	dst = &damon_access_reports[damon_access_reports_len++];
-	/* just drop all existing reports in favor of simplicity. */
-	if (damon_access_reports_len == DAMON_ACCESS_REPORTS_CAP)
-		damon_access_reports_len = 0;
-	*dst = *report;
-	dst->report_jiffies = jiffies;
-	mutex_unlock(&damon_access_reports_lock);
+	/*
+	 * A perf report must carry its owning ctx (set by the overflow handler)
+	 * and that ctx must have an allocated per-ctx perf ring.  If either is
+	 * missing (e.g. an overflow racing teardown after the ring was freed, or
+	 * a report raised before the ring was allocated), drop the sample rather
+	 * than touch NULL/freed storage.
+	 */
+	if (is_perf && (!pctx || !pctx->perf_rings || !pctx->perf_ring_busy))
+		return false;
+
+	/* Pin to a CPU so the SPSC invariant holds for preemptible callers. */
+	preempt_disable();
+	if (is_perf)
+		busy_pcpu = pctx->perf_ring_busy;
+	else
+		busy_pcpu = &damon_report_ring_busy_pf;
+	busy = this_cpu_inc_return(*busy_pcpu);
+	if (busy != 1) {
+		/* NMI nested on a process-context producer; drop. */
+		if (is_perf)
+			this_cpu_inc(damon_report_busy_drop_perf);
+		else
+			this_cpu_inc(damon_report_busy_drop_pf);
+		goto out;
+	}
+
+	if (is_perf) {
+		ring = this_cpu_ptr(pctx->perf_rings);
+		pending = &pctx->perf_pending;
+	} else {
+		ring = this_cpu_ptr(&damon_report_rings_pf);
+		pending = &damon_rings_pending_pf;
+	}
+	head = ring->head;
+	next = (head + 1) & DAMON_REPORT_RING_MASK;
+
+	if (next == READ_ONCE(ring->tail)) {
+		if (is_perf)
+			this_cpu_inc(damon_report_ring_full_perf);
+		else
+			this_cpu_inc(damon_report_ring_full_pf);
+		goto out;
+	}
+
+	ring->entries[head] = *report;
+	ring->entries[head].report_jiffies = jiffies;
+	smp_wmb(); /* publish entry before head advance */
+	WRITE_ONCE(ring->head, next);
+	/*
+	 * Order the head advance before publishing the pending bit so
+	 * that the consumer, on observing the bit, is also guaranteed
+	 * to observe the new head.  cpumask_set_cpu / set_bit are
+	 * documented as unordered RMW (atomic_bitops.txt), hence the
+	 * explicit barrier.
+	 */
+	smp_mb__before_atomic();
+	cpumask_set_cpu(smp_processor_id(), pending);
+	queued = true;
+out:
+	this_cpu_dec(*busy_pcpu);
+	preempt_enable();
+	return queued;
 }
+EXPORT_SYMBOL_GPL(damon_report_access);
 
 #ifdef CONFIG_MMU
 void damon_report_page_fault(struct vm_fault *vmf, bool huge_pmd)
@@ -2515,7 +2884,9 @@ void damon_report_page_fault(struct vm_fault *vmf, bool huge_pmd)
 		.vaddr = vmf->address,
 		.size = 1,	/* todo: set appripriately */
 		.tid = task_pid_vnr(current),
+		.tgid = task_tgid_vnr(current),
 		.is_write = vmf->flags & FAULT_FLAG_WRITE,
+		/* probe_idx intentionally zero (DAMON_PROBE_IDX_NONE): no probe */
 	};
 
 	if (huge_pmd)
@@ -4187,6 +4558,24 @@ static void kdamond_init_ctx(struct damon_ctx *ctx)
 	}
 }
 
+static unsigned int kdamond_apply_zero_access_report(struct damon_ctx *ctx)
+{
+	struct damon_target *t;
+	struct damon_region *r;
+	unsigned int max_nr_accesses = 0;
+
+	damon_for_each_target(t, ctx) {
+		damon_for_each_region(r, t) {
+			if (r->access_reported)
+				r->access_reported = false;
+			else
+				damon_update_region_access_rate(r, false);
+			max_nr_accesses = max(max_nr_accesses, r->nr_accesses);
+		}
+	}
+	return max_nr_accesses;
+}
+
 static bool damon_sample_filter_matching(struct damon_access_report *report,
 		struct damon_sample_filter *filter)
 {
@@ -4214,89 +4603,301 @@ static bool damon_sample_filter_matching(struct damon_access_report *report,
 	return matched == filter->matching;
 }
 
+/*
+ * Decide whether a drained report should be dropped per the ctx sample
+ * filters.  A matching "!allow" (filter-out) filter drops the report; if no
+ * filter matched, the last filter's @allow acts as the default policy.
+ */
 static bool damon_sample_filter_out(struct damon_access_report *report,
 		struct damon_sample_control *ctrl)
 {
-	struct damon_sample_filter *filter;
+	struct damon_sample_filter *filter, *last = NULL;
 
 	damon_for_each_sample_filter(filter, ctrl) {
+		last = filter;
 		if (damon_sample_filter_matching(report, filter) &&
 				!filter->allow)
 			return true;
 	}
-	filter = damon_last_sample_filter_or_null(ctrl);
-	if (!filter)
+	if (!last)
 		return false;
-	return !filter->allow;
+	return !last->allow;
 }
 
-static void kdamond_apply_access_report(struct damon_access_report *report,
-		struct damon_target *t, struct damon_ctx *ctx)
+/*
+ * Build a snapshot of the ctx's targets and their region arrays for use by
+ * the ring drain loop.  The snapshot buffer is reused across ticks, grown via
+ * krealloc only when a new high water mark is reached.
+ *
+ * The two-pass walk over adaptive_targets is safe even though krealloc_array()
+ * may sleep: target list mutation is funneled through damon_call onto the
+ * kdamond itself, so no other thread can mutate the list while kdamond runs
+ * this function.  Regions within a target are kept address-sorted by DAMON, so
+ * the snapshot arrays are directly binary-searchable.
+ */
+static struct damon_target_lookup *damon_build_target_lookup(
+		struct damon_ctx *ctx, unsigned int *nr_targets_out)
 {
-	struct damon_region *r;
-	unsigned long addr;
+	struct damon_target *t;
+	struct damon_target_lookup *tbl;
+	unsigned int nr_targets = 0, total_regions = 0, ti = 0, ri = 0;
 
-	if (damon_sample_filter_out(report, &ctx->sample_control))
-		return;
-	if (damon_target_has_pid(ctx))
-		addr = report->vaddr;
-	else
-		addr = report->paddr;
+	damon_for_each_target(t, ctx) {
+		nr_targets++;
+		total_regions += damon_nr_regions(t);
+	}
 
-	/* todo: make search faster, e.g., binary search? */
-	damon_for_each_region(r, t) {
-		if (addr < r->ar.start)
-			continue;
-		if (r->ar.end < addr + report->size)
-			continue;
-		if (!r->access_reported)
-			damon_update_region_access_rate(r, true);
-		r->access_reported = true;
+	if (nr_targets > ctx->drain_snapshot.nr_lookups) {
+		tbl = krealloc_array(ctx->drain_snapshot.lookups,
+				nr_targets, sizeof(*tbl), GFP_KERNEL);
+		if (!tbl)
+			return NULL;
+		ctx->drain_snapshot.lookups = tbl;
+		ctx->drain_snapshot.nr_lookups = nr_targets;
+	}
+	tbl = ctx->drain_snapshot.lookups;
+
+	if (total_regions > ctx->drain_snapshot.region_buf_cap) {
+		struct damon_region **buf;
+
+		buf = krealloc_array(ctx->drain_snapshot.region_buf,
+				total_regions, sizeof(*buf), GFP_KERNEL);
+		if (!buf)
+			return NULL;
+		ctx->drain_snapshot.region_buf = buf;
+		ctx->drain_snapshot.region_buf_cap = total_regions;
+	}
+
+	damon_for_each_target(t, ctx) {
+		struct damon_region *r;
+
+		tbl[ti].regions = &ctx->drain_snapshot.region_buf[ri];
+		tbl[ti].nr_regions = damon_nr_regions(t);
+		damon_for_each_region(r, t)
+			ctx->drain_snapshot.region_buf[ri++] = r;
+		ti++;
 	}
+
+	*nr_targets_out = nr_targets;
+	return tbl;
 }
 
-static unsigned int kdamond_apply_zero_access_report(struct damon_ctx *ctx)
-{
+/*
+ * Binary-search a sorted region snapshot for the region containing @addr and,
+ * on a hit, credit the report to @pidx.  Returns true if a region was credited
+ * (straddling reports that spill past the region end are rejected).
+ */
+static bool damon_credit_report_bsearch(struct damon_region **regions,
+		unsigned int nr_regions, unsigned long addr,
+		unsigned long size, int pidx)
+{
+	struct damon_region *r = NULL;
+	int left = 0, right = (int)nr_regions - 1, mid;
+
+	while (left <= right) {
+		/* Avoid (left + right) overflow at large nr_regions. */
+		mid = left + (right - left) / 2;
+		if (addr < regions[mid]->ar.start)
+			right = mid - 1;
+		else if (addr >= regions[mid]->ar.end)
+			left = mid + 1;
+		else {
+			r = regions[mid];
+			break;
+		}
+	}
+	if (!r)
+		return false;
+	/* Reject reports straddling a region boundary. */
+	if (addr + size > r->ar.end)
+		return false;
+
+	/*
+	 * pidx == 0 (page_fault / non-probe): credit access rate only.
+	 * Ring probe_idx is 1-based (0 == DAMON_PROBE_IDX_NONE sentinel), but
+	 * probe_hits[] storage is 0-based to match all readers (wsum, mvsum,
+	 * update, aggregate reset, merge). Convert here: probe_hits[pidx - 1].
+	 */
+	if (pidx > 0)
+		r->probe_hits[pidx - 1]++;
+	damon_update_region_access_rate(r, true);
+	r->access_reported = true;
+	return true;
+}
+
+/*
+ * __kdamond_drain_ring - drain ONE global per-CPU SPSC ring into region probe_hits.
+ * @ctx:		draining context (owns @ring for this run).
+ * @tbl:		pre-built sorted per-target region snapshot (shared).
+ * @ring_pcpu:		the per-CPU ring base (pf or perf ring).
+ * @pending:		the matching per-ring pending cpumask.
+ *
+ * The global page-fault ring and each context's per-CPU perf ring
+ * (ctx->perf_rings) are partitioned by probe_idx but drained by
+ * an identical loop; this helper is that loop, parameterised only by which
+ * ring + pending mask to consume.  The bsearch / straddle-reject / tid-filter /
+ * stale-window / sample-filter / probe_hits-crediting logic is unchanged from
+ * the prior single-ring drain.
+ *
+ * Each ring entry carries its own probe_idx (set by the overflow handler), so
+ * no list walk is needed to resolve the probe_hits[] slot.
+ *
+ * A per-target sorted region snapshot is built once per drain (by the caller)
+ * so each entry is matched to its region via O(log R) binary search rather
+ * than a linear damon_for_each_region() walk.  Iterates the ring's pending
+ * cpumask to drain only CPUs with published reports.
+ */
+static void __kdamond_drain_ring(struct damon_ctx *ctx,
+		struct damon_target_lookup *tbl,
+		struct damon_report_ring __percpu *ring_pcpu,
+		cpumask_t *pending)
+{
+	int cpu;
+	struct damon_report_ring *ring;
+	unsigned int tail, head;
+	struct damon_access_report *entry;
 	struct damon_target *t;
-	struct damon_region *r;
-	unsigned int max_nr_accesses = 0;
+	unsigned long match_addr;
+	bool found;
+	unsigned int ti;
 
-	damon_for_each_target(t, ctx) {
-		damon_for_each_region(r, t) {
-			if (r->access_reported)
-				r->access_reported = false;
+	/*
+	 * Unified paddr/vaddr drain.  The address space of the monitoring
+	 * target selects which address of the report is matched: contexts
+	 * whose targets carry a pid are monitoring a virtual address space and
+	 * match report->vaddr, the others match report->paddr.
+	 *
+	 * For pid-target contexts, filter by thread group id so entries from
+	 * unrelated processes are not credited to the wrong target.
+	 * damon_target_has_pid(ctx) gates this filter: it is false for paddr
+	 * ops, whose targets have no pid, so paddr crediting is unfiltered.
+	 */
+	for_each_cpu(cpu, pending) {
+		ring = per_cpu_ptr(ring_pcpu, cpu);
+		cpumask_clear_cpu(cpu, pending);
+		/*
+		 * Pair with the producer's smp_mb__before_atomic() between
+		 * the head publish and cpumask_set_cpu(): order the bit clear
+		 * before the head read so a producer publishing between the
+		 * clear and the READ_ONCE(head) is observed via the bit it
+		 * re-sets, not lost as a stale-head drain.
+		 */
+		smp_mb__after_atomic();
+		head = READ_ONCE(ring->head);
+		smp_rmb(); /* pair with smp_wmb in producer */
+		tail = ring->tail;
+
+		while (tail != head) {
+			unsigned long stale_before;
+			int pidx;
+
+			entry = &ring->entries[tail];
+			/*
+			 * Use sample_interval (not aggr_interval) as the
+			 * staleness window: entries older than one sample
+			 * interval are from a previous monitoring tick and
+			 * should not inflate the current aggregation window.
+			 */
+			stale_before = jiffies -
+				usecs_to_jiffies(ctx->attrs.sample_interval);
+			if (time_before(entry->report_jiffies, stale_before)) {
+				this_cpu_inc(damon_samples_stale_drained);
+				goto next;
+			}
+			pidx = entry->probe_idx;
+			/*
+			 * probe_idx == 0 (DAMON_PROBE_IDX_NONE) is the
+			 * page_fault / non-probe credit path: no probe_hits[]
+			 * slot, but it still credits the region access rate.
+			 * Reject only out-of-range indices (>= DAMON_MAX_PROBES)
+			 * and, defensively, any negative value.
+			 */
+			if (pidx < 0 || pidx >= DAMON_MAX_PROBES)
+				goto next;
+
+			/* Drop reports rejected by the ctx sample filters. */
+			if (damon_sample_filter_out(entry, &ctx->sample_control))
+				goto next;
+
+			/*
+			 * Select the address that matches the address space
+			 * the targets of this context are monitoring.  A
+			 * report that carries no address for that space
+			 * cannot be credited.
+			 */
+			if (damon_target_has_pid(ctx))
+				match_addr = entry->vaddr;
 			else
-				damon_update_region_access_rate(r, false);
-			max_nr_accesses = max(max_nr_accesses, r->nr_accesses);
+				match_addr = entry->paddr;
+			if (!match_addr)
+				goto next;
+
+			found = false;
+			ti = 0;
+			damon_for_each_target(t, ctx) {
+				/* pid targets: match the reporting process */
+				if (damon_target_has_pid(ctx) &&
+				    pid_vnr(t->pid) != entry->tgid) {
+					ti++;
+					continue;
+				}
+				if (damon_credit_report_bsearch(tbl[ti].regions,
+						tbl[ti].nr_regions, match_addr,
+						entry->size, pidx)) {
+					this_cpu_inc(damon_samples_drained);
+					found = true;
+					break;
+				}
+				ti++;
+			}
+			if (!found)
+				this_cpu_inc(damon_samples_no_region);
+next:
+			tail = (tail + 1) & DAMON_REPORT_RING_MASK;
 		}
+		WRITE_ONCE(ring->tail, tail);
 	}
-	return max_nr_accesses;
 }
 
-static unsigned int kdamond_check_reported_accesses(struct damon_ctx *ctx)
+/*
+ * kdamond_check_reported_accesses - drain the global report ring(s) this ctx feeds.
+ * Called from kdamond main loop after each sampling interval.
+ *
+ * The global page-fault ring and each context's per-CPU perf ring
+ * (ctx->perf_rings) are partitioned by probe_idx: the pf ring holds
+ * page_fault (probe_idx == DAMON_PROBE_IDX_NONE) reports, the perf ring holds
+ * event-driven probe (probe_idx >= 1) reports.  A ctx drains the ring(s) its
+ * enabled primitives feed:
+ *   - page_fault primitive enabled       -> drain pf ring.
+ *   - event-driven probes registered     -> drain perf ring.
+ *   - both enabled                        -> drain both.
+ *
+ * The per-target sorted region snapshot is built once and shared across both
+ * ring drains (it is ring-agnostic).
+ */
+static void kdamond_check_reported_accesses(struct damon_ctx *ctx)
 {
-	int i;
-	struct damon_access_report *report;
-	struct damon_target *t;
+	struct damon_target_lookup *tbl;
+	unsigned int nr_targets = 0;
 
-	/* currently damon_access_report supports only physical address */
-	if (damon_target_has_pid(ctx))
-		return 0;
-
-	mutex_lock(&damon_access_reports_lock);
-	for (i = 0; i < damon_access_reports_len; i++) {
-		report = &damon_access_reports[i];
-		if (time_before(report->report_jiffies,
-					jiffies -
-					usecs_to_jiffies(
-						ctx->attrs.sample_interval)))
-			continue;
-		damon_for_each_target(t, ctx)
-			kdamond_apply_access_report(report, t, ctx);
+	/*
+	 * Build the sorted region snapshot once for this drain.  If the alloc
+	 * fails, skip the drain this tick rather than falling back to a linear
+	 * scan (a missed tick self-heals; a linear scan does not).
+	 */
+	tbl = damon_build_target_lookup(ctx, &nr_targets);
+	if (!tbl) {
+		pr_warn_ratelimited(
+			"damon: target-lookup alloc failed; ring drain skipped this tick\n");
+		return;
 	}
-	mutex_unlock(&damon_access_reports_lock);
-	/* For nr_accesses_bp, absence of access should also be reported. */
-	return kdamond_apply_zero_access_report(ctx);
+
+	if (damon_drains_ring_pf(ctx))
+		__kdamond_drain_ring(ctx, tbl, &damon_report_rings_pf,
+				&damon_rings_pending_pf);
+	if (damon_drains_ring_perf(ctx))
+		__kdamond_drain_ring(ctx, tbl, ctx->perf_rings,
+				&ctx->perf_pending);
 }
 
 /*
@@ -4345,7 +4946,9 @@ static int kdamond_fn(void *data)
 
 		do_prep = ctx->ops.prep_probes && damon_has_prep(ctx);
 
-		if (!access_check_disabled && ctx->ops.prepare_access_checks)
+		/* Page-fault sampling installs its markers from this callback. */
+		if ((!access_check_disabled || damon_drains_ring_pf(ctx)) &&
+				ctx->ops.prepare_access_checks)
 			ctx->ops.prepare_access_checks(ctx);
 		if (do_prep)
 			ctx->ops.prep_probes(ctx, access_check_disabled);
@@ -4353,14 +4956,18 @@ static int kdamond_fn(void *data)
 		kdamond_usleep(sample_interval);
 		ctx->passed_sample_intervals++;
 
-		if (!access_check_disabled) {
-			/* todo: make these non-exclusive */
-			if (ctx->sample_control.primitives_enabled.page_fault)
-				max_merge_score =
-					kdamond_check_reported_accesses(ctx);
-			else if (ctx->ops.check_accesses)
-				max_merge_score = ctx->ops.check_accesses(ctx);
-		}
+		/*
+		 * Both perf-event and page-fault primitives feed damon_report_access()
+		 * into the global per-CPU ring; the same drain consumes both.
+		 */
+		if (damon_drains_ring_perf(ctx) || damon_drains_ring_pf(ctx))
+			kdamond_check_reported_accesses(ctx);
+
+		/* Page-fault sampling reports only the accessed regions. */
+		if (damon_drains_ring_pf(ctx))
+			max_merge_score = kdamond_apply_zero_access_report(ctx);
+		else if (!access_check_disabled && ctx->ops.check_accesses)
+			max_merge_score = ctx->ops.check_accesses(ctx);
 
 		if (ctx->ops.apply_probes) {
 			if (time_after_eq(ctx->passed_sample_intervals,
@@ -4475,6 +5082,9 @@ static int kdamond_fn(void *data)
 	nr_running_ctxs--;
 	if (!nr_running_ctxs && running_exclusive_ctxs)
 		running_exclusive_ctxs = false;
+	/* Release the global pf report ring if this ctx owned it. */
+	if (damon_report_ring_owner_pf == ctx)
+		damon_report_ring_owner_pf = NULL;
 	mutex_unlock(&damon_lock);
 
 	return 0;
-- 
2.43.0


