Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47FBACD4F3C
	for <linux-mm@archiver.kernel.org>; Sat, 16 May 2026 22:34:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F8456B0093; Sat, 16 May 2026 18:34:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6090F6B0095; Sat, 16 May 2026 18:34:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45EBB6B0096; Sat, 16 May 2026 18:34:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 287916B0093
	for <linux-mm@kvack.org>; Sat, 16 May 2026 18:34:52 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CBE22160686
	for <linux-mm@kvack.org>; Sat, 16 May 2026 22:34:51 +0000 (UTC)
X-FDA: 84774739182.26.93A6361
Received: from mail-yw1-f195.google.com (mail-yw1-f195.google.com [209.85.128.195])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0098140003
	for <linux-mm@kvack.org>; Sat, 16 May 2026 22:34:49 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PB29FILi;
	spf=pass (imf17.hostedemail.com: domain of ravis.opensrc@gmail.com designates 209.85.128.195 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778970890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wV43Lg6ZeBSxT2gi43CrNOJZdZ5c40FejoI6Xqvs4d0=;
	b=EvcpfsKA/zT4SoOBoNtqTPgKntz+YSNlChRfY2ir9kZxe7R4QxxEI38P29+wUdy9kxrKj1
	nFbSjloKbUPMrEJcRY1tiBUVlAjcj+7FOTgK8mijfTcP9azN21HJFPx23CSREqs/xSNRBr
	acowkKpXBduEYvmnQ8FdkSYxMCCvzyQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PB29FILi;
	spf=pass (imf17.hostedemail.com: domain of ravis.opensrc@gmail.com designates 209.85.128.195 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778970890; a=rsa-sha256;
	cv=none;
	b=QeWp2FbL7u5mxJ6EmKIcpo8apX2hdQedpCsh2p9Ci+331u9gxyoB+nqkKKNAXPjdV+Cirg
	2ZkY4XLzaDG1cTzTH1NRcSLpV26xLJTYLw0baIpYZDhlb7kmHnUhg5iuDhmgKU+rqK5Oe6
	VWMi/wP7fo8AuayySR2KXXxG3zQxRls=
Received: by mail-yw1-f195.google.com with SMTP id 00721157ae682-7bd6f65c781so5177457b3.1
        for <linux-mm@kvack.org>; Sat, 16 May 2026 15:34:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778970889; x=1779575689; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wV43Lg6ZeBSxT2gi43CrNOJZdZ5c40FejoI6Xqvs4d0=;
        b=PB29FILirdMr7SxlNFxpVguzEo3flQh5BAjlvNFF4iYK5N2ALYQjtdhrMTejIflIPZ
         kqPhk0skYnJvqkpGU+6p+tIsLfYS4JZpcwRAup0Eor08AY9qTfldJt3kLFUosiP9U3Ie
         UQaxFcGwfBIqtFi/pWQbvFj/1UhF/TeUJiGrpC0mpaCt+2UOY+tL9t4PuVxpFwhiLkJK
         vAxsluW8OHairZlSjexChrOzcVB2uYWnK7G4/ZfGIM9qjSlYPcQtiR01XMfi2cBm2cpb
         Vk21p/QrqqhfYYOSgKSgfMGke+SeMjEi9uZV51kYaHRIOJNLq5dZWsZdwIIY2onZeK5S
         QU7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778970889; x=1779575689;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wV43Lg6ZeBSxT2gi43CrNOJZdZ5c40FejoI6Xqvs4d0=;
        b=CGuWaAYz6nk5YOEk/v/ID8YKI4+BAav83+wJFEc74y8dIQFPE4HKADw2yA3rkEiIlw
         jQ5BJNxJPSS/TYMCq8R94HUBJ6Q1Um3OWnDCgscPVEFd8qP3WkXoCDrbDhCMBUAXkEVj
         +aq/mQlj+F+X1yBjMA+SNEigT0odSdlp4efbyXrkglZVcufN70cgRrfQ8FRW5VEUG32j
         q8WHETiisWmdUmPd41/4slOvAvGURzL9vm7EF/N6P1UKwWFTJa5k4nbZlCN33K81rdlO
         qh51o6l2aG+Y4DHUPmfSacBmNYkELiRLnVZNetjbzI6u+2QvFV8bZoD9+LD0bCZQ5bQw
         KSAA==
X-Forwarded-Encrypted: i=1; AFNElJ9ljOV5m5/Meks4FUQJIbuDDGHgp2EgDdY5A31uVcpCXfS13IuYdTHg1dYarELHsMhUtIkFe+sYDg==@kvack.org
X-Gm-Message-State: AOJu0YxdXZmxqxlj6a2ourk80/MmkkOQBwRCGTB5aszXaITTwTd4+eBZ
	EK5MOUTe3Df0avci8MjyY2usPqjixoKhixtuDQ9Sf1DdqkDI5BDq80A=
X-Gm-Gg: Acq92OHib4GsMxDZnY3JwxqCSJDwKRzgQCPUp5DJICLTQ7Vkhq7yizfRywH1P+KpJAE
	1fwJJGQw9hlni1Ee96Osg8+IWdkv2W+e74LJnxxJ+CKzLyxCjQn5A5CDnj0WMOQbKGXwEUI5pv3
	WE23Ivf6cag33S9kIVme3UFPUuOuTXfnZTf6SwTiuk0gcKY0HmWBMGbQlfjPJ5kYsviF1Oj6LXj
	J5L0Wk8v+gkGbQHdbfS3PtiL0p9oDMLOVWYYIOKXSSoLaExkcrjF28SH1TBniUTqLz47YpwvRIX
	o3GrqsAO8XnciYx8p7EmEdLzB5hAgrzqQd2HioqLXoSE0LWDkBOvFaCtIhdDyZG8lzQ4pVXFgSS
	XiOJb//6xicbcj3i7tYmV+ziTULjkogBCtzCsP/h3fOd5X4pD8LT/irzvL5aYNylMdz1Kgdw6il
	A6EBIJ8eFTCX+l15mJ6PI69gt5eNygQ7H5gcJ4hQlttfLIHMRLxmTQCPi7VSHqiTpw9LmtEkFJc
	y/ecVnrrRGg
X-Received: by 2002:a05:690c:e04e:b0:7c2:fa53:6d7f with SMTP id 00721157ae682-7c9463a2449mr68267967b3.3.1778970888966;
        Sat, 16 May 2026 15:34:48 -0700 (PDT)
Received: from localhost (23-116-43-216.lightspeed.sntcca.sbcglobal.net. [23.116.43.216])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7cc9c6cd4f5sm666137b3.35.2026.05.16.15.34.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 May 2026 15:34:48 -0700 (PDT)
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
To: sj@kernel.org,
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
	bharata@amd.com
Subject: [RFC PATCH 3/7] mm/damon/core: replace mutex-protected report buffer with per-CPU lockless ring
Date: Sat, 16 May 2026 15:34:28 -0700
Message-ID: <20260516223439.4033-4-ravis.opensrc@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260516223439.4033-1-ravis.opensrc@gmail.com>
References: <20260516223439.4033-1-ravis.opensrc@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0098140003
X-Stat-Signature: et55hpue83o9r38bjkiq8ieskoq6nwoi
X-HE-Tag: 1778970889-19702
X-HE-Meta: U2FsdGVkX18B/hVt0BWMZGkWbvsDV1HIVGMY8NWsqhmP29XX0yEYumvqd+agoacpyT/olPuHucr/lKoKeWE0lXjUHupvc4bfBrKzR5D5PafQVOo/nAKr0D4TZlGqRiXONSgINgWe8noFm5vJtBdWXhzHskUF50MhWuDMNYwrmdXVLyQy9X38vrXt5fBpGrat7ZkupnEVbPqRHacDxP4wpnWigger6QmbKGNTXa6yDu5fgcVuMWwfnATKL66eESaUIDF+HqhtlwtGFd0ZpUuLDKzs/3Mzrxucz5rWCyB2q2484WwdHnoDyPz8azfBBsJcBQsUQgGnDQukVhHXdOLUEDl0Z2hKnvar2Jr32NG/u/+5FylEH8GG7UkNh0Nf2NHomH3Ty90pdI8lLsZMqEXVQrUJs3jyCbWdyOuCfXw9d53vSqBTf3f35XbqnhFkfSUdrksoGebIwrElClsprdH1pBeV/K//ylExQY2yH5QC273lmCfJro9H79rfEzObjb+USUT0p8GvbMapy32PdGz/dMM0j3UlSvRLffuUaB6k+WSWUW/oovlHckszW03UdoA4iKzu+gekL337TzGnFZzZVZok8Rms0ujBd3hUcPceSaAzzqHyi0soEjVwyU4a6e930KXxFDU7tvMsJPtA3SCAoGGbojLjgA4ILn4kKNDxxOJM4XXBY9cYP/YcjObvic1aL8AteYrSKQz1z5cDVtBX37qCzV7QuY7hEmx1iwlSi2/n44zq355waZ/Z2zNP5IBSPC6q0YNPaF+pD+9KZLVaVLygT2UGK1kj7nywxi5Cj5xazAxKbGyOj8w6ewiX/77Y8F/nGRS4IdQTOjSH81Wi/bT2QJAZ0Eqcj2DkeM/2Ixq5X6GRFJLeTPWpqUGeRmcGbKvHvHG+AvJHoEFdPox8FlrWnOsfOk8V/HnYlehLGONJDzxiAVYcL+wuWzINYqRm3ryKYgTD+DcTNHIAV62
 vCwaeqUk
 meXk+zdXF7T6MjErqeycsu6PvQCbQMMHa8kLnhgg+ldeeXSI56SMfOu4q5l/1Dgqmw+n473F9NLpsbg+2ps8eadusgiCwdMjOKb86F/+Tf6ROfI8q/k5+MQ8QQHAP1Fe2mezYC76AVIedGkqmMjQ+OE8xBHj9ErmhAo0y7uv+Fqc264+aF6iJqrGnB5c7h1h5i0QglKIwHMjG8amDkh0zyQwL2T5AG9isaejho66w1M8WKHH9Ugj9LDbh9J6xTdfF2CfsvnVCvRIPtcYvnuvPha3YhklNu5/hwOAvdKAZ9796m8rHNsuopSG8cCvLRGieQnMxosnPuB8zuakV0Ta1gJw27VE/dESqIm7g+OF0ve7UFLru8yLF6VURDHtuM9PUAlqYN5/ktEM0760zDQSv6XzLVwO1tCCEgrAy5BTgazM1cWdKRjB/Ru5uP5VNogaI/v910/TTzPcpdIL5yq2ypF2Hf+uYknuWT5/v1jd7LHs1IqnqHZOSaZSGLt7nYs2Pa0vEBKTavr+485jTAysDaZxqcHqk8Bq/Biuk5h1iSZMf0N1TJpvhy4NCFvxcVliZ1kIXVuuz4Anmka6Xj8CAKw0xnd8LILQEKLD/KG0eWAQ7nT4/KE5Us4UgOmYruKXyrhVbOJ6vAtZiopDdGlpHdc49pg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace the mutex-protected fixed-size array (DAMON_ACCESS_REPORTS_CAP=1000)
with a per-CPU lockless ring buffer.  This enables damon_report_access()
to be called from NMI context.

Ring design:
- Producer is serialized per CPU: only one in-flight producer per CPU
  is allowed.  A per-CPU damon_report_ring_busy counter detects
  NMI-on-process nesting and drops the nested attempt, preserving the
  single-writer invariant on the slot.
- head is advanced by the producer with smp_wmb() before publish.
- tail is advanced by the consumer (kdamond) after the entries[] reads.
- Overflow: sample silently dropped.  NMI context is allocation-free
  and access reports are best-effort.

To keep the producer/consumer pattern scalable on systems with many
CPUs and a high NMI rate, the ring layout follows three rules:

- head, tail and entries[] live on separate cache lines via
  ____cacheline_aligned_in_smp, so producer and consumer do not
  invalidate each other's working set on every advance.
- DAMON_REPORT_RING_SIZE is bounded so the per-CPU footprint stays
  small (256 entries x sizeof(struct damon_access_report) plus head
  and tail cache lines), keeping draining all rings during one
  kdamond tick from evicting unrelated data on contemporary server
  parts.
- A cpumask, damon_rings_pending, is set by the producer after
  publishing and cleared by the consumer per ring drained, so the
  consumer iterates only CPUs with pending entries instead of
  walking every online CPU.  An smp_mb__before_atomic() between the
  head publish and the cpumask_set_cpu() ensures observers of the
  pending bit also observe the published head; without it, weakly-
  ordered architectures could let the consumer drain stale head and
  delay the report.  The consumer pairs this with an
  smp_mb__after_atomic() between cpumask_clear_cpu() and reading
  head, so a producer that publishes between the consumer's clear
  and head-read is observed via the bit it re-sets rather than
  silently stranded.

Consumer (kdamond_check_reported_accesses) drains the rings of CPUs
in damon_rings_pending, applying reports to targets.

Signed-off-by: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
---
 mm/damon/core.c | 143 ++++++++++++++++++++++++++++++++++--------------
 1 file changed, 101 insertions(+), 42 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index b605d36b29b1a..9ed789e932ebd 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -25,7 +25,26 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/damon.h>
 
-#define DAMON_ACCESS_REPORTS_CAP 1000
+/* Sized so the per-CPU ring set fits in L3 on typical multi-socket boxes. */
+#define DAMON_REPORT_RING_SIZE	256
+#define DAMON_REPORT_RING_MASK	(DAMON_REPORT_RING_SIZE - 1)
+
+struct damon_report_ring {
+	unsigned int head;	/* written by producer (NMI) */
+	unsigned int tail	/* written by consumer (kdamond) */
+		____cacheline_aligned_in_smp;
+	struct damon_access_report entries[DAMON_REPORT_RING_SIZE]
+		____cacheline_aligned_in_smp;
+};
+
+static DEFINE_PER_CPU(struct damon_report_ring, damon_report_rings);
+static DEFINE_PER_CPU(int, damon_report_ring_busy);
+/*
+ * Per-CPU bitmap: producer (NMI) sets after publishing a report;
+ * consumer (kdamond) clears before draining the corresponding ring.
+ * Hot-write under sampling load - do NOT mark __read_mostly.
+ */
+static cpumask_t damon_rings_pending;
 
 static DEFINE_MUTEX(damon_lock);
 static int nr_running_ctxs;
@@ -36,10 +55,6 @@ static struct damon_operations damon_registered_ops[NR_DAMON_OPS];
 
 static struct kmem_cache *damon_region_cache __ro_after_init;
 
-static DEFINE_MUTEX(damon_access_reports_lock);
-static struct damon_access_report damon_access_reports[
-	DAMON_ACCESS_REPORTS_CAP];
-static int damon_access_reports_len;
 
 /* Should be called under damon_ops_lock with id smaller than NR_DAMON_OPS */
 static bool __damon_is_registered_ops(enum damon_ops_id id)
@@ -2127,33 +2142,56 @@ int damos_walk(struct damon_ctx *ctx, struct damos_walk_control *control)
 }
 
 /**
- * damon_report_access() - Report identified access events to DAMON.
- * @report:	The reporting access information.
+ * damon_report_access() - Report a hardware-observed memory access.
+ * @report:	pointer to a filled damon_access_report struct.
  *
- * Report access events to DAMON.
- *
- * Context: May sleep.
- *
- * NOTE: we may be able to implement this as a lockless queue, and allow any
- * context.  As the overhead is unknown, and region-based DAMON logics would
- * guarantee the reports would be not made that frequently, let's start with
- * this simple implementation.
+ * Context: NMI-safe.  No sleeping, no allocation, no locks.
  */
 void damon_report_access(struct damon_access_report *report)
 {
-	struct damon_access_report *dst;
+	struct damon_report_ring *ring;
+	unsigned int head, next;
 
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
+	/* Pin to a CPU so the SPSC invariant holds for preemptible callers. */
+	preempt_disable();
+	/*
+	 * NMI nesting on the same CPU as a process-context producer would
+	 * stomp the same entries[head] slot.  Detect and drop instead.
+	 */
+	if (this_cpu_inc_return(damon_report_ring_busy) != 1) {
+		/* NMI nested on a process-context producer; drop. */
+		goto out;
+	}
+
+	ring = this_cpu_ptr(&damon_report_rings);
+	head = ring->head;
+	next = (head + 1) & DAMON_REPORT_RING_MASK;
+
+	if (next == READ_ONCE(ring->tail)) {
+		/* Ring full; consumer is behind, drop the report. */
+		goto out;
+	}
+
+	ring->entries[head] = *report;
+	ring->entries[head].report_jiffies = jiffies;
+	smp_wmb(); /* ensure entry visible before head advance */
+	WRITE_ONCE(ring->head, next);
+	/*
+	 * Order the head advance before publishing the pending bit
+	 * so that the consumer, on observing the bit, is also
+	 * guaranteed to observe the new head.  set_bit/cpumask_set_cpu
+	 * are documented as unordered RMW (atomic_bitops.txt), hence
+	 * the explicit barrier; without it, a weakly-ordered arch
+	 * could let the consumer drain stale head, clear the bit, and
+	 * delay the report until the next producer sets the bit again.
+	 */
+	smp_mb__before_atomic();
+	cpumask_set_cpu(smp_processor_id(), &damon_rings_pending);
+out:
+	this_cpu_dec(damon_report_ring_busy);
+	preempt_enable();
 }
+EXPORT_SYMBOL_GPL(damon_report_access);
 
 #ifdef CONFIG_MMU
 void damon_report_page_fault(struct vm_fault *vmf, bool huge_pmd)
@@ -3814,26 +3852,47 @@ static unsigned int kdamond_apply_zero_access_report(struct damon_ctx *ctx)
 
 static unsigned int kdamond_check_reported_accesses(struct damon_ctx *ctx)
 {
-	int i;
-	struct damon_access_report *report;
+	int cpu;
 	struct damon_target *t;
 
-	/* currently damon_access_report supports only physical address */
-	if (damon_target_has_pid(ctx))
-		return 0;
+	for_each_cpu(cpu, &damon_rings_pending) {
+		struct damon_report_ring *ring =
+			per_cpu_ptr(&damon_report_rings, cpu);
+		unsigned int head, tail;
 
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
+		cpumask_clear_cpu(cpu, &damon_rings_pending);
+		/*
+		 * Pair with the producer's smp_mb__before_atomic() between
+		 * the head publish and cpumask_set_cpu(): order the bit
+		 * clear before the head read so that a producer publishing
+		 * between our clear and our READ_ONCE(head) is observed via
+		 * the bit it re-sets, not lost as a stale-head drain.
+		 */
+		smp_mb__after_atomic();
+		head = READ_ONCE(ring->head);
+		/*
+		 * Pair with smp_wmb in damon_report_access(): the entry
+		 * data published before the producer advanced head must be
+		 * visible to the entries[] reads inside the loop below.
+		 */
+		smp_rmb();
+		tail = ring->tail;
+
+		while (tail != head) {
+			struct damon_access_report *report =
+				&ring->entries[tail];
+
+			if (!time_before(report->report_jiffies,
+					jiffies - usecs_to_jiffies(
+						ctx->attrs.sample_interval))) {
+				damon_for_each_target(t, ctx)
+					kdamond_apply_access_report(
+							report, t, ctx);
+			}
+			tail = (tail + 1) & DAMON_REPORT_RING_MASK;
+		}
+		WRITE_ONCE(ring->tail, tail);
 	}
-	mutex_unlock(&damon_access_reports_lock);
 	/* For nr_accesses_bp, absence of access should also be reported. */
 	return kdamond_apply_zero_access_report(ctx);
 }
-- 
2.43.0


