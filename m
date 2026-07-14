Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 614FFC4450A
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 18:32:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A9406B00EF; Tue, 14 Jul 2026 14:32:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 580946B00F1; Tue, 14 Jul 2026 14:32:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 497286B00F2; Tue, 14 Jul 2026 14:32:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2118B6B00EF
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:32:48 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9E6901A04BD
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 18:32:47 +0000 (UTC)
X-FDA: 84988228374.27.1F05D12
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	by imf31.hostedemail.com (Postfix) with ESMTP id DE09F20007
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 18:32:45 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=I2uJj5uW;
	spf=pass (imf31.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.222.178 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784053965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JG+YXpLaf6eTeKDHjsfPWQsS8e418Ifa944UVLgQD7U=;
	b=5STYOEPErm4PsEO5fkyfwg03pa1j9uoXxdteP3F0iiA/jqOYEbvqEo9mwWbxnp5SnoxMc4
	Sl5ZC1BEhp5YZQXrZuFWOBxM7MvjQn4R2S3VFAJ3svXnc73S8Th87RmsNS4M22kG5uceLt
	A8kd4uZxje40D5x2zNHC3VkYTl9P9PE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784053965;
	b=myhQwea6qeHUb59YV+FweQzrOQ2VFg0+jcopvU8h3or1BsuMzplJ2dBYO8BknWwiGjFGMk
	k1adyYY5lRarF6xuXbNhRvaC94EKR16nVrQu04T9bdROQUIPcZDJm7nn1LZYpNxQkMQgsS
	zqbQouXWSNAAS1KTTC46jrVuczQcwnQ=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=I2uJj5uW;
	spf=pass (imf31.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.222.178 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-92e53581361so321176785a.1
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 11:32:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784053965; x=1784658765; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JG+YXpLaf6eTeKDHjsfPWQsS8e418Ifa944UVLgQD7U=;
        b=I2uJj5uW92eXmeFjUiYr5AfGoeiejD6unDON5Tjvj/tzvx/0yVUPwA+YEmdfE70Q1i
         zEJjJ305uQbIaFfI/Mwh/E2+GpMl+sUImz6yc9ma8UyM9V4lM9vfFIalL3KZp2aKCRhq
         oIblVtoFEUlI0rTWKTgtXLtH+xRFqtbb9Lc0vZAoZuoQbNvhTFaQ5kkLYnF1FVbQDiLX
         fcfVj7nzE6NjLFTaQAWzEQfFJb2giq4VeP1aJGtN1dXR2zj9AzVQkKd8+7IbR4oLrIWN
         5fl5pVplMDL8bg1LA43DfV5HA4WlvP/FE+qm/VUsTozm2IdyT09bjUI4Nol/Qas9OoSJ
         BnOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784053965; x=1784658765;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JG+YXpLaf6eTeKDHjsfPWQsS8e418Ifa944UVLgQD7U=;
        b=ZNnap+nJD8uTSPhqEmA+rqm2CRxxBO6Mxbyj7yBy+C9elKV0JckwfnfrZCIxVXwvx4
         p9gwhw9iq5eQmoSJb8KJpcyvc/7IdQONw+DYIu2M+n9vxtWS7z/A8Oox2l+eOD1gAUy7
         Ry+9f4bNK1anbeneTC/iPexjNmh67zqtz5eMttbxAuKwt7RdusQ1eOdXt2yYtN49XiJ3
         XcJc65HcpCj84C1oChaMOHyJlWX0OAC0Okki34JxdCVPWtBvlTOn77JVZcsWqiF1D6o0
         AaXZ7xFnfY8dm1JhTYZbEqn4eCDHqQuKWVdcg6Ab1iwBS/vl3JMAGiyUJcbuaTDbl0gY
         uZwg==
X-Forwarded-Encrypted: i=1; AHgh+RqpY238mYGWrLD6KB1eUNq9QiyJaKoLDwkZ/67DGDuYhe4tuyOZoQsXmJr7Cq8iqDtXlPORVgoFyA==@kvack.org
X-Gm-Message-State: AOJu0YzffmhP5GnjrYrcGXFVZ3pZUAqCuAPoq4k0DGnlCNe6c4EXApRU
	iqemVPsuNbkEo5yQCUdfhBK3Q4SbvDu/q0gBTpDaXVfQxMwEW5lSSqy3
X-Gm-Gg: AfdE7cltReNrExn/CNJpzgOuCE5Yb3/voRyNn3KMI00cE7IG0KiwON9k8G7yNdp1TOs
	TKyJT1NyodqrNxmgcB3YjiQmYcGRLKb/GkDyP0ugW6EhMi4OgPvNsOIMrQs1ilobYRMXtVBpdfE
	eoR9Nq5kKFUskcI2WwyLeMZT7DUlkKNCqkVaOZqyC2h6+R+bEvCwxS6IRzLYhQClIGjeGrZl61T
	v5RcH+8gUC3GAtVZ9wyUElzTBSWo45dwCcNQgQRGp/xUZ1ERpv+tp4ooO0/Dai6eCT3FCS+g2y5
	PkkyrzBLJYxiNbZTLH35amx+EOAfyXFEMF+FKKX0gpq5piHaxI3CuRcgvCExcolJs8D/MH+ofOP
	3HkbeAPz/k3N5HjDb8JDE/DHz7UAj0n1pw8gcspBs5q0TyUu6g/Ouq5irIni3wU2HAhNM6HUsjw
	40zNaeMrq4XoNOrfRFduPRak5AtaR9fOO312mBsB5JpaPTcAX+20I=
X-Received: by 2002:a05:620a:4012:b0:92e:d63b:455b with SMTP id af79cd13be357-92ef2b12452mr1436818585a.6.1784053964792;
        Tue, 14 Jul 2026 11:32:44 -0700 (PDT)
Received: from localhost ([48.45.163.146])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92ee5b88a38sm1484900685a.12.2026.07.14.11.32.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 11:32:44 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Matthew Wilcox <willy@infradead.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Jinchao Wang <wangjinchao600@gmail.com>
Subject: [RFC PATCH 09/13] mm/kwatch: add probe lifecycle runtime
Date: Wed, 15 Jul 2026 02:32:26 +0800
Message-ID: <20260714183226.12756-1-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260714182243.10687-1-wangjinchao600@gmail.com>
References: <20260714182243.10687-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DE09F20007
X-Stat-Signature: dwq6utdu54hdx4aruk1tt8rhqr1qgwo6
X-HE-Tag: 1784053965-932324
X-HE-Meta: U2FsdGVkX199eOL6gqSG72G7xUgy9kj8XaChb6Wci7lu/Eaj6MxQrY2vCGp9UdjQyPm+bvN5/ZcFUmLcgkMegGMNCxNK1P01bEtc+MqPrk8AEfYgppEwzSfpg1CwSP6pG9cPZwoTaRPcQgW8umrx+quT2T5xBofMI6uC69PwOyTrS6vSLMpV9rDTbRt//5Ip7IU11BstOekzcNbM04sNJtDHLgJNMQQfTsMGCweNJjD5oiRA68HDDH9MELveV8uMLSq6wAuYunG4ivj1EsEiaJdKJ1KLYrNBTsmLLUpUNrZldcnuq6HwQ6+dSbSDc503TGWXI3kLc3JRX6RMD7ILgK4fb5gmoYxp4fFMFyKIO6rOy/UgL0uv97iAezIRE9LKDVDaGqWHie7yh40U+C0pF2NEkZXanCIlv0l1SSBJl1K0fw/0tLxe9/PLuz+c+L0zEDBKFc0i24ZcLN2aWAMlEymzpWbd0yeGYhGZX23lDKjH+foXVXzOjv+aC/azgU4dlJU4eP17YGbmb6gMKfANXjktb5p3A/ACxB4lbsbeKUg0vb3s/g+x452B4+15ZzLwDsfU2BASPcSxdBZfXEVJlUe9Vmk0vdVlJVWiqsy51s5IpPL1rQh+URRJ6mkXpbB3SYDEper4NN107Zen0bXoExStB9DwErKHhhJj/in5hFGmESu5ON3Zpp+Gq95PMy5oORUbCdysC6LS4ajRUqX74hA6ZfsKyJjrdIaCZScxx1XOUdUaIa32XHKcB2OHU1HM+X+hgh6dj+ZrU5u33Ga4EFmw3QkPjt3L5ro+VFmx3n6q9aea19a6x7VkQ+dp80BDR4/GoHsAm203M7fNJqoj3RFAQUm/c4766a7+ly9Zj0B0GdEIODcBLykNuDkQ7lzlFVykf9bdOeGaU//MSCB4+EKyraQMZLDW+CTphkpW3R4PbikeI6dcbycYtyclLwg5O5MQw1OJ0aO8fxT3pbG
 Ah4pmEgo
 gwGM294QRighz3rQoFfHOQLg3BlMSe5uaV5No//pwOO+pBHYjb0qmnV7CMMiCTiDMTqzckFsbxZ0k/41mqnMAKZdnkzw1Z9VH/o6gOOskEkGkh/HDyvjuIbBEGrc/Ig7zxlPvHGDAic7aMcNJ93ivvzl0MZWXBEhKJ+Dz1qjWOWzS+rvw9JpNSrZQEm54s5i24Omne8S/C0gX51POPAxFp7aWRwu3/eGMhpDZ9rIecnuQnm/m0ZezqMDGwf/xVFdbo6sdGhTZmNUSIlwN2i5PrCA6yq2XehTd/Pi5mKKxlcMqugtAE1rgw014TuwdVzTgAmPCAbzfAMJg7gmyZbNBr3hIPU14skSH+XwZL9o61OxkNFZ/8vAu+PaEndbeEhkbTLk4ZFrAVP5WpMeEDmLVxpw5JNvIlbPrzcCdqk/f75HOwBfNy7SDv0yiCoKYEZ189yWLAvS5+WcNKrd2gELh0tl8SNJkddRxElA2SqgU1lrHswk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Open and close the watch window with a kretprobe on the target
function: the entry handler tracks per-task nesting depth and, when
the configured depth is reached, resolves the watch expression and
arms a watchpoint; the exit handler disarms it. An optional kprobe
at func_offset arms mid-function instead of at entry.

Functions running in a real NMI(-like) context are rejected once, at
function entry, by comparing the NMI nesting count against the one
NMI-like layer that int3-based kprobe delivery itself adds; a
companion kprobe with a post_handler pins the probe point so jump
optimization cannot change the delivery mechanism after it is
sampled. Rejections are counted and exposed to the control plane.

A global epoch versioning scheme invalidates stale per-task state
across reconfigurations, and a per-CPU mute flag keeps window
management quiet while a CPU rewrites its own debug registers.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/kwatch/Makefile |   2 +-
 mm/kwatch/probe.c  | 263 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 264 insertions(+), 1 deletion(-)
 create mode 100644 mm/kwatch/probe.c

diff --git a/mm/kwatch/Makefile b/mm/kwatch/Makefile
index b2bc3003c89b..f04673cc5b1c 100644
--- a/mm/kwatch/Makefile
+++ b/mm/kwatch/Makefile
@@ -1,3 +1,3 @@
 obj-$(CONFIG_KWATCH) += kwatch.o
 
-kwatch-y := deref.o task_ctx.o hwbp.o
+kwatch-y := deref.o task_ctx.o hwbp.o probe.o
diff --git a/mm/kwatch/probe.c b/mm/kwatch/probe.c
new file mode 100644
index 000000000000..af6e0af45c10
--- /dev/null
+++ b/mm/kwatch/probe.c
@@ -0,0 +1,263 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/atomic.h>
+#include <linux/kprobes.h>
+#include <linux/kallsyms.h>
+#include <linux/percpu.h>
+#include <linux/preempt.h>
+#include <linux/sched.h>
+
+#include "kwatch.h"
+#define TRAMPOLINE_CHECK_DEPTH 16
+static DEFINE_PER_CPU(bool, kwatch_probe_cpu_muted);
+
+struct kwatch_probe_ctx {
+	struct kprobe kp;
+	struct kretprobe rp;
+	struct kprobe pin_kp;
+	const struct kwatch_config *cfg;
+	bool rp_via_int3;
+
+	u32 epoch;
+};
+
+static struct kwatch_probe_ctx kwatch_probe_ctx;
+static atomic_long_t kwatch_nmi_rejected;
+
+unsigned long kwatch_probe_nmi_rejected(void)
+{
+	return atomic_long_read(&kwatch_nmi_rejected);
+}
+
+/*
+ * True if the probed function itself runs in an NMI-like context.
+ * int3-based kprobe delivery adds one NMI-like layer of its own;
+ * delivery is pinned at registration so the subtraction stays exact.
+ */
+static bool kwatch_probed_ctx_in_nmi(bool via_int3)
+{
+	return (preempt_count() & NMI_MASK) > (via_int3 ? NMI_OFFSET : 0);
+}
+
+static void kwatch_pin_post_handler(struct kprobe *p, struct pt_regs *regs,
+				    unsigned long flags)
+{
+	/* a post_handler pins the probepoint: no jump optimization */
+}
+
+bool kwatch_probe_validate_hit(struct pt_regs *regs,
+			       struct task_struct *arm_tsk)
+{
+	struct kwatch_tsk_ctx *ctx = kwatch_tsk_ctx_get(false);
+
+	if (unlikely(!ctx))
+		return true;
+
+	if (arm_tsk != current ||
+	    ctx->depth != kwatch_probe_ctx.cfg->depth + 1)
+		return true;
+
+	return false;
+}
+
+void kwatch_probe_mute(bool mute)
+{
+	__this_cpu_write(kwatch_probe_cpu_muted, mute);
+}
+
+static inline bool kwatch_probe_is_muted(void)
+{
+	return __this_cpu_read(kwatch_probe_cpu_muted);
+}
+
+enum kwatch_probe_position {
+	KWATCH_PROBE_POSITION_ENTRY,
+	KWATCH_PROBE_POSITION_ACTIVE,
+	KWATCH_PROBE_POSITION_EXIT
+};
+
+static bool kwatch_tsk_ctx_check(enum kwatch_probe_position pos)
+{
+	struct kwatch_tsk_ctx *ctx = kwatch_tsk_ctx_get(true);
+	u32 epoch;
+
+	if (unlikely(!ctx))
+		return false;
+
+	/* Pairs with smp_store_release() in kwatch_probe_start/stop() */
+	epoch = smp_load_acquire(&kwatch_probe_ctx.epoch);
+
+	if (unlikely(ctx->epoch != epoch))
+		kwatch_tsk_ctx_reset(ctx, epoch);
+
+	if (unlikely(!epoch))
+		return false;
+
+	switch (pos) {
+	case KWATCH_PROBE_POSITION_ENTRY:
+		ctx->depth++;
+		return true;
+	case KWATCH_PROBE_POSITION_ACTIVE:
+		return true;
+	case KWATCH_PROBE_POSITION_EXIT:
+		if (unlikely(ctx->depth == 0)) {
+			kwatch_tsk_ctx_put();
+			return false;
+		}
+
+		ctx->depth--;
+		if (ctx->depth == 0) {
+			kwatch_tsk_ctx_put();
+			return false;
+		}
+		return true;
+	}
+	return false;
+}
+
+static int kwatch_activate_handler(struct kprobe *p, struct pt_regs *regs)
+{
+	struct kwatch_tsk_ctx *ctx = kwatch_tsk_ctx_get(false);
+	unsigned long watch_addr;
+	u16 watch_len;
+
+	if (unlikely(!ctx))
+		return 0;
+
+	if (unlikely(kwatch_probe_is_muted()))
+		return 0;
+
+	if (unlikely(!kwatch_tsk_ctx_check(KWATCH_PROBE_POSITION_ACTIVE)))
+		return 0;
+
+	if (ctx->depth != kwatch_probe_ctx.cfg->depth + 1 || ctx->wp)
+		return 0;
+
+	if (kwatch_deref_resolve(kwatch_probe_ctx.cfg, regs, &watch_addr,
+				 &watch_len))
+		return 0;
+
+	if (kwatch_hwbp_get(&ctx->wp))
+		return 0;
+
+	kwatch_hwbp_arm(ctx->wp, watch_addr, watch_len);
+	return 0;
+}
+
+static int kwatch_lifecycle_entry(struct kretprobe_instance *ri,
+				  struct pt_regs *regs)
+{
+	/*
+	 * Single policy point: the target function's context is judged once
+	 * here. A rejected invocation never increments depth, so the offset
+	 * kprobe path inherits the verdict through the depth check.
+	 */
+	if (unlikely(kwatch_probed_ctx_in_nmi(kwatch_probe_ctx.rp_via_int3))) {
+		atomic_long_inc(&kwatch_nmi_rejected);
+		return 1; /* NMI context is unsupported: no window, no return hook */
+	}
+
+	if (!kwatch_tsk_ctx_check(KWATCH_PROBE_POSITION_ENTRY))
+		return 0;
+
+	if (kwatch_probe_ctx.cfg->func_offset == 0)
+		kwatch_activate_handler(NULL, regs);
+
+	return 0;
+}
+
+static int kwatch_lifecycle_exit(struct kretprobe_instance *ri,
+				 struct pt_regs *regs)
+{
+	struct kwatch_tsk_ctx *ctx = kwatch_tsk_ctx_get(false);
+
+	if (unlikely(!ctx))
+		return 0;
+
+	if (!kwatch_tsk_ctx_check(KWATCH_PROBE_POSITION_EXIT))
+		return 0;
+
+	if (ctx->depth == kwatch_probe_ctx.cfg->depth) {
+		struct kwatch_watchpoint *wp = xchg(&ctx->wp, NULL);
+
+		if (wp)
+			kwatch_hwbp_put(wp);
+	}
+
+	return 0;
+}
+
+int kwatch_probe_start(struct kwatch_config *cfg)
+{
+	static u32 next_epoch;
+	u32 current_epoch;
+	int ret;
+
+	/*
+	 * Lockless check to prevent concurrent starts. Strictly serialized
+	 * by the control plane mutex, but serves as a sanity check.
+	 */
+	if (smp_load_acquire(&kwatch_probe_ctx.epoch) != 0)
+		return -EBUSY;
+
+	memset(&kwatch_probe_ctx, 0, sizeof(kwatch_probe_ctx));
+	kwatch_probe_ctx.cfg = cfg;
+
+	/*
+	 * Pin the entry probepoint before the kretprobe registers, so its
+	 * delivery (int3 vs ftrace) can never change under jump optimization.
+	 * register_kretprobe() clears kp.post_handler, hence the companion.
+	 */
+	kwatch_probe_ctx.pin_kp.symbol_name = cfg->func_name;
+	kwatch_probe_ctx.pin_kp.post_handler = kwatch_pin_post_handler;
+	ret = register_kprobe(&kwatch_probe_ctx.pin_kp);
+	if (ret < 0)
+		return ret;
+
+	kwatch_probe_ctx.rp.entry_handler = kwatch_lifecycle_entry;
+	kwatch_probe_ctx.rp.handler = kwatch_lifecycle_exit;
+	kwatch_probe_ctx.rp.kp.symbol_name = cfg->func_name;
+
+	ret = register_kretprobe(&kwatch_probe_ctx.rp);
+	if (ret < 0) {
+		unregister_kprobe(&kwatch_probe_ctx.pin_kp);
+		return ret;
+	}
+	kwatch_probe_ctx.rp_via_int3 = !kprobe_ftrace(&kwatch_probe_ctx.rp.kp);
+
+	if (cfg->func_offset) {
+		kwatch_probe_ctx.kp.symbol_name = cfg->func_name;
+		kwatch_probe_ctx.kp.offset = cfg->func_offset;
+		kwatch_probe_ctx.kp.pre_handler = kwatch_activate_handler;
+
+		ret = register_kprobe(&kwatch_probe_ctx.kp);
+		if (ret) {
+			unregister_kretprobe(&kwatch_probe_ctx.rp);
+			unregister_kprobe(&kwatch_probe_ctx.pin_kp);
+			return ret;
+		}
+	}
+
+	current_epoch = ++next_epoch;
+	if (unlikely(!current_epoch))
+		current_epoch = ++next_epoch;
+
+	/* Pairs with smp_load_acquire() in kwatch_tsk_ctx_check() */
+	smp_store_release(&kwatch_probe_ctx.epoch, current_epoch);
+
+	return 0;
+}
+
+void kwatch_probe_stop(void)
+{
+	if (!kwatch_probe_ctx.epoch)
+		return;
+
+	/* Pairs with smp_load_acquire() in kwatch_tsk_ctx_check() */
+	smp_store_release(&kwatch_probe_ctx.epoch, 0);
+
+	if (kwatch_probe_ctx.cfg->func_offset > 0)
+		unregister_kprobe(&kwatch_probe_ctx.kp);
+
+	unregister_kretprobe(&kwatch_probe_ctx.rp);
+	unregister_kprobe(&kwatch_probe_ctx.pin_kp);
+}
-- 
2.53.0


