Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBC5BCA5FE4
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 21:08:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F05AB6B0095; Sat,  3 Oct 2026 17:08:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDC806B0096; Sat,  3 Oct 2026 17:08:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA39A6B0098; Sat,  3 Oct 2026 17:08:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8C1496B0095
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 17:08:31 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 429D5C0A34
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 21:08:29 +0000 (UTC)
X-FDA: 85282553538.08.C5117D6
Received: from mail-yx2-f9.google.com (mail-yx2-f9.google.com [74.125.224.137])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5804C100007
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 21:08:27 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KzNfhTlI;
	spf=pass (imf14.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.224.137 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791061707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hhMb4cd0V9XMwiBvXIrraSmprNf05JQc0iTPs6JbNS8=;
	b=MTxPDYaB7bpsur5BU2NoX+OHJl5CvzAYsKID9rToM9CkVnqBTk6d1Icwswa5r9XbB4y26d
	DWpmUhJTDK3CUHMAFkW85qldXmwFywo1kg7/Qc1Jd4Jw0XEwc0096HEWHCSENQOAtZzg+1
	myhQ+q4Sr2FMRR+88Eu/OCr4a4umKTg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KzNfhTlI;
	spf=pass (imf14.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.224.137 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791061707;
	b=RWaVkPZUCZrods7R+nj1V2OePNQ77xPSz6bddZ17AZl3uuc7joknrBGMb/snMwATV/trsX
	Mv8E70tXwOyqXfyZ1G5lOQYjiiUIOecLf6dl7NEIYnm2j+Oazt9PviPmm3vcyaXBQnaGRv
	9yyT0zweEmb9oGDaOlbLMS0v5VJonNc=
Received: by mail-yx2-f9.google.com with SMTP id 00721157ae682-8a242f44e2eso973667b3.0
        for <linux-mm@kvack.org>; Sat, 03 Oct 2026 14:08:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791061706; x=1791666506; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hhMb4cd0V9XMwiBvXIrraSmprNf05JQc0iTPs6JbNS8=;
        b=KzNfhTlIHIGoWsz7ORPupkKvLtanZPaNX8VE9RIBaQa5CxykjWPFnHITzGUBxQKb74
         R5sykf/LFZwSY4BQ8KXgHAjCbvjEPB0tYL7cofWC/RJXkv1R3FPH8x1mdaU3g4j8Xuqw
         IPqrPBQCuGwr46JrCr4jjhS4dhB9EVP9qBOJPHalSYsKcZr82QbdTtYn0MGFEolW2Hv5
         TGS/VeyslTZb2XB89JjRt+ZIHMEBD5iBJgZUF+L4qlNtfGRV9vfZM1z88FJjxer353or
         FIeEpPbfGpg4OxQxJzsWKUuFfNylRUvxzAb7dbE+w7WcG8vMNgYylEwMWlRvuoZFjqSy
         wRoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791061706; x=1791666506;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hhMb4cd0V9XMwiBvXIrraSmprNf05JQc0iTPs6JbNS8=;
        b=ecbKU2FlzcYsGQBTQLz07XJHz4ehIahNpomXjcEcT2nN5DO9iD6VOSVtHIB5xqij7p
         OUo1n+j6jRv4NG1DYJwkqIdIGUspw9YgTbx63BwSLbUS/8+pw482gYtvRUhMRxzIeFCR
         7LXtpp/OQezrIdW5ZHlJ5/i6rAWur89/OOHC3bxNl9aTIkc097IV9aLiB+SodBX4nAPl
         lDFzi7bLgaVBZhqKF+hzcrxWqVQ5Xmh/9bNEwCrd90GKdDwoydatfcwXWBW/EKfoBy8r
         eBwN6q7M4CD0TP8rb2O3xUcEg5h0VFyxk0KpVwh6fFrx7pFUoqADvDshHgiK3rBXonpw
         eQig==
X-Forwarded-Encrypted: i=1; AKwUvBxV9zE6Hc4yl3oKR+HXOD/Ct5q7l/0oYQDgxk1ca/J2G0xC93JIAxzRb2j8Aix3MPKYUzgRNPQddQ==@kvack.org
X-Gm-Message-State: AFq9FYIsNASnJF55AaxHb52t3OC7kR1suhgS3gS9yeayKMbjcx89AIXj
	l33+q/Mbx22995GPG0F3q9pVHjGOoLFJDe+8/QFyJr0IZMObHTnxxIzAaOjzEcwuRw==
X-Gm-Gg: AYBFou3eeYVPs0bWqZzZfrt+tnf2FM1bWSZlbFhHMLhJXq9Nv9JAcdipbAUeXkk4EyG
	THZfg8/U5ku8spGWllTQnfKv7p2od5zZXsGUqqktQFnV/XATd1jM3HuGFVQJq5JHN1hTT7zhajM
	Dsf7fBNTiIJCcbe2Fs/soQHMpVckeODa4HOoK8OcJNqFuQtIpEoVfWshnVQFUCUghdGRDcyJt3t
	XvcOsBt0NctmRX8GT90WTU6bWEdjWnOr86lbMi/Kjfy13SxGNAl2IdKXkG66I/h2I1foAfVcOHo
	ZDSXYIKx3ME9bWGhkxsGmi89bKUtMaemJYJcuAlgKicCEqL/mooAydZecAH7N6yqs9pAI7o1OhE
	wKdsTFhstZ0samD1jAml/DEN/YU+GR7nyXclAlDDZEo5UXBmeYrGxX03aGvubWiJciDxLYX70/P
	y16k2YoWA9IwD24fQlAHKd0gyslskN8aMYo+FMa6LvfukFAqyo2BvaSt8DDlQacWzHfiVKuJ1pV
	wX3rKP8cm2xLsXJeXBbFMU89PDU4dU2+n88jCMfZKJOs97lleiMWTj40lYHEXxN8JGo6rRgMog0
	iQrzWLhfgEYUlvqNvWAmm52cIN7Nq9e/jcoKPYFGVBZE
X-Received: by 2002:a05:690c:4028:b0:8a5:af04:fb8d with SMTP id 00721157ae682-8ae94cf3876mr10451627b3.59.1791061705879;
        Sat, 03 Oct 2026 14:08:25 -0700 (PDT)
Received: from 1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.ip6.arpa ([2600:1700:4577:1050:550f:9551:5468:60f1])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8af0d179d3bsm743537b3.40.2026.10.03.14.08.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Oct 2026 14:08:24 -0700 (PDT)
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Date: Sat, 03 Oct 2026 14:07:55 -0700
Subject: [RFC PATCH v3 2/9] mm/damon/core: replace the access report buffer
 with per-context rings
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261003-damon-perf-rfc-v3-send-2026-10-03-v3-2-0f00417b41bc@gmail.com>
References: <20261003-damon-perf-rfc-v3-send-2026-10-03-v3-0-0f00417b41bc@gmail.com>
In-Reply-To: <20261003-damon-perf-rfc-v3-send-2026-10-03-v3-0-0f00417b41bc@gmail.com>
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
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5804C100007
X-Stat-Signature: 1hw7hhfr9ym9s5oofbp38nfdcqcxriqf
X-Rspam-User: 
X-HE-Tag: 1791061707-21013
X-HE-Meta: U2FsdGVkX19qflDnSjT59SlVYEj682EoKEdLgmZaEtz2PeB61QXaG5qNwCm63lsUvfgLvNsIc+Di43t0PAXRBoZTZHhV7vCIoqq4HldzMeJZfySkb4nrj2Fu2eJUAD71VZk/sXEp+9iixPne17Vce9m7n3za870ZXgM2BlHXl9I3f1GF6Mv1f32FG4UsthxeBOIBamAQ0YmtqPt8VctOsNb2Pbv4Y73j/9DxsIrKjZ1PLh1UhgCe5SlzJoBIUgshuMAkxWO9wWcYIdm0cwlrg76f95MM0VA92IRDVQf1X3q3oPukFlCWxIHtCi9qo4kTDt6OsaqTxE2UqTxD92XY7WMLB8onuyVOp1cA0TDLz4demeN9iQ7Zn7A7+orLMLWy4Ufh8mhlCscC9cwsIKu0/HJCIVqnfv+w19ubL2mxDf2q8CEwwArgZYW+EkBJIKe6R6JbtRveM92lu+q2QUKzegTKKbtqKI5/shhK1C6HvT3xWCafM9jUMgd3ZbvyaZHur8MyJtKhshGMZlZP+6DimBmv1wjMvZTXmTupGIaKI867tuYfNNlj9PR1ZMPlKxN9fMyKBXXAc2VdI5q5XABjgVe8ueD/Lk+GUG7BlMDz45Pfg9FzEEZcrD8GDorPh/7mBWGbX6brndWmB/BFx+BkUTtUGuouyZu4iD12HzrQTt1AOKmV3xbYUCb6hTiTOnb3oq/6uE/4b+Yyt3YRYLJ/3RcNZ1fXo8R883JEAx5aARZbas7u72hgathcYn/DBHDEKF8M4VJcCO4dg2tglitB04PCV+hsJy4/gurec/mumX2lULBX9dpz5iH4pkBivuPNZIfcqfTyyyc0bHOKdeoACte/6oNdnQI/brVCC88+nNulqXlt/AQ6lkPJcibvBl9QYeXn189OuZYjyHuQSbnouM4WoEJ9kC5cTD+UJPt3s0OHO8zOyCBe15DncZ4HJkGia2cNSOFSHZAL96rTKmv
 +fA0F0uc
 9crgDZ+pA2g6JYk7Lbb53o6EmxwIN5bcqQ9HK4wQmPIpmmQPKeY7KHL336sgfSjfOefwRqIyllaa4LdUTocROe1TZn1hCpSdOI3mvQkbdiCmRmstN51ley3uAynlGFUZEOWxM5W9swOrhKDV1UN/I1j02yPKGTMKqF/dUJ7EgBCLesO7APxbh27zBCaX843Nzzlt53vPXZ2NNp4BAz9SOc9WdBI70riX8PZGh0lhwwfDFEba8QgAfNiuSUnOyn5x8NjAuv6U7O5pLvxXtVGu5mcGfi5hiuJJeUm83gCmHl85GZ2aptzt3wwseF5fxqoOJYAG2XLtJxXjbNn469Dy0glsiO7eXCArTsKgzGo7oGHXNco+Gh3s7aFz1TTe6JPP2PNZ4OwjiwVxqjOO/hGjS6JDHo3LrVQPyMeouEtoqvUIOkmaDitHDlvh1xHfTk4u2kb2tF6kLdrj4nfPNY9c4ypYf2aoraFA8ONfkuxQVSdNdybZHY3WSOnGyLwIFB7Uhjrgs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_report_access() queues reports into the global damon_access_reports[]
buffer under a mutex, and kdamond applies them from there.  A perf-event
overflow handler runs in NMI context and cannot take that mutex, and since
the previous patch the buffer has no other producer.

Replace the buffer with a per-context, per-CPU SPSC report ring
(ctx->perf_rings) that an NMI-context producer can publish into, and a
kdamond drain that credits regions from each ring's pending reports.

NMI safety: the producer uses a busy counter to drop re-entrant reports on
the same CPU, publishes with smp_wmb() before advancing the head, and sets
a pending-CPU bitmask with smp_mb__before_atomic() so the consumer catches
any report published between the bit-clear and the READ_ONCE(head).  The
ring is allocated before the first PMU arm and freed after the last PMU
release in damon_destroy_ctx(), so no in-flight NMI can reach freed
storage.

The drain matches each report to a region by binary search over a
per-target region snapshot built in ar.start order, the region-list
invariant damon_credit_report_bsearch() relies on.  A credited region's
access rate is incremented once per drained sample rather than once per
aggregation tick, so a region that drains several samples in one tick
reflects that instead of being clamped to the signal a lone sample gives.

While here, widen probe_hits[] and last_probe_hits[] in struct
damon_region, and the damon_probe_hits_mvsum() return type, from unsigned
char to unsigned int.  An unsigned char wraps at 256; a PEBS event at
5000 Hz overflows it within a single 1-second aggregation window.

Signed-off-by: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
---
 include/linux/damon.h | 110 ++++++++-
 mm/damon/core.c       | 625 +++++++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 642 insertions(+), 93 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 10582f669673..217299aa6c03 100644
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
@@ -66,14 +76,14 @@ struct damon_region {
 	struct damon_addr_range ar;
 	unsigned long sampling_addr;
 	unsigned int nr_accesses;
-	unsigned char probe_hits[DAMON_MAX_PROBES];
+	unsigned int  probe_hits[DAMON_MAX_PROBES];
 	unsigned int age;
 /* private: internal use only. */
 	/* List head for siblings. */
 	struct list_head list;
 	/* for age calculation. */
 	unsigned int last_nr_accesses;
-	unsigned char last_probe_hits[DAMON_MAX_PROBES];
+	unsigned int  last_probe_hits[DAMON_MAX_PROBES];
 	bool access_reported;
 };
 
@@ -110,7 +120,15 @@ struct damon_target {
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
@@ -122,11 +140,54 @@ struct damon_access_report {
 	unsigned long size;
 	unsigned int cpu;
 	pid_t tid;
+	pid_t tgid;
 	bool is_write;
+	int probe_idx;
+	/*
+	 * Owning context for a report (set by the perf-event overflow handler
+	 * so the producer enqueues into that ctx's own perf ring).  NULL for a
+	 * report with no owning context (probe_idx == DAMON_PROBE_IDX_NONE);
+	 * such a report has no ring to feed and is dropped by
+	 * damon_report_access().
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
@@ -1091,6 +1153,32 @@ struct damon_ctx {
 
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
+	 * Per-context perf-event report ring.  A perf overflow handler is
+	 * armed by -- and carries a pointer to -- its owning ctx
+	 * (damon_access_report.ctx), so its reports route to this per-ctx
+	 * ring.  This gives full per-context isolation (two perf-driven ctxs
+	 * never share a ring) and needs no cross-ctx ring owner guard.
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
@@ -1209,11 +1297,12 @@ void damon_destroy_filter(struct damon_filter *f);
 
 struct damon_probe *damon_new_probe(void);
 void damon_add_probe(struct damon_ctx *ctx, struct damon_probe *probe);
+bool damon_has_event_driven_probes(struct damon_ctx *ctx);
 
 struct damon_region *damon_new_region(unsigned long start, unsigned long end);
 unsigned int damon_nr_accesses_mvsum(struct damon_region *r,
 		struct damon_ctx *ctx);
-unsigned char damon_probe_hits_mvsum(int probe_idx, struct damon_region *r,
+unsigned int damon_probe_hits_mvsum(int probe_idx, struct damon_region *r,
 		struct damon_ctx *ctx);
 unsigned int damon_probe_hits_wsum(struct damon_region *r, bool last, bool mv,
 		struct damon_ctx *ctx);
@@ -1298,23 +1387,30 @@ int damon_kdamond_pid(struct damon_ctx *ctx);
 int damon_call(struct damon_ctx *ctx, struct damon_call_control *control);
 int damos_walk(struct damon_ctx *ctx, struct damos_walk_control *control);
 
-void damon_report_access(struct damon_access_report *report);
+bool damon_report_access(struct damon_access_report *report);
+int damon_ctx_alloc_perf_ring(struct damon_ctx *ctx);
 
 int damon_set_region_system_rams_default(struct damon_target *t,
 				unsigned long *start, unsigned long *end,
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
 
 #endif	/* CONFIG_DAMON */
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 886e068e7844..4fd1db12bc49 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -22,8 +22,87 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/damon.h>
 
-#define DAMON_ACCESS_REPORTS_CAP 1000
+/*
+ * Reports are fed to DAMON via a PER-CONTEXT per-CPU SPSC ring
+ * (ctx->perf_rings).  The overflow handler carries the owning ctx, so each
+ * perf-driven context drains only its own ring -- no global ring and no
+ * cross-context owner needed.  See struct damon_ctx.
+ *
+ * Each context's ring has its own per-CPU storage, per-CPU busy flag,
+ * pending cpumask, and overflow counter.
+ */
+/*
+ * Report drops are counted per reason.  A ring-full drop means the consumer
+ * did not keep up with the producer; a busy-guard drop means an NMI nested on
+ * top of a same-CPU producer.
+ */
+static DEFINE_PER_CPU(unsigned long, damon_report_ring_full_perf);
+static DEFINE_PER_CPU(unsigned long, damon_report_busy_drop_perf);
+static DEFINE_PER_CPU(unsigned long, damon_samples_drained);
+static DEFINE_PER_CPU(unsigned long, damon_samples_stale_drained);
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
+EXPORT_SYMBOL_GPL(damon_get_report_ring_full);
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
+
+	for_each_possible_cpu(cpu)
+		sum += per_cpu(damon_samples_no_region, cpu);
+	return sum;
+}
+EXPORT_SYMBOL_GPL(damon_get_samples_no_region);
 static DEFINE_MUTEX(damon_lock);
 static int nr_running_ctxs;
 static bool running_exclusive_ctxs;
@@ -33,11 +112,6 @@ static struct damon_operations damon_registered_ops[NR_DAMON_OPS];
 
 static struct kmem_cache *damon_region_cache __ro_after_init;
 
-static DEFINE_MUTEX(damon_access_reports_lock);
-static struct damon_access_report damon_access_reports[
-	DAMON_ACCESS_REPORTS_CAP];
-static int damon_access_reports_len;
-
 /* Should be called under damon_ops_lock with id smaller than NR_DAMON_OPS */
 static bool __damon_is_registered_ops(enum damon_ops_id id)
 {
@@ -288,6 +362,32 @@ static bool damon_has_probe_weights(struct damon_ctx *c)
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
+/* Does @ctx drive (and thus need exclusive drain of) the perf report ring? */
+static bool damon_drains_ring_perf(struct damon_ctx *ctx)
+{
+	return damon_has_event_driven_probes(ctx);
+}
+
 /*
  * damon_mvsum() - Returns pseudo moving sum value for a time window.
  * @current_nr:		The value of the current aggregation window.
@@ -353,7 +453,7 @@ unsigned int damon_nr_accesses_mvsum(struct damon_region *r,
 			left_window_bp);
 }
 
-unsigned char damon_probe_hits_mvsum(int probe_idx, struct damon_region *r,
+unsigned int damon_probe_hits_mvsum(int probe_idx, struct damon_region *r,
 		struct damon_ctx *ctx)
 {
 	unsigned long sample_interval, aggr_interval;
@@ -979,7 +1079,6 @@ static struct damon_sample_filter *damon_last_sample_filter_or_null(
 	return list_last_entry_or_null(&ctrl->sample_filters,
 			struct damon_sample_filter, list);
 }
-
 struct damon_ctx *damon_new_ctx(void)
 {
 	struct damon_ctx *ctx;
@@ -1025,6 +1124,40 @@ struct damon_ctx *damon_new_ctx(void)
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
@@ -1050,6 +1183,16 @@ void damon_destroy_ctx(struct damon_ctx *ctx)
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
 
@@ -2519,30 +2662,107 @@ int damos_walk(struct damon_ctx *ctx, struct damos_walk_control *control)
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
+ *
+ * A backend whose PMU writes a record stream into a memory buffer instead of
+ * raising a per-sample interrupt, or one reading a device counter table, must
+ * therefore decode CPU N's buffer on CPU N -- for example by queueing per-CPU
+ * work with queue_work_on() -- rather than calling this function in a loop
+ * from one thread.  A single-thread loop puts every report in that thread's
+ * ring, which caps machine-wide capacity at DAMON_REPORT_RING_SIZE - 1
+ * reports per drain regardless of the number of producing CPUs, and does not
+ * satisfy the single-producer invariant if the thread can migrate.
+ *
+ * Context: any (NMI-safe).  An NMI nesting on top of a process-context
+ * producer on the same CPU would otherwise stomp the same entries[head]
+ * slot; the busy guard detects and drops in that case.
  *
- * Context: May sleep.
+ * If the ring is full, the sample is dropped and the per-CPU ring-full
+ * counter incremented; a busy-guard drop increments the busy-drop counter.
  *
- * NOTE: we may be able to implement this as a lockless queue, and allow any
- * context.  As the overhead is unknown, and region-based DAMON logics would
- * guarantee the reports would be not made that frequently, let's start with
- * this simple implementation.
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
+	 * Only perf-event reports (probe_idx >= 1) have a ring to feed: the
+	 * global page_fault ring this dispatch also fed has been removed.
+	 * A probe_idx == DAMON_PROBE_IDX_NONE report has nowhere to go and is
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
+	 * and that ctx must have an allocated per-ctx perf ring.  If either is
+	 * missing (e.g. an overflow racing teardown after the ring was freed, or
+	 * a report raised before the ring was allocated), drop the sample rather
+	 * than touch NULL/freed storage.
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
+	if (next == READ_ONCE(ring->tail)) {
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
+EXPORT_SYMBOL_GPL(damon_report_access);
 
 /*
  * Reset the aggregated monitoring results ('nr_accesses' of each region).
@@ -4202,6 +4422,24 @@ static void kdamond_init_ctx(struct damon_ctx *ctx)
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
@@ -4229,6 +4467,11 @@ static bool damon_sample_filter_matching(struct damon_access_report *report,
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
@@ -4245,73 +4488,276 @@ static bool damon_sample_filter_out(struct damon_access_report *report,
 	return !filter->allow;
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
+		damon_for_each_region(r, t)
+			ctx->drain_snapshot.region_buf[ri++] = r;
+		ti++;
+	}
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
+	 * pidx is always >= 1 here: __kdamond_drain_ring rejects
+	 * DAMON_PROBE_IDX_NONE (0) entries before calling this.  Ring
+	 * probe_idx is 1-based, but probe_hits[] storage is 0-based to match
+	 * all readers (wsum, mvsum, update, aggregate reset, merge).
+	 * Convert here: probe_hits[pidx - 1].
+	 */
+	r->probe_hits[pidx - 1]++;
+	damon_update_region_access_rate(r, true);
+	r->access_reported = true;
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
+ * Each context's per-CPU perf ring (ctx->perf_rings) is drained by this
+ * loop, parameterised only by which ring + pending mask to consume.  The
+ * bsearch / straddle-reject / tid-filter / stale-window / sample-filter /
+ * probe_hits-crediting logic is shared by every ring this loop drains.
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
+			 * Every entry in this ring is a perf-event report
+			 * (probe_idx >= 1); damon_report_access() drops any
+			 * DAMON_PROBE_IDX_NONE report before it reaches a ring.
+			 * Reject only out-of-range indices (>= DAMON_MAX_PROBES)
+			 * and, defensively, any non-positive value.
+			 */
+			if (pidx <= 0 || pidx >= DAMON_MAX_PROBES)
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
+ * kdamond_check_reported_accesses - drain the per-ctx perf report ring this
+ * ctx feeds.  Called from kdamond main loop after each sampling interval.
+ *
+ * Each context's per-CPU perf ring (ctx->perf_rings) holds event-driven
+ * probe (probe_idx >= 1) reports.  A ctx drains it when it has event-driven
+ * probes registered.
+ *
+ * The per-target sorted region snapshot is built once and shared across the
+ * ring drain (it is ring-agnostic).
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
+	if (damon_drains_ring_perf(ctx))
+		__kdamond_drain_ring(ctx, tbl, ctx->perf_rings,
+				&ctx->perf_pending);
 }
 
 /*
@@ -4360,7 +4806,10 @@ static int kdamond_fn(void *data)
 
 		do_prep = ctx->ops.prep_probes && damon_has_prep(ctx);
 
-		if (!access_check_disabled && ctx->ops.prepare_access_checks)
+		/* Page-fault sampling installs its markers from this callback. */
+		if ((!access_check_disabled ||
+				ctx->sample_control.primitives_enabled.page_fault) &&
+				ctx->ops.prepare_access_checks)
 			ctx->ops.prepare_access_checks(ctx);
 		if (do_prep)
 			ctx->ops.prep_probes(ctx, access_check_disabled);
@@ -4368,14 +4817,18 @@ static int kdamond_fn(void *data)
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
+		/* Page-fault sampling reports only the accessed regions. */
+		if (ctx->sample_control.primitives_enabled.page_fault)
+			max_merge_score = kdamond_apply_zero_access_report(ctx);
+		else if (!access_check_disabled && ctx->ops.check_accesses)
+			max_merge_score = ctx->ops.check_accesses(ctx);
 
 		if (ctx->ops.apply_probes) {
 			if (time_after_eq(ctx->passed_sample_intervals,

-- 
Git-157)


