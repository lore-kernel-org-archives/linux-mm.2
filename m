Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D52C7CA5FF0
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 08:47:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFFD16B0095; Mon,  5 Oct 2026 04:46:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AADDC6B0096; Mon,  5 Oct 2026 04:46:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9510C6B0098; Mon,  5 Oct 2026 04:46:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6A89F6B0095
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 04:46:58 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F027AA55B6
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 08:46:57 +0000 (UTC)
X-FDA: 85287942474.17.BE2D161
Received: from mail-yx2-f8.google.com (mail-yx2-f8.google.com [74.125.224.136])
	by imf21.hostedemail.com (Postfix) with ESMTP id 222171C0002
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 08:46:56 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WlIbxxok;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.224.136 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791190016;
	b=VWL5CXlLVrd2X3Sxl1qxOGZOaRm86EW/NJstMD7RmYRmqs6JLiAFxf4fbQHmyZf+EuyNqq
	o948PbpRMHf9tTsK8/UncE6+tEtXDmlDabZ6KW4R0a6ykBjkitdyNUZ93M1RSKToQ0lqfd
	NXzlRA/EgahY7hpTdeblhkRtApMLIUw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WlIbxxok;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.224.136 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791190016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/J7osJHm2N8a77SfFYJZPDqFvM/db1vclqrc+d5iYvs=;
	b=t2A60iHNJqN3LaYil4vN/RIWD+mv0Qnjbn9W78IsbJpzw27oHCDnfP394rbwa01vxVlwGt
	1mCBryx9yeEntplpPJxPfFTuhwcTeuSP5+vvQSclSQXI+4H+oRxikzXWbTS+eVyyAokCgo
	Tc3KVtWzqkbknEHOXZvN18Eb1NvMR4Q=
Received: by mail-yx2-f8.google.com with SMTP id 00721157ae682-8ae5a69609fso2311397b3.1
        for <linux-mm@kvack.org>; Mon, 05 Oct 2026 01:46:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791190015; x=1791794815; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/J7osJHm2N8a77SfFYJZPDqFvM/db1vclqrc+d5iYvs=;
        b=WlIbxxoktqNYsdz7Ow1zWlrxZ8p0oDtiOss2VVJUQVdfbbEj0M8PlWSsmck4yPk/zu
         QJA0MjauoBprWW9Akgel/o10LC1YA+MzCAC3BfY8ONhNHgc1qhiIWCUwX5BJQ/i1Jjjt
         3/ccAaLlJ/MvjSPBfgCu/49QLgCFxtdjA9WS6/vRM9QS9ibZlQqJhJmZfxdufKbIRc5R
         WCVhRlvLKcaAl3gRTUma6QX8dBvKt15ScYXxAm441p8x5nOURNWYN2O2Wfr/wJpae9wz
         nSIKsUb41BO7nVtLYgs7+9k0xALW4KOAqq5VFsdaGRdQyLLqxJ8fSxO74RrluRQJXVPf
         TF+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791190015; x=1791794815;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/J7osJHm2N8a77SfFYJZPDqFvM/db1vclqrc+d5iYvs=;
        b=DV4CJqbrfE6UZfU48YCKmW47WIvNdHF3Hh6ofUlr/ZVEUtcPwqwzobjNO5NyBRdSWe
         U6WPc0uCrVkYqoOUbFvdtLUTeSyTgE4fth4DuuZbb+6RcfEssJl7Ad3fR6shheOMz4O2
         EcYkJsv7SaGZMV6SzWe9A2SgF6gxV482bmtWvZ97xO4rOv0rvSsmo1IB14Id2Fw/sgVg
         pMrxeGr0KTzYmrc27Tbdo+HG35NnRAi7XVXM9raiFzS+MaBlsCrWfwXKysmtzUQtDkYl
         h4TegVIzJYc5lksFGffEOdPP3YSAfrEYSodiuTu6ofTpaIyDFrYmIUZqFbqZmklisqFT
         TVTw==
X-Forwarded-Encrypted: i=1; AKwUvByDnm0rE6fD0YXQCTQIbF7Y1YiS/pSWEDJyvKq8ATvn5xemYz5QWU8iFpA2rTpWdHBYVPJ2CMXPwA==@kvack.org
X-Gm-Message-State: AFq9FYKSw1H6ymRHgcswkQUotdVpmXDJzJ0KxyEdEtawju6qWArEExPy
	L0i3p0fOBBanChKhVHirY5U5MnvVa6MjCImOz6Qw4WKIPFD79b7sr2I=
X-Gm-Gg: AYBFou1SQUs2gufhs49tMAVMSfspJhv5kkK0Lfa2h4TiHwItvCBxg1h0CbukSyVpprp
	qCDaanSIaEZMgBA/qee4/YPhSv3Gy+skz5lVNtha+dyHPhlpAbbmv2EKIL+7QsxqHOn8vF9rkfU
	jHmTf51vaN0MGxuY2NXeldmlTvP5Y1baVyh4HS70T07pDc+JffGOGIQ0P+lM7ZC17kwfi6QhwMR
	43Jt4pSiwU0V6w2tgN255CEpudCHV8Ee6TQ9U/7dFB4ScRXL0aNOGfuw4/8vnKC0yT6vsl2y9o/
	ypIlReqPl6cAycSLjmsTFD3EGo2slnArcFl0G/+Vp/7ZRO74PvGJAmEtjE3jTqdt0YtuwMGcPxG
	Z51s7ytccMuPv9d7Kta0JcE69WkSnAv+aV3vDZepEDMFBN3f2s35ZZ99R+MrPGP1VpNzDYcGkAt
	nB5NYq/Ig5oyOoCZu57kFU8y9cTtEbYvshLnAAoV5p+6O+NWN284XcSw9rCPkkGNe96e67EGmZR
	JzhfUOBxbZjgp4KYznXvTHyQnjEQj7Hejx8eo0WoCAS84/2J+icxG9x6ajBE8Hr7DVr05rSiS+M
	3ONtwS44t6LQCgC9NYtXjz4m5cHe795Dqw==
X-Received: by 2002:a05:690e:1c08:b0:675:657b:8054 with SMTP id 956f58d0204a3-677ac0429f0mr4474486d50.40.1791190014921;
        Mon, 05 Oct 2026 01:46:54 -0700 (PDT)
Received: from 1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.ip6.arpa ([2600:1700:4577:1050:1149:2fcd:c86b:8747])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-677c1b9c895sm2346306d50.13.2026.10.05.01.46.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2026 01:46:54 -0700 (PDT)
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Date: Mon, 05 Oct 2026 01:46:46 -0700
Subject: [RFC PATCH v4 2/9] mm/damon/core: replace the access report buffer
 with per-context rings
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261005-damon-perf-rfc-v3-send-2026-10-03-v4-2-b03452e137f3@gmail.com>
References: <20261005-damon-perf-rfc-v3-send-2026-10-03-v4-0-b03452e137f3@gmail.com>
In-Reply-To: <20261005-damon-perf-rfc-v3-send-2026-10-03-v4-0-b03452e137f3@gmail.com>
To: SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Gregory Price <gourry@gourry.net>, David Rientjes <rientjes@google.com>, 
 Wei Xu <weixugc@google.com>, Jonathan Corbet <corbet@lwn.net>, 
 Bijan Tabatabai <bijan311@gmail.com>, Ajay Joshi <ajayjoshi@micron.com>, 
 Honggyu Kim <honggyu.kim@sk.com>, Yunjeong Mun <yunjeong.mun@sk.com>, 
 Akinobu Mita <akinobu.mita@gmail.com>, Lian Wang <lianux.mm@gmail.com>, 
 Kunwu Chan <kunwu.chan@linux.dev>, 
 Ravi Jonnalagadda <ravis.opensrc@gmail.com>, 
 Jonathan Cameron <jic23@kernel.org>
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam06
X-Stat-Signature: fo3bawdhfpoggi39asu111pk9rni4fty
X-Rspam-User: 
X-Rspamd-Queue-Id: 222171C0002
X-HE-Tag: 1791190016-793822
X-HE-Meta: U2FsdGVkX1+siukHvabXPQiMIf0cpdbbRCQuRfQaNrTCl+H2iUavOhp/tsn728EdV72fnPGvvMFAGlR0UEJ97yTrVYBxIokiYf/8b1colkMsnu6ci1vg0nqsZjIR+8llVZPAqrSxtL2zwKSJ1/M25c3S4xu7oxFHxUXGCKwOC5ceaKfHZC0EmAaS99RiPGJ1oqunWKRqZnyIhDNOSzEq6FABi3vvjX74DXjxwlj+/BffgoMRHbELmbRx0DOolkCdpRIeuB7wJvKqUNJzhD0SgO+pPNqy5zn8I8WyFTTfxL7Nx8V1ecN9cl63BC8002fxKDW2q/pf6Rrgsz2Kcams6fd5/6ciZi4RpRPRaCpzxPiXl3XtPNhssIElFw9LTIq8ORWP25pBGnZdLn3J7qvDxWoF23VYOnp+x4il/ekniDOJ9DbX/Vr0YklZTrAJF+w08/XNQj6IckRlKbbzut0VaGkfkdlQTonVdlMn+nNdKNZpwOJagdZPCFobDWiQvabiypp/Y0N/uVYTm8mU78epaiC7RUZ/faQ5TSj7cx+Yf6hkxNacFSeUH51iHjL3PT8RE900dGvgyWb3Z4Ez9wji7ctr5K2veYfcrlALRDZV8wMJClkQZe3p8h3bvx2Ar4PTA9PxzGMMnG5GXd+ruqDybBLJO5oHAyPKXtfx5moFJ+zxHIM2e+3utak5nKReJOmbySrgXGQzTAvQ0SRYV2Bnr/L8evaJ4A0E7PojWt7jXKXPKqQcq8CKY9zp8PPCONeDuFBwWGZBtCpCJvmDt1/FA/Hv+byZpRdQqqd0J0oDPwIXu55PMB6qRHwCkhxFcmhOUhIgNY/W33QwQdTcCirLtYwdWi2fhOWq7pm6Q8CnRo25SmQLEhl6RiIn8NOTmhKzrFgEig/cUvz8VsFMyEE1sdXg2o7sRYwORNgOf4G/RcNScPAVDhKQSR69i1SyO3f4zoZD/v9NTlh7+TQhuq9
 hfSRJkeZ
 cx/+5iYRfTdWsnbRyIPEkTABERGakPxxwMFga+Tf8P+AEE7JC9G+CMKGlYEQWHI/dysDgl5TWXgHwnGfiGWBouk8AbYn0M8T1s299ZSsJf+do6QBoRG02iwttVoT/JYEgUJ/2HSzJkahnxk7GeUs5JjRQfqDOd9lkdUl5AVhOx4RYzxAIkY14XOWm3gjxwxyMRGyCcSAnxV/y/uVNS8sOz/miZqcOHuLw728tfDcCYCvlMAfV1YQA+se1nvr9m6fs/g9MuxzmwSRkwZPdl65ZlFNugxw8qvz9B6RVmFnrlM0NoCU9LgXTVqF4mQG/ox31hjtpedXa7ZYeRVjrGbzzPV8lJ3LK6Qe5JfKg1oSYZ4dhN+Ek24LXVb29ZoaI3yz62d2bxiE25+tIv9LxYIL6EvjRbP/gQaSLcL1A2qlmnDyH7r5Uj/uMli9Xy5djtCOxeEpptm0DNvhTFNG+qd1z/MN5Sft1zTS9RIV7QL4IAzwGsETC0n/ksGCf05ZU89CNXQmw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_report_access() queues reports into the global damon_access_reports[]
buffer under a mutex, and kdamond applies them from there.  A perf-event
overflow handler runs in NMI context and cannot take that mutex, and the
buffer has no other producer.

Replace the buffer with a per-context, per-CPU SPSC report ring
(ctx->perf_rings) that an NMI-context producer can publish into, and a
kdamond drain that credits regions from each ring's pending reports.

NMI safety: the producer uses a busy counter to drop re-entrant reports on
the same CPU, publishes with smp_wmb() before advancing the head, and sets
a pending-CPU bitmask with smp_mb__before_atomic() so the consumer catches
any report published between the bit-clear and the READ_ONCE(head).  The
consumer publishes the tail with smp_store_release() after reading the
entries, and the producer reads it with smp_load_acquire(), so a slot is
not reused while it is still being read.  A source allocates the ring
before it arms its first perf event for the context, and
damon_destroy_ctx() frees it after the events are released, so no
in-flight NMI can reach freed storage.  Per-CPU counters count the
reports dropped because a ring was full or its busy guard was held, the
reports drained into a region and those that matched none; the
damon_get_*() accessors read them for the kunit tests.

The drain matches each report to a region by binary search over a
per-target region snapshot built in ar.start order, the region-list
invariant damon_credit_report_bsearch() relies on.  Pid targets are
matched by the thread group id of the target's task, so a target named
by any of its threads matches, compared as the global pid number, since
a producer may run in any pid namespace.  Each drained report adds one
to the region's probe_hits[] slot for its probe, at most once per
sampling interval, the same bound a probe hit has for the samples DAMON
takes itself; that keeps probe_hits[] within the samples per
aggregation, as the code that splits, merges and rescales it assumes.
A physical address is matched in the context's address unit.
The reports are data attribute samples, so the drain does not change
nr_accesses, which stays with the access check primitives.  That leaves
the access_reported flag and kdamond_apply_zero_access_report(), which
served only the page fault primitive's reports, with no user; remove
them.

Signed-off-by: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
---
 include/linux/damon.h | 102 ++++++++-
 mm/damon/core.c       | 591 ++++++++++++++++++++++++++++++++++++++++++--------
 2 files changed, 605 insertions(+), 88 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 7940840b4da9..e6d2e9d0936e 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -17,9 +17,19 @@
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
@@ -74,7 +84,9 @@ struct damon_region {
 	/* for age calculation. */
 	unsigned int last_nr_accesses;
 	unsigned char last_probe_hits[DAMON_MAX_PROBES];
-	bool access_reported;
+	/* probes already credited in sampling interval probes_reported_sis */
+	unsigned long probes_reported_sis;
+	unsigned char probes_reported;
 };
 
 /**
@@ -110,7 +122,18 @@ struct damon_target {
  * @size:		The size of the accessed address range.
  * @cpu:		The id of the CPU that made the access.
  * @tid:		The task id of the task that made the access.
+ * @tgid:		The thread group id of the task that made the access, in
+ *			the initial pid namespace.  A monitoring target created
+ *			for a process is matched against it.
  * @is_write:		Whether the access is write.
+ * @probe_idx:		1-based index of the reporting probe; the drain credits
+ *			probe_hits[@probe_idx - 1].  Set by the reporting
+ *			source, so the drain needs no list walk.
+ *			0 is reserved (no probe attribution; matches zero-init);
+ *			perf-event probe indices start at 1.
+ * @ctx:		Context whose report ring receives the report; set by
+ *			the reporting source.  A report with no context is
+ *			dropped by damon_report_access().
  *
  * Any DAMON API callers that notified access events can report the information
  * to DAMON using damon_report_access().  This struct contains the reporting
@@ -122,11 +145,49 @@ struct damon_access_report {
 	unsigned long size;
 	unsigned int cpu;
 	pid_t tid;
+	pid_t tgid;
 	bool is_write;
+	int probe_idx;
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
+ * One ring per CPU, per context with a perf-event probe.  The producer
+ * (NMI overflow handler) writes to @head; the consumer (kdamond) reads
+ * from @tail.  Both indices are unsigned and wrap modulo
+ * DAMON_REPORT_RING_SIZE.
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
+ * @tgid:	Thread group id of a pid target's task; 0 if it has none.
+ *
+ * Built once per drain by damon_build_target_lookup() so the ring drain can
+ * binary-search a target's regions instead of walking the list.
+ */
+struct damon_target_lookup {
+	struct damon_region **regions;
+	unsigned int nr_regions;
+	pid_t tgid;
+};
+
 /**
  * enum damos_action - Represents an action of a Data Access Monitoring-based
  * Operation Scheme.
@@ -871,9 +932,12 @@ struct damon_filter {
  * struct damon_probe - Data region attribute probe.
  *
  * @weight:	Relative priority of the attribute for this probe.
+ * @event_driven:	Whether the probe's hits arrive through the report ring
+ *		drain rather than the apply_probes callback.
  */
 struct damon_probe {
 	unsigned int weight;
+	bool event_driven;
 /* private: */
 	/* Preparation actions to apply to each probing memory. */
 	struct list_head preps;
@@ -1091,6 +1155,29 @@ struct damon_ctx {
 
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
+	 * Per-context perf-event report ring.  A perf overflow handler carries
+	 * a pointer to the ctx that armed it (damon_access_report.ctx), so its
+	 * reports route to this ring and two perf-driven ctxs never share one.
+	 *
+	 * A source allocates it with damon_ctx_alloc_perf_ring() before it
+	 * arms the first perf event of the ctx, and damon_destroy_ctx() frees
+	 * it after the events are released, so no in-flight NMI can reach
+	 * freed storage.
+	 * While perf_rings is NULL, every perf report for the ctx is dropped.
+	 */
+	struct damon_report_ring __percpu *perf_rings;
+	int __percpu *perf_ring_busy;
+	cpumask_t perf_pending;
 };
 
 /* Get a random number in [@l, @r) using @ctx's lockless PRNG. */
@@ -1209,6 +1296,7 @@ void damon_destroy_filter(struct damon_filter *f);
 
 struct damon_probe *damon_new_probe(void);
 void damon_add_probe(struct damon_ctx *ctx, struct damon_probe *probe);
+bool damon_has_event_driven_probes(struct damon_ctx *ctx);
 
 struct damon_region *damon_new_region(unsigned long start, unsigned long end);
 unsigned int damon_nr_accesses_mvsum(struct damon_region *r,
@@ -1298,13 +1386,20 @@ int damon_kdamond_pid(struct damon_ctx *ctx);
 int damon_call(struct damon_ctx *ctx, struct damon_call_control *control);
 int damos_walk(struct damon_ctx *ctx, struct damos_walk_control *control);
 
-void damon_report_access(struct damon_access_report *report);
+bool damon_report_access(struct damon_access_report *report);
+int damon_ctx_alloc_perf_ring(struct damon_ctx *ctx);
 
 int damon_set_region_system_rams_default(struct damon_target *t,
 				unsigned long *start, unsigned long *end,
 				unsigned long addr_unit,
 				unsigned long min_region_sz);
 
+unsigned long damon_get_report_overflow(void);
+unsigned long damon_get_report_ring_full(void);
+unsigned long damon_get_report_busy_drop(void);
+unsigned long damon_get_samples_drained(void);
+unsigned long damon_get_samples_no_region(void);
+
 #ifdef CONFIG_ACMA
 
 unsigned long damon_alloced_bytes(void);
@@ -1313,8 +1408,9 @@ unsigned long damon_alloced_bytes(void);
 
 #else	/* CONFIG_DAMON */
 
-static inline void damon_report_access(struct damon_access_report *report)
+static inline bool damon_report_access(struct damon_access_report *report)
 {
+	return false;
 }
 
 #endif	/* CONFIG_DAMON */
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 3638e2054030..8f78700afedd 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -22,7 +22,66 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/damon.h>
 
-#define DAMON_ACCESS_REPORTS_CAP 1000
+/*
+ * Reports are fed to DAMON through a per-context, per-CPU SPSC ring
+ * (ctx->perf_rings).  A report carries its owning ctx, so each context drains
+ * only its own ring.
+ */
+/*
+ * Report drops are counted per reason.  A ring-full drop means the consumer
+ * did not keep up with the producer; a busy-guard drop means an NMI nested on
+ * top of a same-CPU producer.
+ */
+static DEFINE_PER_CPU(unsigned long, damon_report_ring_full_perf);
+static DEFINE_PER_CPU(unsigned long, damon_report_busy_drop_perf);
+static DEFINE_PER_CPU(unsigned long, damon_samples_drained);
+static DEFINE_PER_CPU(unsigned long, damon_samples_no_region);
+
+unsigned long damon_get_report_ring_full(void)
+{
+	unsigned long sum = 0;
+	int cpu;
+
+	for_each_possible_cpu(cpu)
+		sum += per_cpu(damon_report_ring_full_perf, cpu);
+	return sum;
+}
+
+unsigned long damon_get_report_busy_drop(void)
+{
+	unsigned long sum = 0;
+	int cpu;
+
+	for_each_possible_cpu(cpu)
+		sum += per_cpu(damon_report_busy_drop_perf, cpu);
+	return sum;
+}
+
+/* Reports dropped for either reason. */
+unsigned long damon_get_report_overflow(void)
+{
+	return damon_get_report_ring_full() + damon_get_report_busy_drop();
+}
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
+
+unsigned long damon_get_samples_no_region(void)
+{
+	unsigned long sum = 0;
+	int cpu;
+
+	for_each_possible_cpu(cpu)
+		sum += per_cpu(damon_samples_no_region, cpu);
+	return sum;
+}
 
 static DEFINE_MUTEX(damon_lock);
 static int nr_running_ctxs;
@@ -33,11 +92,6 @@ static struct damon_operations damon_registered_ops[NR_DAMON_OPS];
 
 static struct kmem_cache *damon_region_cache __ro_after_init;
 
-static DEFINE_MUTEX(damon_access_reports_lock);
-static struct damon_access_report damon_access_reports[
-	DAMON_ACCESS_REPORTS_CAP];
-static int damon_access_reports_len;
-
 /* Should be called under damon_ops_lock with id smaller than NR_DAMON_OPS */
 static bool __damon_is_registered_ops(enum damon_ops_id id)
 {
@@ -288,6 +342,34 @@ static bool damon_has_probe_weights(struct damon_ctx *c)
 	return false;
 }
 
+/**
+ * damon_has_event_driven_probes() - return true if @ctx has any event-driven
+ * probes registered.
+ * @ctx: the DAMON context whose probes are inspected.
+ *
+ * Event-driven probes (e.g. perf-event IBS/PEBS) populate probe_hits[] via
+ * the SPSC ring drain rather than the apply_probes vtable.  A context drains
+ * its perf report ring only when this returns true.
+ *
+ * Return: true if @ctx has an event-driven probe.
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
+
+/* Does @ctx drain a perf report ring? */
+static bool damon_drains_ring_perf(struct damon_ctx *ctx)
+{
+	return damon_has_event_driven_probes(ctx);
+}
+
 /*
  * damon_mvsum() - Returns pseudo moving sum value for a time window.
  * @current_nr:		The value of the current aggregation window.
@@ -414,7 +496,8 @@ struct damon_region *damon_new_region(unsigned long start, unsigned long end)
 
 	region->age = 0;
 	region->last_nr_accesses = 0;
-	region->access_reported = false;
+	region->probes_reported_sis = 0;
+	region->probes_reported = 0;
 
 	return region;
 }
@@ -1025,6 +1108,38 @@ struct damon_ctx *damon_new_ctx(void)
 	return ctx;
 }
 
+/*
+ * Lazily allocate the per-ctx perf report ring.  Call before arming any perf
+ * event that reports into @ctx, so an overflow can never observe a half-built
+ * ring.  Idempotent: a ctx with several perf probes allocates once.  The ring
+ * is freed in damon_destroy_ctx().
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
@@ -1050,6 +1165,12 @@ void damon_destroy_ctx(struct damon_ctx *ctx)
 	damon_for_each_sample_filter_safe(f, next_f, &ctx->sample_control)
 		damon_destroy_sample_filter(f, &ctx->sample_control);
 
+	/* No-op if never allocated. */
+	damon_ctx_free_perf_ring(ctx);
+
+	/* Free the reusable ring-drain region snapshot buffers. */
+	kfree(ctx->drain_snapshot.lookups);
+	kfree(ctx->drain_snapshot.region_buf);
 	kfree(ctx);
 }
 
@@ -2521,29 +2642,102 @@ int damos_walk(struct damon_ctx *ctx, struct damos_walk_control *control)
  * damon_report_access() - Report identified access events to DAMON.
  * @report:	The reporting access information.
  *
- * Report access events to DAMON.
+ * Report access events to DAMON via a per-context per-CPU SPSC lockless ring
+ * (ctx->perf_rings).  Producer is the local CPU (typically NMI from a
+ * hardware-sampling backend); consumer is the kdamond drain in
+ * kdamond_check_reported_accesses().
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
+ * reports per drain regardless of the number of producing CPUs.
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
+	 * Only perf-event reports (probe_idx >= 1) have a ring to feed.  A
+	 * probe_idx == DAMON_PROBE_IDX_NONE report has nowhere to go and is
+	 * dropped here rather than at each caller.
+	 */
+	struct damon_report_ring *ring;
+	cpumask_t *pending;
+	int __percpu *busy_pcpu;
+	unsigned int head, next;
+	int busy;
+	bool queued = false;
+	struct damon_ctx *pctx = report->ctx;
+
+	if (report->probe_idx == DAMON_PROBE_IDX_NONE)
+		return false;
 
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
+	 * and that ctx must have allocated its per-ctx perf ring; drop the
+	 * report otherwise.
+	 */
+	if (!pctx || !pctx->perf_rings || !pctx->perf_ring_busy)
+		return false;
+
+	/* Pin to a CPU so the SPSC invariant holds for preemptible callers. */
+	preempt_disable();
+	busy_pcpu = pctx->perf_ring_busy;
+	busy = this_cpu_inc_return(*busy_pcpu);
+	if (busy != 1) {
+		/* NMI nested on a process-context producer; drop. */
+		this_cpu_inc(damon_report_busy_drop_perf);
+		goto out;
+	}
+
+	ring = this_cpu_ptr(pctx->perf_rings);
+	pending = &pctx->perf_pending;
+	head = ring->head;
+	next = (head + 1) & DAMON_REPORT_RING_MASK;
+
+	/* pairs with the consumer's smp_store_release() of tail */
+	if (next == smp_load_acquire(&ring->tail)) {
+		this_cpu_inc(damon_report_ring_full_perf);
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
 
 /*
@@ -4247,73 +4441,299 @@ static bool damon_sample_filter_out(struct damon_access_report *report,
 	return !filter->allow;
 }
 
-static void kdamond_apply_access_report(struct damon_access_report *report,
-		struct damon_target *t, struct damon_ctx *ctx)
+/*
+ * Build a snapshot of the ctx's targets and their region arrays for use by
+ * the ring drain loop.  The snapshot buffer is reused across ticks, grown via
+ * krealloc only when a new high water mark is reached.
+ *
+ * Only the kdamond mutates the target list (other threads go through
+ * damon_call()), so the list cannot change between the two passes, even while
+ * krealloc_array() sleeps.  Regions within a target are kept address-sorted by
+ * DAMON, so the snapshot arrays are directly binary-searchable.
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
+	*nr_targets_out = nr_targets;
+
+	if (nr_targets > ctx->drain_snapshot.nr_lookups) {
+		tbl = krealloc_array(ctx->drain_snapshot.lookups,
+				nr_targets, sizeof(*tbl), GFP_KERNEL);
+		if (!tbl)
+			return NULL;
+		ctx->drain_snapshot.lookups = tbl;
+		ctx->drain_snapshot.nr_lookups = nr_targets;
+	}
+	tbl = ctx->drain_snapshot.lookups;
 
-	/* todo: make search faster, e.g., binary search? */
-	damon_for_each_region(r, t) {
-		if (addr < r->ar.start)
-			continue;
-		if (r->ar.end < addr + report->size)
-			continue;
-		if (!r->access_reported)
-			damon_update_region_access_rate(r, true);
-		r->access_reported = true;
+	if (total_regions > ctx->drain_snapshot.region_buf_cap) {
+		struct damon_region **buf;
+
+		buf = krealloc_array(ctx->drain_snapshot.region_buf,
+				total_regions, sizeof(*buf), GFP_KERNEL);
+		if (!buf)
+			return NULL;
+		ctx->drain_snapshot.region_buf = buf;
+		ctx->drain_snapshot.region_buf_cap = total_regions;
 	}
+
+	/*
+	 * DAMON maintains each target's region list sorted by ar.start.
+	 * damon_credit_report_bsearch() binary-searches by address, so the
+	 * snapshot built here must preserve that order.  If the region-list
+	 * ordering invariant ever changes, this builder must sort explicitly.
+	 */
+	damon_for_each_target(t, ctx) {
+		struct damon_region *r;
+
+		tbl[ti].regions = &ctx->drain_snapshot.region_buf[ri];
+		tbl[ti].nr_regions = damon_nr_regions(t);
+		tbl[ti].tgid = 0;
+		if (damon_target_has_pid(ctx)) {
+			struct task_struct *task;
+
+			/* a target may be named by any of its threads */
+			rcu_read_lock();
+			task = pid_task(t->pid, PIDTYPE_PID);
+			if (task)
+				tbl[ti].tgid = task_tgid_nr(task);
+			rcu_read_unlock();
+		}
+		damon_for_each_region(r, t)
+			ctx->drain_snapshot.region_buf[ri++] = r;
+		ti++;
+	}
+
+	return tbl;
 }
 
-static unsigned int kdamond_apply_zero_access_report(struct damon_ctx *ctx)
-{
+/*
+ * Binary-search a sorted region snapshot for the region containing @addr and,
+ * on a hit, add the report to the region's hits of probe @pidx, at most once
+ * per sampling interval @sis.  Returns true if a region was found (straddling
+ * reports that spill past the region end are rejected).
+ */
+static bool damon_credit_report_bsearch(struct damon_region **regions,
+		unsigned int nr_regions, unsigned long addr,
+		unsigned long size, int pidx, unsigned long sis)
+{
+	struct damon_region *r = NULL;
+	int left = 0, right = (int)nr_regions - 1, mid;
+
+	while (left <= right) {
+		/* Avoid (left + right) overflow at large nr_regions. */
+		mid = left + (right - left) / 2;
+		if (addr < regions[mid]->ar.start) {
+			right = mid - 1;
+		} else if (addr >= regions[mid]->ar.end) {
+			left = mid + 1;
+		} else {
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
+	 * pidx is always >= 1 here: __kdamond_drain_ring rejects
+	 * DAMON_PROBE_IDX_NONE (0) entries before calling this.  Ring
+	 * probe_idx is 1-based, but probe_hits[] storage is 0-based to match
+	 * all readers (wsum, mvsum, update, aggregate reset, merge).
+	 * Convert here: probe_hits[pidx - 1].
+	 */
+	if (r->probes_reported_sis != sis) {
+		r->probes_reported_sis = sis;
+		r->probes_reported = 0;
+	}
+	/* at most one hit per interval, as DAMON's own sampling */
+	if (!(r->probes_reported & BIT(pidx - 1))) {
+		r->probe_hits[pidx - 1]++;
+		r->probes_reported |= BIT(pidx - 1);
+	}
+	return true;
+}
+
+/*
+ * __kdamond_drain_ring - drain a per-CPU SPSC ring into region probe_hits.
+ * @ctx:		draining context (owns @ring for this run).
+ * @tbl:		pre-built sorted per-target region snapshot (shared).
+ * @ring_pcpu:		the per-CPU ring base (ctx's perf ring).
+ * @pending:		the matching pending cpumask.
+ *
+ * Drops stale reports and reports rejected by the context's sample filters,
+ * matches the rest to a region by address and, for pid targets, by thread
+ * group id, and adds the report to the region's probe hits, at most once per
+ * probe per sampling interval.  Reports are data attribute samples, so they do
+ * not change the region's nr_accesses.
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
+	unsigned long match_addr, match_size;
+	bool found;
+	unsigned int ti;
 
-	damon_for_each_target(t, ctx) {
-		damon_for_each_region(r, t) {
-			if (r->access_reported)
-				r->access_reported = false;
-			else
-				damon_update_region_access_rate(r, false);
-			max_nr_accesses = max(max_nr_accesses, r->nr_accesses);
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
+			 * Entries older than one sampling interval are from
+			 * an earlier interval and are dropped.
+			 */
+			stale_before = jiffies -
+				usecs_to_jiffies(ctx->attrs.sample_interval);
+			if (time_before(entry->report_jiffies, stale_before))
+				goto next;
+			pidx = entry->probe_idx;
+			/*
+			 * Every entry in this ring is a perf-event report
+			 * (probe_idx >= 1); damon_report_access() drops any
+			 * DAMON_PROBE_IDX_NONE report before it reaches a ring.
+			 * Reject only out-of-range indices (> DAMON_MAX_PROBES)
+			 * and, defensively, any non-positive value.
+			 */
+			if (pidx <= 0 || pidx > DAMON_MAX_PROBES)
+				goto next;
+
+			/* Drop reports rejected by the ctx sample filters. */
+			if (damon_sample_filter_out(entry,
+						&ctx->sample_control))
+				goto next;
+
+			/*
+			 * Select the address that matches the address space
+			 * the targets of this context are monitoring.  A
+			 * report that carries no address for that space
+			 * cannot be credited.
+			 */
+			if (damon_target_has_pid(ctx)) {
+				match_addr = entry->vaddr;
+				match_size = entry->size;
+			} else {
+				/* regions are in addr_unit units */
+				match_addr = entry->paddr / ctx->addr_unit;
+				match_size = max(entry->size / ctx->addr_unit,
+						1UL);
+			}
+			if (!match_addr)
+				goto next;
+
+			found = false;
+			ti = 0;
+			damon_for_each_target(t, ctx) {
+				/* pid targets: match the tgid of a live task */
+				if (damon_target_has_pid(ctx) &&
+				    (!tbl[ti].tgid ||
+				     tbl[ti].tgid != entry->tgid)) {
+					ti++;
+					continue;
+				}
+				if (damon_credit_report_bsearch(tbl[ti].regions,
+						tbl[ti].nr_regions, match_addr,
+						match_size, pidx,
+						ctx->passed_sample_intervals)) {
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
+		/* finish reading entries before the producer reuses them */
+		smp_store_release(&ring->tail, tail);
 	}
-	return max_nr_accesses;
 }
 
-static unsigned int kdamond_check_reported_accesses(struct damon_ctx *ctx)
+/*
+ * kdamond_check_reported_accesses - drain the per-ctx perf report ring this
+ * ctx feeds.  Called from kdamond main loop after each sampling interval.
+ *
+ * Each context's per-CPU perf ring (ctx->perf_rings) holds event-driven
+ * probe (probe_idx >= 1) reports.  A ctx drains it when it has event-driven
+ * probes registered.
+ *
+ * The per-target sorted region snapshot is built once per drain.
+ */
+static void kdamond_check_reported_accesses(struct damon_ctx *ctx)
 {
-	int i;
-	struct damon_access_report *report;
-	struct damon_target *t;
-
-	/* currently damon_access_report supports only physical address */
-	if (damon_target_has_pid(ctx))
-		return 0;
+	struct damon_target_lookup *tbl;
+	unsigned int nr_targets = 0;
 
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
+	 * fails, skip this drain.
+	 */
+	tbl = damon_build_target_lookup(ctx, &nr_targets);
+	if (!nr_targets)
+		return;
+	if (!tbl) {
+		pr_warn_ratelimited(
+			"damon: target-lookup alloc failed; ring drain skipped this tick\n");
+		return;
 	}
-	mutex_unlock(&damon_access_reports_lock);
-	/* For nr_accesses_bp, absence of access should also be reported. */
-	return kdamond_apply_zero_access_report(ctx);
+
+	if (damon_drains_ring_perf(ctx))
+		__kdamond_drain_ring(ctx, tbl, ctx->perf_rings,
+				&ctx->perf_pending);
 }
 
 /*
@@ -4370,14 +4790,15 @@ static int kdamond_fn(void *data)
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
+		 * Perf-event probes feed damon_report_access() into the per-ctx
+		 * ring; drain it here.
+		 */
+		if (damon_drains_ring_perf(ctx))
+			kdamond_check_reported_accesses(ctx);
+
+		if (!access_check_disabled && ctx->ops.check_accesses)
+			max_merge_score = ctx->ops.check_accesses(ctx);
 
 		if (ctx->ops.apply_probes) {
 			if (time_after_eq(ctx->passed_sample_intervals,

-- 
Git-157)


