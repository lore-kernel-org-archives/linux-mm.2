Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC006CA5FF0
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 08:47:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50C3C6B0096; Mon,  5 Oct 2026 04:47:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BD656B0098; Mon,  5 Oct 2026 04:47:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AC096B0099; Mon,  5 Oct 2026 04:47:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 09E9E6B0096
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 04:47:02 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 908594018E
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 08:47:01 +0000 (UTC)
X-FDA: 85287942642.03.71B6B2E
Received: from mail-yx2-f8.google.com (mail-yx2-f8.google.com [74.125.224.136])
	by imf10.hostedemail.com (Postfix) with ESMTP id B1007C0002
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 08:46:59 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KQNFroFk;
	spf=pass (imf10.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.224.136 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791190019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OXX4W2cyx9uTdoNbcaBB9pEjRt8rkJZ+iUDgnhch5VM=;
	b=2v/piFBziMJbryxTZp5qQ0Dk7+/GxuBMMXu9fkWP+4pnwZsYBzWsg1ghhOq+v/uxo9IgNJ
	zNFIwn98oXpqg9O5Zhg0r+mQJlNXzJU3pNef4PNGT5IsRHfbfgM/EOHWazpc6gQKtThO1Z
	SjqpS79Y90eeV0fM2Ia9UT0bOXq1S3c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791190019;
	b=OPLgTeHk9xU1bzugLXc1Vq3xzlzyvwM35T3jhIK/CpYMYYJfAaVT2ySv0B2rpqIlfDiEWn
	p4VAksdKWCYmbMeKqDd6+6e6g7HiS4JWF4q9wrauI0mI4my6T2StruUfSLhVrLW6tzCONw
	vbhPAc8S46fxIaf3Bell83IWltNSXuI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KQNFroFk;
	spf=pass (imf10.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.224.136 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yx2-f8.google.com with SMTP id 956f58d0204a3-66cde2e181cso516413d50.0
        for <linux-mm@kvack.org>; Mon, 05 Oct 2026 01:46:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791190019; x=1791794819; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OXX4W2cyx9uTdoNbcaBB9pEjRt8rkJZ+iUDgnhch5VM=;
        b=KQNFroFkdhXo53S5ZiXMehdy00Zq6Vyx2jTDXFpP2aUSetx0OgFlWPlABd+fBdvU9y
         44ZeTrB/KQNx9wxdaqZ0uEIfDAf08Fk9PDMr/Rj519GXdnjXQXk1Mp+oeu4schisXH7C
         ZS4iW9LCcgV8oOaPiGLTOIQZibCTGghFwOouqbjLs6zTpRH3pjTUnXlAoePH3HNXDVpo
         6+wDXzQ6wKPgxDGn8dKX0yJZkIVzZisXS+M5FJi5wg0tRA1EQUVIALFqNGIaJhIt2IQ2
         5uSyaMQENJv9yt2vlZtU2BGJLf7vlTuSlGSrITrx9Kpo+55TQ/T3DEARa/4l9azwDoJd
         NMXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791190019; x=1791794819;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OXX4W2cyx9uTdoNbcaBB9pEjRt8rkJZ+iUDgnhch5VM=;
        b=xCUyhrvZWxZDytwNPLczu66uk5/i9ee5+0/DUtK3GEhWbVS+lxKMDnzO0GdBd+Vrnw
         ZotE3lAcS7Oq1xQm39ue7Z7KWsJjQb0WXpa1b8iIaHjyk5NE82yIfKB4tk2l8cTuTGXM
         GdnfMh0Izue3l11LQYzskYPZ1jk2YnlVfiTxou1MCuNLC1O4KHEmNhU9i/XvUVYuXlQR
         YPD5ReLeCk2shAlGcr7hxHC/m4+43oeBjCrX9wkSrid30Ez5CYvF8ao0ZHdzIz059uKx
         3Ef40WG/dwaMbqCgITjRfaKHQ5HK0OF8BNgVnXu3xKG+FycoWs/p6v6Mkn1YV9SZiOql
         mlAw==
X-Forwarded-Encrypted: i=1; AKwUvBytdra1VoJxuVLMiJp4zRMqdZ90zm0qAlHlBAX4hXya4dH1teufmbZteeqFga/3wZx3Lzf+QsyfzQ==@kvack.org
X-Gm-Message-State: AFq9FYIfRrohZ4m/G4IEv5QQ7RWXpxm1w9zArusWScm+HHhl8BacN0WA
	S7TGyeWEYZGNAlf9dGIUsV3rK3qIv+kAOnLEvvblMMpvfteCQ/pfNts=
X-Gm-Gg: AYBFou0IbWxoOHgtzXALe0upNzcnmFUIdEg7MERGiUdAOGh2ZTaKcDaZCLui9fLJoxO
	G1pvhzYAIB98qGZ1aGfuIlAWQe6W8s85p77Trm6PyrOtdnv00frQ1sD4nsGNdF1enoj99jNjq3B
	Q8iynvYkTNDIe4EXB09wwWYGkgAiJWCoejfn5Yc2XM7PY+1rTFOW7uhrgYIm3fk6ddnITdQgIp/
	fRmUtHHUIXJ6xgtI7IS0L/290hm+ArDLCaIP/R5s9UMDYqCyfa+Ca31Au1XJw+epCtn81vKejl5
	Qm9qQPymZqAnfSL/EvHB2utXG39hMvNJCCTdQSQcIpXTZ01syIeFiaayFqIaZnA5qGpJRNEQXAB
	DTd9L65Ac/qnperAHXOb2FtTVkif5CRsyo6svYrQiaQal/Lu0aVHhW1THGhZ3jVNchY6my4bB1y
	0d0rDane1lIRXcxzCWhl/9eaz4G34bjJ14lUPgOk/psarjQebc+T5nRaZoImjEy1Ic4dqzSvqpD
	KXZ8aNxQkAeKliEYZtmrfmIWbWkYyzWjG3LezEHOPewT4NZBCLAzo2iGWjT9IK28smj3EEgN9Sv
	rhw2rPJZVocGqitG6gL7PqS+CSrBbaG6jE38DP6J4zZV
X-Received: by 2002:a05:690e:12ca:b0:677:c63c:ed3f with SMTP id 956f58d0204a3-677c63cf4e8mr2740080d50.69.1791190018703;
        Mon, 05 Oct 2026 01:46:58 -0700 (PDT)
Received: from 1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.ip6.arpa ([2600:1700:4577:1050:1149:2fcd:c86b:8747])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-677c1b9c895sm2346306d50.13.2026.10.05.01.46.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2026 01:46:56 -0700 (PDT)
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Date: Mon, 05 Oct 2026 01:46:47 -0700
Subject: [RFC PATCH v4 3/9] mm/damon: add perf-event overflow handler
 feeding the report ring
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261005-damon-perf-rfc-v3-send-2026-10-03-v4-3-b03452e137f3@gmail.com>
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
X-Rspam-User: 
X-Stat-Signature: d1sd5xfetmo8xhb3p9ayfam9ez7kwo1q
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B1007C0002
X-HE-Tag: 1791190019-885519
X-HE-Meta: U2FsdGVkX1+krCu3S4x8wcX0U7eb8TXefegvAdP68KySQs1ql60AgACMdKLpexYOLPbKex77hEzK2BZkEwdQxw98IxTtWQAO0uJbCwszgT6cNhyeklElKuryIUAPdWE+WmBstun8epz7+ujLdyug172yiCrdNR/S6cnXUvbzAUW5hbii61m7XTvvfzpW9IlgTKqkYhjzrNrCBKMAieboWXkZktC5l2iBbbc6EUcE2owb8URyyD3kXHw+Rf/7FDXGj9X2OPLyikxBTGmR3Aw1OcmSzRQgSVydne+zAfycr3Tj0Ulzg1Aw10BT0TY5OvhG9bQRVLpFFilVLG9lXWKBADTJkPRcPmd+lZl22GY2JVhtx3wBrJ0vRJQsOemxAlYnX3U7WBKlBVaCHKioT7aBY/CtX5KmncHn/3i5u6+uzenwwxtdq2erGiU0DwUm1RCpnQDljUnp5LwZp1FL2MkyYFlsdRvmTkFlguu6Y5hDJvPAhcbfHTfA2LUbQ+25cPiEiGO+PbUF95/ZG+2BmkUkEyGNkOn0aWGvWKVS/2RzSZGbTlf630RySzwbNR6NMXbK4iiN8YOWeN6auJpKUzuz0kdROlhgN0qY3uMsSvH12Cx2k8iKrbU0YFs1puKfcJT7W4iHQKj2VmLyT8RRqWP/pYE0Z0jBJZdVxuPd3ufMYYJg88yTLqX4Mr+4QSm2h80pTSFqkSpA61CgCjodmezHkDWM268WTXqg+jS7N0r/7z9n2b0t7CWjxpj73fIw2ZHVgUM1QdqBKicp64fOI0vhvwe7ktXDRJxgU2Lwhv/Mj9Hot1mDG6yx0ic0RENFwhxJBCZMYPQtxDZUqRr7ODmpFzsro6BbWUdCMn0I6hvUZbCjO9cyiXVcxSagriTCkjes30pEjN9BGeAwKruqqZiJafv2b9lDaL7BWISjjUHdviBS6ODkOAeXLytzwcNUkIh0JhGLNTnfawxpt/3hMG/
 FXLnUa5H
 5Q42UfLeWXH4h4qk566PKOEyrNKWXv6Yy3V0ghV32rRYxu7rcH7HFwTIOQTxWNsCHit7fxaUNWnV6nFE2ukTDgKMUdoucug1dkygAttv5zlhsUdH/28uydJxvEtTmvLcMtliKgrNP4w6qH6X4XP6a+/y/qMwsWCIru7GW8z9N09qtZVYHSjVQI5cujcky8pCs5Xk1FQn1zvmFzuKc6tQlTCiaYlk4HXvOBsAx45u6Ze4AFWH4pRxFGV8zHR5L/MxFNThWOqE9RynCMCCpi31WFE2m2LRost1vrquuGFOJJCFFvZkJ910VX88NrjApb9y9TY2R/riXDIp0lOoSIxqgpoD5+uAk9c79LG3g/w8Q9bAM/DaGErQc+dQOMVO7Rtz6fB4rn9Ka1FAmkNnCmvbmA/yh0d+IqC7M7Jf+pGKHXKodBGdiVtI+OyeOMmifarnSLtv2RG/+MPCs8ZaRPjvWjEzS9pIGMzpRLvNU9bDgtLUT/g1xxIOmAQLggsGezZOvTmV8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add mm/damon/perf_source.c, an ops-agnostic perf-event source that turns
PMU overflow samples into DAMON access reports.  The overflow handler runs
in NMI context and reports through damon_report_access(), so it works with
either paddr or vaddr ops.

Each armed event carries its owning context, set when the probe is set up,
and the handler routes every report to that context's perf ring.  Setup
allocates the ring before arming the first counter, so the handler always
finds one.  Teardown clears the event's context with a release store
before releasing the counters, and the handler reads it with a matching
acquire load, so an overflow racing teardown drops its sample instead of
reporting into a context that is going away.

The handler sets whichever address fields the PMU provides: paddr when
PERF_SAMPLE_PHYS_ADDR is set, vaddr when PERF_SAMPLE_ADDR is set, plus the
CPU it runs on.  Both addresses are page aligned, matching the PAGE_SIZE
report size, so a sample that lands in the last page of a region is not
rejected by the drain as straddling the region end.  The drain matches on
whichever address the context's targets use.  The handler reports both
the thread id and the thread group id, because a VA-only PMU samples
whichever thread of a process happened to access memory while the drain
matches a target created for that process.  The thread group id is the
global one, which is what the drain compares the target's pid with.

Per-CPU perf events are armed and released through cpuhp callbacks, so a
CPU coming online while a probe is armed gets a counter and a CPU going
offline releases its own.  A CPU on which the counter cannot be created
is left unsampled with a warning, since failing the online callback
would block the CPU from coming online.

A probe with event_driven set has its hits credited through the
report-ring drain rather than the apply_probes vtable.  Both ops sets
honour that flag in their probe vtables: an event-driven probe has no
software prep action, and is skipped in the apply_probes loop, so the
drain is the only thing that credits its probe_hits[].  When no probe of
the context is sampled by DAMON itself, the apply_probes vtable also
skips the per-region folio lookup or page table walk.

damon_perf_probe_setup() computes probe_idx by walking ctx->probes,
assigning 1-based indices because 0 is the zero-init sentinel
DAMON_PROBE_IDX_NONE, and the overflow handler warns once if it sees 0.

A refcounted per-PMU owner tracks which context owns each PMU type: a
second context claiming the same type gets -EBUSY, and ownership is
released when the last probe for that type is torn down.

Co-developed-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
---
 include/linux/damon.h  |   1 +
 mm/damon/Kconfig       |  19 +++
 mm/damon/Makefile      |   1 +
 mm/damon/core.c        |  18 +++
 mm/damon/paddr.c       |  15 +-
 mm/damon/perf_source.c | 378 +++++++++++++++++++++++++++++++++++++++++++++++++
 mm/damon/perf_source.h |  25 ++++
 mm/damon/vaddr.c       |  15 +-
 8 files changed, 469 insertions(+), 3 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index e6d2e9d0936e..7c5a416e1eff 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -1297,6 +1297,7 @@ void damon_destroy_filter(struct damon_filter *f);
 struct damon_probe *damon_new_probe(void);
 void damon_add_probe(struct damon_ctx *ctx, struct damon_probe *probe);
 bool damon_has_event_driven_probes(struct damon_ctx *ctx);
+bool damon_has_sampling_probes(struct damon_ctx *ctx);
 
 struct damon_region *damon_new_region(unsigned long start, unsigned long end);
 unsigned int damon_nr_accesses_mvsum(struct damon_region *r,
diff --git a/mm/damon/Kconfig b/mm/damon/Kconfig
index c7b6f3125e79..c78e819372ab 100644
--- a/mm/damon/Kconfig
+++ b/mm/damon/Kconfig
@@ -64,6 +64,25 @@ config DAMON_PADDR
 	  This builds the default data access monitoring operations for DAMON
 	  that works for the physical address space.
 
+config DAMON_PERF_SOURCE
+	bool "perf-event source for DAMON probes"
+	depends on DAMON && PERF_EVENTS
+	help
+	  Provides a PMU-agnostic perf-event overflow handler that feeds
+	  physical-address and virtual-address access reports into DAMON via
+	  damon_report_access().  Needed for DAMON probes backed by an
+	  address-sampling PMU.
+
+	  The overflow handler is NMI-safe: it writes to a per-CPU SPSC
+	  ring rather than taking any lock. The PMU is selected at probe
+	  creation time via perf_event_attr (e.g. AMD IBS Op, Intel PEBS).
+
+	  A given PMU type may be driven by at most one DAMON context at a
+	  time; damon_perf_probe_setup() returns -EBUSY if another context
+	  already owns that PMU type.  Distinct contexts may each drive
+	  different PMUs concurrently, each draining its own per-context
+	  report ring.
+
 config DAMON_VADDR_KUNIT_TEST
 	bool "Test for DAMON operations" if !KUNIT_ALL_TESTS
 	depends on DAMON_VADDR && KUNIT=y
diff --git a/mm/damon/Makefile b/mm/damon/Makefile
index 22494754f41e..1abf6f2a5133 100644
--- a/mm/damon/Makefile
+++ b/mm/damon/Makefile
@@ -9,3 +9,4 @@ obj-$(CONFIG_DAMON_RECLAIM)	+= modules-common.o reclaim.o
 obj-$(CONFIG_DAMON_LRU_SORT)	+= modules-common.o lru_sort.o
 obj-$(CONFIG_DAMON_STAT)	+= modules-common.o stat.o
 obj-$(CONFIG_DAMON_ACMA)	+= modules-common.o acma.o
+obj-$(CONFIG_DAMON_PERF_SOURCE)	+= perf_source.o
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 8f78700afedd..a15dc7e9125a 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -364,6 +364,24 @@ bool damon_has_event_driven_probes(struct damon_ctx *ctx)
 	return false;
 }
 
+/**
+ * damon_has_sampling_probes() - return true if @ctx has a probe that DAMON
+ * samples itself, that is, one that is not event-driven.
+ * @ctx: the DAMON context whose probes are inspected.
+ *
+ * Return: true if @ctx has a probe that is not event-driven.
+ */
+bool damon_has_sampling_probes(struct damon_ctx *ctx)
+{
+	struct damon_probe *p;
+
+	damon_for_each_probe(p, ctx) {
+		if (!p->event_driven)
+			return true;
+	}
+	return false;
+}
+
 /* Does @ctx drain a perf report ring? */
 static bool damon_drains_ring_perf(struct damon_ctx *ctx)
 {
diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 65a5b3269d1d..baaa3af917be 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -118,6 +118,10 @@ static void damon_pa_prep_probes_region(struct damon_region *r,
 {
 	struct damon_prep *p;
 
+	/* event-driven probes have no software prep */
+	if (probe->event_driven)
+		return;
+
 	damon_for_each_prep(p, probe) {
 		switch (p->action) {
 		case DAMON_PREP_SET_PGIDLE:
@@ -193,6 +197,7 @@ static unsigned int damon_pa_apply_probes(struct damon_ctx *ctx,
 	struct damon_region *r;
 	struct damon_probe *p;
 	unsigned int max_wsum = 0;
+	bool sampling = damon_has_sampling_probes(ctx);
 
 	damon_for_each_target(t, ctx) {
 		damon_for_each_region(r, t) {
@@ -203,16 +208,24 @@ static unsigned int damon_pa_apply_probes(struct damon_ctx *ctx,
 			if (set_samples)
 				r->sampling_addr = damon_rand(ctx, r->ar.start,
 						r->ar.end);
+			if (!sampling)
+				goto wsum;
 			pa = damon_pa_phys_addr(r->sampling_addr,
 					ctx->addr_unit);
 			folio = damon_get_folio(PHYS_PFN(pa));
 			damon_for_each_probe(p, ctx) {
-				if (damon_pa_filter_pass(folio, p))
+				/*
+				 * Event-driven probes are credited by the ring
+				 * drain; only sampling-based probes are here.
+				 */
+				if (!p->event_driven &&
+				    damon_pa_filter_pass(folio, p))
 					r->probe_hits[i]++;
 				i++;
 			}
 			if (folio)
 				folio_put(folio);
+wsum:
 			if (return_max_wsum)
 				max_wsum = max(damon_probe_hits_wsum(r, false,
 							false, ctx), max_wsum);
diff --git a/mm/damon/perf_source.c b/mm/damon/perf_source.c
new file mode 100644
index 000000000000..65bbfe850e70
--- /dev/null
+++ b/mm/damon/perf_source.c
@@ -0,0 +1,378 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * DAMON perf-event source
+ *
+ * Provides a PMU-agnostic NMI-safe overflow handler that feeds physical- and
+ * virtual-address access reports into DAMON via damon_report_access().
+ * The PMU is selected at probe creation time via perf_event_attr.
+ */
+
+#include <linux/cpuhotplug.h>
+#include <linux/damon.h>
+#include <linux/init.h>
+#include <linux/perf_event.h>
+#include <linux/slab.h>
+#include "perf_source.h"
+
+/* PMU event attribute for perf-event probe configuration */
+struct damon_perf_event_attr {
+	u32 type;
+	u64 config;
+	u64 config1;
+	u64 config2;
+	bool sample_phys_addr;
+	bool sample_weight_struct;
+	bool exclude_kernel;
+	bool exclude_hv;
+	bool freq;
+	u64 sample_freq;
+	u64 sample_period;
+	u32 wakeup_events;
+	u32 precise_ip;
+};
+
+struct damon_perf_probe_event {
+	struct damon_perf_event_attr attr;
+	void *priv;		/* struct damon_perf_probe_state * */
+	struct hlist_node hlist_node;
+	int probe_idx;		/* index into probe_hits[]; set at registration */
+	struct damon_ctx *ctx;	/* owning ctx; NULLed at teardown */
+};
+
+struct damon_perf_probe_state {
+	struct perf_event * __percpu *event;
+};
+
+static void damon_perf_overflow(struct perf_event *perf_event,
+				struct perf_sample_data *data,
+				struct pt_regs *regs)
+{
+	struct damon_perf_probe_event *event =
+		perf_event->overflow_handler_context;
+	int probe_idx;
+	struct damon_ctx *ctx;
+	struct damon_access_report report = {
+		.size = PAGE_SIZE,
+		.cpu = smp_processor_id(),
+	};
+
+	/*
+	 * Teardown NULLs event->ctx (with a release barrier) before releasing
+	 * the per-CPU perf events, so an in-flight overflow racing the
+	 * disable/release observes the torn-down state and drops the sample
+	 * instead of reporting into a freed ctx.  Pairs with the
+	 * smp_store_release(&event->ctx, NULL) in damon_perf_probe_teardown().
+	 */
+	ctx = smp_load_acquire(&event->ctx);
+	if (!ctx)
+		return;
+	probe_idx = event->probe_idx;
+	report.probe_idx = probe_idx;
+	report.ctx = ctx;	/* route to this ctx's per-ctx perf ring */
+
+	/* probe_idx 0 is the zero-init sentinel; a valid index must be >= 1 */
+	if (WARN_ONCE(probe_idx == 0,
+		      "damon-perf: overflow handler called with probe_idx=0\n"))
+		return;
+
+	if (!data)
+		return;
+
+	/*
+	 * Populate whichever address fields the PMU provides; which ones it
+	 * provides depends on the PMU and on the sample_type requested.
+	 * Gate on sample_flags rather than testing for zero: the flag is
+	 * the authoritative indicator of field validity.
+	 */
+	if (data->sample_flags & PERF_SAMPLE_PHYS_ADDR)
+		report.paddr = data->phys_addr & PAGE_MASK;
+	if (data->sample_flags & PERF_SAMPLE_ADDR)
+		report.vaddr = data->addr & PAGE_MASK;
+
+	if (!report.paddr && !report.vaddr)
+		return;
+
+	if (data->sample_flags & PERF_SAMPLE_DATA_SRC)
+		report.is_write = !!(data->data_src.mem_op & PERF_MEM_OP_STORE);
+	report.tid = task_pid_vnr(current);
+	/* global id: the drain compares it with the target task's tgid */
+	report.tgid = task_tgid_nr(current);
+	damon_report_access(&report);
+}
+
+static enum cpuhp_state damon_perf_cpuhp_state;
+
+/*
+ * Per-PMU exclusivity: each PMU type may be owned by at most one damon_ctx.
+ * Multiple probes from the same ctx sharing a PMU type are allowed; a second
+ * ctx attempting to grab a PMU type already owned returns -EBUSY.
+ */
+struct damon_pmu_owner {
+	struct list_head node;
+	u32 pmu_type;
+	atomic_long_t owner_ctx;
+	atomic_t refcount;
+};
+
+static LIST_HEAD(damon_pmu_owner_list);
+static DEFINE_SPINLOCK(damon_pmu_owner_lock);
+
+static void damon_perf_event_init_attr(struct damon_perf_probe_event *event,
+				       struct perf_event_attr *attr)
+{
+	u64 stype = PERF_SAMPLE_TIME | PERF_SAMPLE_PERIOD | PERF_SAMPLE_ADDR;
+
+	if (event->attr.sample_phys_addr)
+		stype |= PERF_SAMPLE_PHYS_ADDR;
+	if (event->attr.sample_weight_struct)
+		stype |= PERF_SAMPLE_WEIGHT_STRUCT;
+	stype |= PERF_SAMPLE_DATA_SRC;
+
+	*attr = (struct perf_event_attr) {
+		.size = sizeof(*attr),
+		.type = event->attr.type,
+		.config = event->attr.config,
+		.config1 = event->attr.config1,
+		.config2 = event->attr.config2,
+		.freq = event->attr.freq,
+		.sample_type = stype,
+		.precise_ip = event->attr.precise_ip,
+		.pinned = 1,
+		/*
+		 * Created disabled, and enabled by the caller once the counter
+		 * is fully set up.
+		 */
+		.disabled = 1,
+		.wakeup_events = event->attr.wakeup_events,
+		.exclude_kernel = event->attr.exclude_kernel,
+		.exclude_hv = event->attr.exclude_hv,
+	};
+	if (event->attr.freq)
+		attr->sample_freq = event->attr.sample_freq;
+	else
+		attr->sample_period = event->attr.sample_period;
+}
+
+static int damon_perf_cpu_online(unsigned int cpu, struct hlist_node *node)
+{
+	struct damon_perf_probe_event *event = hlist_entry(node,
+			struct damon_perf_probe_event, hlist_node);
+	struct damon_perf_probe_state *perf = event->priv;
+	struct perf_event_attr attr;
+	struct perf_event *perf_event;
+
+	if (!perf)
+		return 0;
+
+	damon_perf_event_init_attr(event, &attr);
+
+	perf_event = perf_event_create_kernel_counter(&attr, cpu, NULL,
+						      damon_perf_overflow,
+						      event);
+	if (IS_ERR(perf_event)) {
+		pr_warn_ratelimited("damon-perf: cpu %u event create failed: %ld\n",
+				    cpu, PTR_ERR(perf_event));
+		return 0;
+	}
+	per_cpu(*perf->event, cpu) = perf_event;
+
+	perf_event_enable(perf_event);
+	return 0;
+}
+
+static int damon_perf_cpu_offline(unsigned int cpu, struct hlist_node *node)
+{
+	struct damon_perf_probe_event *event = hlist_entry(node,
+			struct damon_perf_probe_event, hlist_node);
+	struct damon_perf_probe_state *perf = event->priv;
+	struct perf_event *perf_event;
+
+	if (!perf)
+		return 0;
+
+	perf_event = per_cpu(*perf->event, cpu);
+	if (perf_event) {
+		perf_event_disable(perf_event);
+		perf_event_release_kernel(perf_event);
+		per_cpu(*perf->event, cpu) = NULL;
+	}
+	return 0;
+}
+
+/**
+ * damon_perf_probe_setup - arm perf_events for a DAMON probe.
+ * @ctx:   DAMON context that owns the probe.
+ * @probe: the damon_probe being armed; its list position in ctx->probes
+ *         determines the probe_idx stored in ring entries.
+ * @event: perf event descriptor (caller fills .attr fields)
+ *
+ * Computes probe_idx by walking ctx->probes so the caller does not need
+ * to track it externally.
+ *
+ * Return: 0 on success, negative errno on failure.
+ */
+int damon_perf_probe_setup(struct damon_ctx *ctx,
+			   struct damon_probe *probe,
+			   struct damon_perf_probe_event *event)
+{
+	struct damon_perf_probe_state *perf;
+	struct damon_pmu_owner *owner, *found = NULL;
+	struct damon_probe *p;
+	int idx = 0;
+	int err = -ENOMEM;
+
+	/*
+	 * Per-PMU exclusivity: find or create an owner slot for this PMU type.
+	 * Multiple probes from the same ctx sharing a PMU type are allowed;
+	 * a second ctx attempting the same PMU type returns -EBUSY.
+	 */
+	spin_lock(&damon_pmu_owner_lock);
+	list_for_each_entry(owner, &damon_pmu_owner_list, node) {
+		if (owner->pmu_type == event->attr.type) {
+			long cur = atomic_long_read(&owner->owner_ctx);
+
+			if (cur != 0L && cur != (long)ctx) {
+				spin_unlock(&damon_pmu_owner_lock);
+				return -EBUSY;
+			}
+			atomic_long_set(&owner->owner_ctx, (long)ctx);
+			atomic_inc(&owner->refcount);
+			found = owner;
+			break;
+		}
+	}
+	if (!found) {
+		/*
+		 * GFP_ATOMIC: this allocation runs while holding
+		 * damon_pmu_owner_lock (a spinlock), so it must not sleep.
+		 */
+		owner = kzalloc_obj(*owner, GFP_ATOMIC);
+		if (!owner) {
+			spin_unlock(&damon_pmu_owner_lock);
+			return -ENOMEM;
+		}
+		owner->pmu_type = event->attr.type;
+		atomic_long_set(&owner->owner_ctx, (long)ctx);
+		atomic_set(&owner->refcount, 1);
+		list_add(&owner->node, &damon_pmu_owner_list);
+		found = owner;
+	}
+	spin_unlock(&damon_pmu_owner_lock);
+
+	/* Compute probe_idx by walking ctx->probes list */
+	damon_for_each_probe(p, ctx) {
+		if (p == probe)
+			break;
+		idx++;
+	}
+	if (idx >= DAMON_MAX_PROBES) {
+		err = -ENOSPC;
+		goto release_owner;
+	}
+	event->probe_idx = idx + 1;	/* 1-based; 0 is reserved sentinel */
+	event->ctx = ctx;		/* route overflow reports to this ctx */
+
+	/*
+	 * Allocate the ctx's per-ctx perf report ring before arming any event,
+	 * so the overflow handler always finds a ready ring.  Idempotent across
+	 * a ctx's multiple probes.
+	 */
+	err = damon_ctx_alloc_perf_ring(ctx);
+	if (err)
+		goto release_owner;
+
+	err = -ENOMEM;
+	perf = kzalloc_obj(*perf, GFP_KERNEL);
+	if (!perf)
+		goto release_owner;
+
+	perf->event = alloc_percpu(typeof(*perf->event));
+	if (!perf->event)
+		goto free_perf;
+
+	event->priv = perf;
+	INIT_HLIST_NODE(&event->hlist_node);
+
+	err = cpuhp_state_add_instance(damon_perf_cpuhp_state,
+				       &event->hlist_node);
+	if (err)
+		goto free_event;
+
+	return 0;
+
+free_event:
+	free_percpu(perf->event);
+free_perf:
+	kfree(perf);
+	event->priv = NULL;
+release_owner:
+	spin_lock(&damon_pmu_owner_lock);
+	if (atomic_dec_and_test(&found->refcount)) {
+		list_del(&found->node);
+		spin_unlock(&damon_pmu_owner_lock);
+		kfree(found);
+	} else {
+		spin_unlock(&damon_pmu_owner_lock);
+	}
+	return err;
+}
+
+/**
+ * damon_perf_probe_teardown - disarm perf_events.
+ * @ctx: DAMON context that owns the probe (used to release per-PMU ownership).
+ * @event: perf event descriptor previously passed to damon_perf_probe_setup()
+ */
+void damon_perf_probe_teardown(struct damon_ctx *ctx,
+			       struct damon_perf_probe_event *event)
+{
+	struct damon_perf_probe_state *perf = event->priv;
+	struct damon_pmu_owner *owner, *tmp;
+
+	if (!perf)
+		return;
+
+	/* Stop in-flight overflows from reporting; see damon_perf_overflow(). */
+	smp_store_release(&event->ctx, NULL);
+	cpuhp_state_remove_instance(damon_perf_cpuhp_state,
+				    &event->hlist_node);
+	free_percpu(perf->event);
+	kfree(perf);
+	event->priv = NULL;
+
+	/*
+	 * Release per-PMU ownership when the last probe for this
+	 * ctx/PMU-type pair is torn down.
+	 */
+	spin_lock(&damon_pmu_owner_lock);
+	list_for_each_entry_safe(owner, tmp, &damon_pmu_owner_list, node) {
+		if (owner->pmu_type == event->attr.type &&
+		    atomic_long_read(&owner->owner_ctx) == (long)ctx) {
+			/*
+			 * Free under the lock so a concurrent same-PMU teardown
+			 * cannot observe and free the same owner.
+			 */
+			if (atomic_dec_and_test(&owner->refcount)) {
+				list_del(&owner->node);
+				kfree(owner);
+			}
+			break;
+		}
+	}
+	spin_unlock(&damon_pmu_owner_lock);
+}
+
+static int __init damon_perf_source_init(void)
+{
+	int ret;
+
+	ret = cpuhp_setup_state_multi(CPUHP_AP_ONLINE_DYN,
+				      "mm/damon/perf_source:online",
+				      damon_perf_cpu_online,
+				      damon_perf_cpu_offline);
+	if (ret < 0)
+		return ret;
+	damon_perf_cpuhp_state = ret;
+	return 0;
+}
+
+device_initcall(damon_perf_source_init);
diff --git a/mm/damon/perf_source.h b/mm/damon/perf_source.h
new file mode 100644
index 000000000000..8dcb128936ef
--- /dev/null
+++ b/mm/damon/perf_source.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * DAMON perf-event source - public interface
+ *
+ * Callers that register perf-event probes include this header.
+ */
+
+#ifndef _DAMON_PERF_SOURCE_H
+#define _DAMON_PERF_SOURCE_H
+
+#ifdef CONFIG_DAMON_PERF_SOURCE
+
+#include <linux/damon.h>
+#include <linux/perf_event.h>
+
+struct damon_perf_probe_event;
+
+int damon_perf_probe_setup(struct damon_ctx *ctx,
+			   struct damon_probe *probe,
+			   struct damon_perf_probe_event *event);
+void damon_perf_probe_teardown(struct damon_ctx *ctx,
+			       struct damon_perf_probe_event *event);
+
+#endif /* CONFIG_DAMON_PERF_SOURCE */
+#endif /* _DAMON_PERF_SOURCE_H */
diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index b549496ea8e2..78a5409fb1a6 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -490,6 +490,10 @@ static void damon_va_prep_probe_region(struct damon_ctx *ctx,
 {
 	struct damon_prep *p;
 
+	/* event-driven probes have no software prep */
+	if (probe->event_driven)
+		return;
+
 	damon_for_each_prep(p, probe) {
 		switch (p->action) {
 		case DAMON_PREP_SET_PGIDLE:
@@ -594,7 +598,12 @@ static void damon_va_probe_folio(struct damon_ctx *ctx,
 	int i = 0;
 
 	damon_for_each_probe(probe, ctx) {
-		if (damon_va_filter_pass(folio, probe, pte, pmd, mm,
+		/*
+		 * Event-driven probes are credited by the ring drain; only
+		 * sampling-based probes are here.
+		 */
+		if (!probe->event_driven &&
+		    damon_va_filter_pass(folio, probe, pte, pmd, mm,
 					r->sampling_addr))
 			r->probe_hits[i]++;
 		i++;
@@ -703,6 +712,7 @@ static unsigned int damon_va_apply_probes(struct damon_ctx *ctx,
 	struct mm_struct *mm;
 	struct damon_region *r;
 	unsigned int max_wsum = 0;
+	bool sampling = damon_has_sampling_probes(ctx);
 
 	damon_for_each_target(t, ctx) {
 		mm = damon_get_mm(t);
@@ -710,7 +720,8 @@ static unsigned int damon_va_apply_probes(struct damon_ctx *ctx,
 			if (set_samples)
 				r->sampling_addr = damon_rand(ctx, r->ar.start,
 						r->ar.end);
-			__damon_va_apply_probes(ctx, mm, r);
+			if (sampling)
+				__damon_va_apply_probes(ctx, mm, r);
 			if (return_max_wsum)
 				max_wsum = max(damon_probe_hits_wsum(r, false,
 							false, ctx), max_wsum);

-- 
Git-157)


