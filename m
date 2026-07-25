Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01E49C531D0
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 18:26:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B5386B00A4; Sat, 25 Jul 2026 14:26:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93E216B00A6; Sat, 25 Jul 2026 14:26:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 853976B00A7; Sat, 25 Jul 2026 14:26:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 387CC6B00A4
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 14:26:39 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8BB2D403A1
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 18:26:38 +0000 (UTC)
X-FDA: 85028129676.02.FD944DF
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf07.hostedemail.com (Postfix) with ESMTP id C1A2440002
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 18:26:36 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BxNzIP5e;
	spf=pass (imf07.hostedemail.com: domain of nsd.project.dev@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=nsd.project.dev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785003996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pQdZdu+GEqOuh+POT8SK+LbvisqRrlELTO7OGW9vi2E=;
	b=r9ucxNjQ+BZEHAiqj8kiWxRvecjFnxw7skGhHAxrCf/Ect1AcxcCFvOBx/k4z9ZQc4Pfjv
	+SXA/mHqHFBF5hAxlK35yfF6Vc/btFa1vYTS2cjHkbnHOuUnIByPIcvttJSJFua7KbKcox
	0jPtqVNa2hfvsLmo6bXTLVxEIXUxtPk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BxNzIP5e;
	spf=pass (imf07.hostedemail.com: domain of nsd.project.dev@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=nsd.project.dev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785003996;
	b=UFAP1WlJvoDtMDEQqeaxHSlxYSlydo+5NA6EvDdqPxlUPsRDjfjTKBN0mZTgOMzPfsz4q9
	Gs1aBbDSq/+JBIKLUc/UB5BzPY+Xc6nErbX7hVpDRxQxJOPbjYVNz/ppg+NoBmzyHnE36E
	TDMh8ske2v7g7e8xfn4OyS2Ml7D41fQ=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4954afac04bso15956485e9.0
        for <linux-mm@kvack.org>; Sat, 25 Jul 2026 11:26:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785003995; x=1785608795; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pQdZdu+GEqOuh+POT8SK+LbvisqRrlELTO7OGW9vi2E=;
        b=BxNzIP5eGEO5wIBqcnaC+NVQVASbMIv2Dh32yXLsYTfF/W2z6upaSa8KkjP/N17rE+
         3NWWvoGBb3qtn7zbLyys4H4e/poNDRuLbEJLS9z67rkORODtQ+GOQGs0FZ09sQ4TTska
         1bnALjFmZ5h7SLYD3KihXKo5O2zpZxRxv3DG2VIFcJ4vagqvdmPaEc6IWC7Fnw3V19sA
         FMLLYscGkNyqto3pRlN4VgxjfFUnHC8eTF6T2U4IEpqQyeBg0Q5JPYAJntFGkBAoAONa
         zwhty1STJSqhXW2oaQqlD0hbqzPgQIg0TrkPn5/b+jN+4EKITdhkr4+vRj8xbTfUexO7
         fhEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785003995; x=1785608795;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=pQdZdu+GEqOuh+POT8SK+LbvisqRrlELTO7OGW9vi2E=;
        b=aGaWjscR116swGsMjlsPQWbND8ag//8fTLGCrNigMJj9fgTC5ThvBwPJz/131lSKgl
         X1VzjUFiPez0R5BrAMGDXcUOrOaMK9Uh0ZV/tzwDooZ3PAfC9FKzgwTBa+P/WSTuiTGc
         KlOsyd9MAVpioILvu/RCdg2aEHFTiGle+NKNzNyIH3jZgHigLeAiQ+cBjb84id5goOE2
         oLUp4DI/2lP5EouKqPXt7ZALrCJnvcwnKxiaJbloNefrkIbeSngMqnNggkNsyUJkqlft
         PiYafT7sEva4ENlFSwtF/PN2tUyed4ZFrKmCbU5nueXAM/83flMO1NWtpU3TjtZgit/E
         m5DA==
X-Forwarded-Encrypted: i=1; AHgh+Ro9A08dk6ZUof3h6JtDBEWVFBCxuqRg/tawXuMpZv/38gNJie58fgh4l06yNGZ6DIPf+qG8ssV4wQ==@kvack.org
X-Gm-Message-State: AOJu0Yx9ZushPopjI1TelcuWk6zIeT36Pn0rY7MQtQKw1PdCCMRlDlFr
	ytQpXrthZnysWOXMno6cjwCn8LBZ2hA5gSCrIxzvTy9ZnjxNszPrIzdt
X-Gm-Gg: AR+sD109UYczFZYV1eyXQYYVStUc5Qs7JSW7j/+zfTRTn97/eNE/FjRtESE6KnA2WDE
	cCkuInxByjNEIIaiRSgyeZz3tXnBXXvdPEJrMsDLyuOLWkJpN5hew4oWaPrB/54TsXXgDrIwj/7
	a0Y3npA9ufhj+JyNxP8wCwciyqregGzDyjyDQ2L2wnbb4efX8k7jN7779b/ZXUM3oPX88fk2UUt
	0iqzeUufq7WP6Cpl2YxGePpj2b8jFjNcPhOU9gjoTULiFrWSpmN9Xi8K1LNzIo7VVNbmUJfp/GW
	P+17nelbd0fiJc008mtIu/WEpj914IQhpJ1DDFOUwr0IMLdbbsUMiTuLcD9U3YhGiOsd2/Kge0J
	cwm2y9qYoqIJkoRBxA1zAJiHPy1bdXXZV/qV9w0ZNquk2jvQajFBlRKKbioBo9bb7am0x0lOTTY
	+lor3yV1Q=
X-Received: by 2002:a05:600c:630d:b0:495:4d00:2fc0 with SMTP id 5b1f17b1804b1-496b56bec0cmr40434825e9.12.1785003995320;
        Sat, 25 Jul 2026 11:26:35 -0700 (PDT)
Received: from localhost ([178.241.98.184])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-496b485ff2csm111111645e9.6.2026.07.25.11.26.33
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 25 Jul 2026 11:26:35 -0700 (PDT)
From: Ayhan Aydin <nsd.project.dev@gmail.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: nsd.project.dev@gmail.com
Subject: [RFC PATCH 2/3] nsd: Core prediction engine
Date: Sat, 25 Jul 2026 21:26:27 +0300
Message-ID: <20260725182628.221603-3-nsd.project.dev@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260725182628.221603-1-nsd.project.dev@gmail.com>
References: <20260725182628.221603-1-nsd.project.dev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C1A2440002
X-Stat-Signature: igar6fnuzrms864cbdkimts8wtqzgigz
X-HE-Tag: 1785003996-704773
X-HE-Meta: U2FsdGVkX1+OX19sbVsK/k2qjVV/G8STINVImYlBThWMMof7MxxpS07gYoJtwdM8vHDtWjHbzesOIQOk5ghVaha4cFoVMGgVSAjnJV/2QveWnglSil/4PMWFt4SgjHMS1GyxGW3qyn5yLbU14UM+q6VDY7wxfFtGWeAKaDkyLUwvVZ1vTDqIislJBqusg8PfAlVQiRJ6JdHxxP1RxTdGb5Y2p2b2iEPNuwW2GXu7ul9x+yXRy0mvkMSjQP/X7ecgtVQ8ZLZfwr4YP0cBXX+fQnRpdArSPExSliagwRGDHswUiHTSgQXBZpAHzJDvXjYexOiUwt2lZCSkPxluWOeVAK5+SSmsS0UWWEMzVlqjNivTCPZQz9glmp2iPi4kJOP8zXWyKrDkWWzKXAVY/ytmwf3Toqy75LPFLgDeyrZeqgsx+CtfOS6G3wep0YLpAdXns2flqzNvj8OLXtudunw5LBYvADuzK+CBCEt++qhwG/158+hHsQiESDnWAglRa4PKGmngu09W3bABJNwVLv/zX+yPJ4NYTQAHyt0InLRSVYl1fX/ieVccBzgPl0tBKAnUnG/qGJ1k7I5p5Vb6BvtBz/bABJCE9/xmsgLB8p1+Lr6M4I0TN7YXJ9kMFj98uNa18m1VN/ErKoGyyjUDJjwQ08clBh56bvu7/C7fg7Ph1NCPpRSDVwVqY1IDq/habloY3Eu7FMvTuhWe5OL2DuR/LBQXWf+4KfwmHyZT1f0KPbPDL3OwEwz8wrU4JCOixj3hVnjlUdpWhKpBTrKH6Phee7AgCWHjyI9PNKbNpUoIURgfs3/taqWIE/cVnla9GaLvNeqXaDnn4ToBbEStI5hbV0MIIxCSdstvH3gDthhZv7onazdnpkqsk2D8i/EIUGN6ObYgiBxSmXZUJCTHcE3xRDDF1d+MPVlEJldI84zgVYZCh5nbvCzHZ04x2bRAbnOKeS4UJGl+n5TCjUu2FsD
 NLn6h9fy
 8lIf5CvJoIGSHcDjn1zmOAyYNUZZzqm8Nt7Ioxo8/zwSNY57ZGPeGrwY62bOSy+gUyDOJ565RtbyysDrUa05+jkQ+rlXkW8SXldzE1Uju4DFILF03pV9sTVN6rLzIxcjXXERWabQirNQw1SdwZK0XHk/UxWOmWGTzMQonZvITfHl9DKeF0LewdXoJGLJFeIp0JQENkzn42/lCwoCK3wg5kq9tymKNHLYscV5VeLQ/fUM0ZxXlgvXHqXlRcghjU/wFobrf4WReFT1Evhh7EOVOs7Pwv8dtdVY6PNNUnUYEGsmRsHvs4NephyB4+k5i1lupqaanPp/7DMxwjv8pVMrZ5ReAqDt7sYhiOIqdWarUQYb/TbOKUdZqv84lqpxDEp3G31f4MehR11jlNfyoHIuSCmiiv+qv3hgMENdnfdJd4ovOELVgfKwqD56w3VUNQuieMB28nreKri+2EL8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the NSD prediction engine with synaptic Markov chain,
stride predictor, sysfs interface, and prefetch worker.
See Documentation/filesystems/nsd.rst for details.

Signed-off-by: Ayhan Aydin <nsd.project.dev@gmail.com>
---
 fs/nsd/Kconfig  |  16 ++
 fs/nsd/Makefile |   8 +
 fs/nsd/core.c   | 453 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 477 insertions(+)
 create mode 100644 fs/nsd/Kconfig
 create mode 100644 fs/nsd/Makefile
 create mode 100644 fs/nsd/core.c

diff --git a/fs/nsd/Kconfig b/fs/nsd/Kconfig
new file mode 100644
index 0000000..5ddd8cc
--- /dev/null
+++ b/fs/nsd/Kconfig
@@ -0,0 +1,16 @@
+config NSD
+	tristate "Neural Storage Driver (NSD) - learning prefetcher"
+	depends on MMU
+	help
+	  NSD is a learning prefetcher that monitors I/O patterns via a hook
+	  in the kernel page cache read path and prefetches pages using
+	  page_cache_sync_readahead().
+
+	  It builds a synaptic Markov chain model of access patterns at
+	  4KB region granularity, detecting sequential strides, repeating
+	  patterns, and learned transitions.
+
+	  When loaded, NSD adds a small hook in filemap_read() that
+	  compiles to a no-op when NSD is disabled.
+
+	  To compile as a module: M, leave blank to disable.
\ No newline at end of file
diff --git a/fs/nsd/Makefile b/fs/nsd/Makefile
new file mode 100644
index 0000000..db5126c
--- /dev/null
+++ b/fs/nsd/Makefile
@@ -0,0 +1,8 @@
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# Makefile for NSD (Neural Storage Driver)
+#
+
+obj-$(CONFIG_NSD) += nsd.o
+
+nsd-y := core.o
diff --git a/fs/nsd/core.c b/fs/nsd/core.c
new file mode 100644
index 0000000..1f42fa9
--- /dev/null
+++ b/fs/nsd/core.c
@@ -0,0 +1,453 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * core.c - Neural Storage Driver core prediction engine
+ *
+ * A learning prefetcher using a synaptic Markov chain model
+ * to predict and prefetch pages in the kernel page cache.
+ *
+ * Called from filemap_read() via nsd_notify_read(). The function
+ * is exported for CONFIG_NSD=m; if built-in, it is called directly.
+ */
+
+#define pr_fmt(fmt) "nsd: " fmt
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/atomic.h>
+#include <linux/workqueue.h>
+#include <linux/kthread.h>
+#include <linux/delay.h>
+#include <linux/percpu.h>
+#include <linux/jiffies.h>
+#include <linux/random.h>
+#include <linux/sched.h>
+#include <linux/fs.h>
+#include <linux/nsd.h>
+#include <linux/sysfs.h>
+#include <linux/kobject.h>
+#include <linux/string.h>
+#include <linux/mm.h>
+#include <linux/pagemap.h>
+#include <linux/version.h>
+
+#define NSD_VERSION             "1.0.0"
+#define NSD_REGION_SHIFT        12
+#define NSD_REGION_BYTES        BIT(NSD_REGION_SHIFT)
+#define NSD_SYN_TABLE_SIZE      BIT(20)
+#define NSD_SYN_MASK            (NSD_SYN_TABLE_SIZE - 1)
+#define NSD_STRIDE_PRED_MAX     256
+#define NSD_PREFETCH_DEPTH      256
+#define NSD_RING_SIZE           256
+#define NSD_HOT_ENTRIES         1024
+#define NSD_WORKQUEUE_NAME      "nsd_prefetch"
+
+struct nsd_synapse {
+	u64                     key;
+	u32                     next_region;
+	u32                     strength;
+	u32                     hits;
+	u32                     maybe_hits;
+	u32                     chain_count;
+	struct nsd_synapse      *next;
+};
+
+struct nsd_ring_entry {
+	u32             file_id;
+	u32             region;
+	u64             ts;
+};
+
+struct nsd_pcpu_ring {
+	struct nsd_ring_entry   entries[NSD_RING_SIZE];
+	unsigned int            head;
+	unsigned int            tail;
+};
+
+static DEFINE_PER_CPU(struct nsd_pcpu_ring, nsd_rings);
+
+struct nsd_hot_entry {
+	u32             file_id;
+	u32             last_region;
+	u32             stride;
+	s32             stride_count;
+	u32             regions[8];
+	unsigned int    pos;
+};
+
+static struct nsd_hot_entry nsd_hot[NSD_HOT_ENTRIES];
+static DEFINE_SPINLOCK(nsd_hot_lock);
+
+static struct nsd_synapse *nsd_syn_table[NSD_SYN_TABLE_SIZE];
+static DEFINE_SPINLOCK(nsd_syn_lock);
+
+static atomic_t nsd_prefetch_count = ATOMIC_INIT(0);
+static atomic_t nsd_used_count = ATOMIC_INIT(0);
+static atomic_t nsd_waste_count = ATOMIC_INIT(0);
+static atomic_t nsd_stride_preds = ATOMIC_INIT(0);
+static atomic64_t nsd_syn_entries = ATOMIC64_INIT(0);
+static unsigned int nsd_chain_depth;
+static bool nsd_observe_only;
+static bool nsd_penalty_state = true;
+static bool nsd_waste_track;
+
+static struct task_struct *nsd_worker_thread;
+static DECLARE_WAIT_QUEUE_HEAD(nsd_worker_wait);
+static struct workqueue_struct *nsd_wq;
+static struct kobject *nsd_kobj;
+
+module_param_named(observe_only, nsd_observe_only, bool, 0644);
+MODULE_PARM_DESC(observe_only, "Start in observe-only mode");
+module_param_named(penalty_state, nsd_penalty_state, bool, 0644);
+MODULE_PARM_DESC(penalty_state, "Enable penalty on waste");
+module_param_named(waste_track, nsd_waste_track, bool, 0644);
+MODULE_PARM_DESC(waste_track, "Enable waste tracking");
+
+static u32 nsd_file_id(struct file *file)
+{
+	return (u32)((unsigned long)file >> 6);
+}
+
+static u32 nsd_off_to_region(loff_t off)
+{
+	return (u32)(off >> NSD_REGION_SHIFT);
+}
+
+static u64 nsd_syn_key(u32 file_id, u32 region)
+{
+	return ((u64)file_id << 32) | region;
+}
+
+static u32 nsd_syn_hash(u64 key)
+{
+	return (u32)(key ^ (key >> 20)) & NSD_SYN_MASK;
+}
+
+static struct nsd_synapse *nsd_syn_lookup(u64 key)
+{
+	u32 hash = nsd_syn_hash(key);
+	struct nsd_synapse *s = nsd_syn_table[hash];
+
+	while (s) {
+		if (s->key == key)
+			return s;
+		s = s->next;
+	}
+	return NULL;
+}
+
+static struct nsd_synapse *nsd_syn_insert(u64 key, u32 region)
+{
+	u32 hash = nsd_syn_hash(key);
+	struct nsd_synapse *s;
+
+	s = kmalloc(sizeof(*s), GFP_ATOMIC);
+	if (!s)
+		return NULL;
+
+	s->key = key;
+	s->next_region = 0;
+	s->strength = 1;
+	s->hits = 0;
+	s->maybe_hits = 0;
+	s->chain_count = 0;
+	s->next = nsd_syn_table[hash];
+	nsd_syn_table[hash] = s;
+	atomic64_inc(&nsd_syn_entries);
+	return s;
+}
+
+static void nsd_syn_learn(u32 file_id, u32 prev_region, u32 cur_region)
+{
+	u64 key;
+	struct nsd_synapse *s;
+	unsigned long flags;
+
+	if (!prev_region)
+		return;
+
+	key = nsd_syn_key(file_id, prev_region);
+	spin_lock_irqsave(&nsd_syn_lock, flags);
+	s = nsd_syn_lookup(key);
+	if (!s) {
+		s = nsd_syn_insert(key, cur_region);
+		if (!s) {
+			spin_unlock_irqrestore(&nsd_syn_lock, flags);
+			return;
+		}
+	}
+	if (s->next_region == cur_region) {
+		if (s->strength < 1000)
+			s->strength++;
+	} else if (s->strength > 1) {
+		s->strength--;
+	} else {
+		s->next_region = cur_region;
+	}
+	s->hits++;
+	spin_unlock_irqrestore(&nsd_syn_lock, flags);
+}
+
+static int nsd_check_stride(struct nsd_hot_entry *h, u32 region)
+{
+	s32 diff;
+
+	if (!h->last_region)
+		goto update;
+
+	diff = (s32)(region - h->last_region);
+	if (diff > 0 && diff <= 256) {
+		if (h->stride == (u32)diff) {
+			if (h->stride_count < 1000)
+				h->stride_count++;
+		} else {
+			if (h->stride_count > 0)
+				h->stride_count--;
+			else
+				h->stride = (u32)diff;
+		}
+	} else {
+		h->stride_count = 0;
+	}
+
+update:
+	h->last_region = region;
+
+	if (h->stride_count >= 2) {
+		atomic_inc(&nsd_stride_preds);
+		return (int)h->stride;
+	}
+	return 0;
+}
+
+static void nsd_pcpu_push(u32 file_id, u32 region)
+{
+	struct nsd_pcpu_ring *ring = this_cpu_ptr(&nsd_rings);
+	unsigned int next = (ring->head + 1) & (NSD_RING_SIZE - 1);
+
+	if (next == ring->tail)
+		return;
+
+	ring->entries[ring->head].file_id = file_id;
+	ring->entries[ring->head].region = region;
+	ring->entries[ring->head].ts = jiffies;
+	ring->head = next;
+}
+
+static void nsd_prefetch(struct file *file, pgoff_t index, unsigned int count)
+{
+	struct address_space *mapping = file->f_mapping;
+
+	if (!mapping)
+		return;
+
+	page_cache_sync_readahead(mapping, &file->f_ra, file, index, count);
+	atomic_add(count, &nsd_prefetch_count);
+}
+
+static void nsd_process_events(void)
+{
+	struct nsd_pcpu_ring *ring;
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		ring = per_cpu_ptr(&nsd_rings, cpu);
+		while (ring->tail != ring->head) {
+			struct nsd_ring_entry *e;
+			u64 key;
+
+			e = &ring->entries[ring->tail];
+			key = nsd_syn_key(e->file_id, e->region);
+
+			struct nsd_synapse *s;
+			spin_lock(&nsd_syn_lock);
+			s = nsd_syn_lookup(key);
+			if (s) {
+				s->maybe_hits++;
+				s->chain_count++;
+			}
+			spin_unlock(&nsd_syn_lock);
+
+			ring->tail = (ring->tail + 1) & (NSD_RING_SIZE - 1);
+		}
+	}
+}
+
+static int nsd_worker_fn(void *data)
+{
+	while (!kthread_should_stop()) {
+		wait_event_timeout(nsd_worker_wait,
+				   kthread_should_stop() || nsd_observe_only,
+				   HZ / 10);
+
+		if (kthread_should_stop())
+			break;
+		if (nsd_observe_only)
+			continue;
+
+		nsd_process_events();
+	}
+	return 0;
+}
+
+void nsd_notify_read(struct file *file, loff_t pos, size_t len)
+{
+	u32 file_id, cur_region, prev_region;
+	unsigned long flags;
+	struct nsd_hot_entry *h = NULL;
+	int i, stride;
+	pgoff_t prefetch_idx;
+
+	if (!file || nsd_observe_only)
+		return;
+
+	file_id = nsd_file_id(file);
+	cur_region = nsd_off_to_region(pos);
+	nsd_pcpu_push(file_id, cur_region);
+
+	spin_lock_irqsave(&nsd_hot_lock, flags);
+	for (i = 0; i < NSD_HOT_ENTRIES; i++) {
+		if (nsd_hot[i].file_id == file_id) {
+			h = &nsd_hot[i];
+			break;
+		}
+	}
+	if (!h) {
+		for (i = 0; i < NSD_HOT_ENTRIES; i++) {
+			if (!nsd_hot[i].last_region) {
+				h = &nsd_hot[i];
+				h->file_id = file_id;
+				break;
+			}
+		}
+	}
+	if (!h)
+		h = &nsd_hot[0];
+
+	prev_region = h->last_region;
+	h->last_region = cur_region;
+	spin_unlock_irqrestore(&nsd_hot_lock, flags);
+
+	nsd_syn_learn(file_id, prev_region, cur_region);
+
+	stride = nsd_check_stride(h, cur_region);
+	prefetch_idx = (pos >> PAGE_SHIFT) + stride;
+	if (stride > 0) {
+		nsd_prefetch(file, prefetch_idx,
+			     min_t(unsigned int, stride, NSD_PREFETCH_DEPTH));
+		wake_up(&nsd_worker_wait);
+	}
+}
+EXPORT_SYMBOL_GPL(nsd_notify_read);
+
+/* sysfs */
+static ssize_t nsd_stats_show(struct kobject *kobj,
+			      struct kobj_attribute *attr, char *buf)
+{
+	unsigned long prefetched = atomic_read(&nsd_prefetch_count);
+	unsigned long used = atomic_read(&nsd_used_count);
+	unsigned long wasted = atomic_read(&nsd_waste_count);
+	unsigned long hit_rate = prefetched ? (used * 100 / prefetched) : 0;
+
+	return sysfs_emit(buf,
+		"prefetched   %lu\n"
+		"used         %lu\n"
+		"wasted       %lu\n"
+		"hit_rate_real %lu%%\n"
+		"stride_preds %u\n"
+		"chain_depth  %u\n"
+		"synapse_ents %llu\n"
+		"mode         %s\n",
+		prefetched, used, wasted, hit_rate,
+		atomic_read(&nsd_stride_preds),
+		nsd_chain_depth,
+		atomic64_read(&nsd_syn_entries),
+		nsd_observe_only ? "observe" : "active");
+}
+
+static struct kobj_attribute nsd_stats_attr = __ATTR(stats, 0444, nsd_stats_show, NULL);
+
+#define NSD_BOOL_ATTR(name)                                             \
+static ssize_t name##_show(struct kobject *kobj,                        \
+			   struct kobj_attribute *attr, char *buf)      \
+{                                                                       \
+	return sysfs_emit(buf, "%d\n", nsd_##name);                    \
+}                                                                       \
+static ssize_t name##_store(struct kobject *kobj,                        \
+			    struct kobj_attribute *attr,                \
+			    const char *buf, size_t count)              \
+{                                                                       \
+	bool val;                                                       \
+	if (kstrtobool(buf, &val))                                      \
+		return -EINVAL;                                         \
+	nsd_##name = val;                                               \
+	return count;                                                   \
+}                                                                       \
+static struct kobj_attribute name##_attr =                              \
+	__ATTR(name, 0644, name##_show, name##_store)
+
+NSD_BOOL_ATTR(observe_only);
+NSD_BOOL_ATTR(penalty_state);
+NSD_BOOL_ATTR(waste_track);
+
+static struct attribute *nsd_attrs[] = {
+	&nsd_stats_attr.attr,
+	&observe_only_attr.attr,
+	&penalty_state_attr.attr,
+	&waste_track_attr.attr,
+	NULL,
+};
+ATTRIBUTE_GROUPS(nsd);
+
+static int __init nsd_init(void)
+{
+	int ret;
+
+	pr_info("NSD v%s loading\n", NSD_VERSION);
+
+	nsd_wq = alloc_workqueue(NSD_WORKQUEUE_NAME, WQ_UNBOUND, 1);
+	if (!nsd_wq)
+		return -ENOMEM;
+
+	nsd_worker_thread = kthread_run(nsd_worker_fn, NULL, "nsd_worker");
+	if (IS_ERR(nsd_worker_thread)) {
+		destroy_workqueue(nsd_wq);
+		return PTR_ERR(nsd_worker_thread);
+	}
+
+	nsd_kobj = kobject_create_and_add("nsd", kernel_kobj);
+	if (!nsd_kobj) {
+		kthread_stop(nsd_worker_thread);
+		destroy_workqueue(nsd_wq);
+		return -ENOMEM;
+	}
+
+	ret = sysfs_create_groups(nsd_kobj, nsd_groups);
+	if (ret) {
+		kobject_put(nsd_kobj);
+		kthread_stop(nsd_worker_thread);
+		destroy_workqueue(nsd_wq);
+		return ret;
+	}
+
+	pr_info("NSD ready | /sys/kernel/nsd/ | observe_only=%d\n", nsd_observe_only);
+	return 0;
+}
+
+static void __exit nsd_exit(void)
+{
+	sysfs_remove_groups(nsd_kobj, nsd_groups);
+	kobject_put(nsd_kobj);
+	kthread_stop(nsd_worker_thread);
+	destroy_workqueue(nsd_wq);
+	pr_info("NSD unloaded\n");
+}
+
+module_init(nsd_init);
+module_exit(nsd_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Ayhan Aydin <nsd.project.dev@gmail.com>");
+MODULE_DESCRIPTION("Neural Storage Driver - learning prefetcher");
+MODULE_VERSION(NSD_VERSION);
-- 
2.43.0


