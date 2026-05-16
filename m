Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A432CD4F3C
	for <linux-mm@archiver.kernel.org>; Sat, 16 May 2026 22:35:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34F9A6B009D; Sat, 16 May 2026 18:35:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FE406B009E; Sat, 16 May 2026 18:35:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 179736B009F; Sat, 16 May 2026 18:35:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F27EF6B009D
	for <linux-mm@kvack.org>; Sat, 16 May 2026 18:34:59 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B42568D328
	for <linux-mm@kvack.org>; Sat, 16 May 2026 22:34:59 +0000 (UTC)
X-FDA: 84774739518.21.0080BAF
Received: from mail-yw1-f194.google.com (mail-yw1-f194.google.com [209.85.128.194])
	by imf30.hostedemail.com (Postfix) with ESMTP id C0CE780003
	for <linux-mm@kvack.org>; Sat, 16 May 2026 22:34:57 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Up7HXzH/";
	spf=pass (imf30.hostedemail.com: domain of ravis.opensrc@gmail.com designates 209.85.128.194 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778970897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hvMZysC8itbbidjyAgiRDox5/pyQFwV2BMVhnr5sBjw=;
	b=7koH1fkFutm0G3OyNSSoBhRq/nc2QkbQnpSdN+D237LhEH7abUy+UeyytESoz/fEmpb6l7
	7hYWESK4GTcRUt3KWJFzPk7QoNkS0MP6O9I+0587cXRqoAJjKroGmXzFHdU6FGRe/8RoMC
	RgEKkr5pgH14PESDy2mPE4VLDFarBRk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Up7HXzH/";
	spf=pass (imf30.hostedemail.com: domain of ravis.opensrc@gmail.com designates 209.85.128.194 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778970897; a=rsa-sha256;
	cv=none;
	b=L8Q1EPZ9f2bJqxdVu6zp+jIaanMWuJz28Sa33vuryViLH1jpzM0bjNLDaUku4MAXZ+RLQX
	nXasJrRWEc8GhkAuKOirjylYQ1xW03fHmLTB6TmE3tkL9ayFWD8WkmBer85UVFOKsIsCfs
	E1HTSkx4lb+50dXTH9TGNVarl7w+CeU=
Received: by mail-yw1-f194.google.com with SMTP id 00721157ae682-7c58e6eb3edso4712397b3.2
        for <linux-mm@kvack.org>; Sat, 16 May 2026 15:34:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778970897; x=1779575697; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hvMZysC8itbbidjyAgiRDox5/pyQFwV2BMVhnr5sBjw=;
        b=Up7HXzH/nNVUYjZ5ye71tMoxOFPhMB/1UwGKt/mrG++abxXYrK25cvsNqk2h49aPk4
         fUm/i3HQUf5POlR+d3ysJl0OYY62PO4PG+lkDj94ZhCK07ylsUaHKwr9RZlmN6mgQ+yr
         COPYlU5BfnrC6cd/icQbOLBWxVIMwKlP67dTlXOkGJyzoLKUrqQb9/5+GoVbGwg5u2Jd
         A7J5YVs2mFX5I119FY/+8LbnAKwDdB6pYHrUwaEaMlkoCOlXbkO8cmJ4SEscUVBowGKT
         cQ9FqWIQPXP4rFSZfdddaQ+GOsyutxOKI94cfEeLLLx8F3awC6FHvKoApGsXZwHWep3D
         EG0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778970897; x=1779575697;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hvMZysC8itbbidjyAgiRDox5/pyQFwV2BMVhnr5sBjw=;
        b=lay8JhDsplZkME4qFefVeneOXFR5O45BrYsyoYsM/0fmd5LlfBD26gnCTjXLWsVUWb
         mdrbe7jMLEpeSSU5XM7mKqn2hvt/m5xUdBHhLfVO4VbSQtdsTUOeydVJHzo1gisr7OLs
         upzgyEzOL6ULUUm5OhYnp6Inx3taxq86m3A4Tf2n23WSlBnZJ/LN0eR2lejm+xl7AXbB
         auVtJZc475tNQOOkh88MkgU9XycC74/fHEmaavZMECfbgsZjPN0qbb0r3kc1CXzG59cv
         AiWVkxg2g3ApS7OqzsigYmUD3ZK3HKeYr6SmsYgRDVtqXAWfIuGz8mrRgnmXzFv3kB/p
         Fh/A==
X-Forwarded-Encrypted: i=1; AFNElJ/UqkRyZjFfWmy3t50f5+pt51JWn2ujuEuDT7LK+LtV5CD5La/Ntm/cjjphJ9ri/pfSHve2I1k8sg==@kvack.org
X-Gm-Message-State: AOJu0YzPl56KlCAB6s9shFpKnwVlSHhE897kmvJhfdflqOGQGSvL6VPH
	fFBPwvf+dTEI/pDPGxfcXnm+xklMUxGP1xJG8i6GD7vq8SS244VwRfg=
X-Gm-Gg: Acq92OGdsDlMKc6+PNwz3fEOPsMCfsZDzb3/qlSo+0c0uhwIlqZmSx83beUC8RBN5mR
	35cL1J/a8XAE57fi56hzUSTqK2/uPZKgYJbgfWd/GuEQlQV274JlMkp6Md709VnwrIkZcDeFWL0
	5OWC18FuQf/+lpJTMcxrbyDsgGTL8Pjz7OMBD4itMDnz8+sr1bJMFkc7NV2gQW5AZo5NFN/nPcF
	iPoESlk4icZpMTEWlrElOZL7rmn9rLMGIZCwrYUunjHCZdNwGK0letRgYcA5qxCVffxLJdliqCX
	mPhqT5L6uk/c/gIt6HwGCactewRBhfr1bINL2/swrvoaswix2sEjiuM4QFsE+FpE+rd9/cja7Gs
	q9PpmCimNeS1ZqCpl8BZgVWrX/yhHVuvhPjtjNVqF3kWL+J3NKXytEPQ4fA/64fgX5/009jZHCZ
	Z52TetLKQviM2sOCU+Kfw/OYFxrvuYDrsoYixg/71b6klBniiS5dnOsOeUneXY6xJsRoRl9jt9T
	Q==
X-Received: by 2002:a05:690c:c364:b0:7c0:de77:f466 with SMTP id 00721157ae682-7c9594b3711mr86084717b3.2.1778970896587;
        Sat, 16 May 2026 15:34:56 -0700 (PDT)
Received: from localhost (23-116-43-216.lightspeed.sntcca.sbcglobal.net. [23.116.43.216])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7cc9bc0db09sm690837b3.27.2026.05.16.15.34.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 May 2026 15:34:56 -0700 (PDT)
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
Subject: [RFC PATCH 7/7] mm/damon/damon_ibs: add AMD IBS-based access sampling backend
Date: Sat, 16 May 2026 15:34:32 -0700
Message-ID: <20260516223439.4033-8-ravis.opensrc@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260516223439.4033-1-ravis.opensrc@gmail.com>
References: <20260516223439.4033-1-ravis.opensrc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C0CE780003
X-Rspamd-Server: rspam06
X-Stat-Signature: wfuwiy1x8q8zdz9bxafy5qqhj4qi4ybz
X-HE-Tag: 1778970897-207153
X-HE-Meta: U2FsdGVkX18ddE6JprOlaMyIwhF209dF0tKJUYbuMAlIcnMdEJqJjj2p8fyFTh1CLG3WNVQTtuFyEwalcTtveYVt3BHQ7VO6rtfUUAQsgt2ZqQxOWZYqnuVKMxAVAasqznGWBc7wAcCj5txyR2a0B2WMIJCvDPkOz7ydxmvQgay8I9szPL72Dl2axu1zwQDHJK4V6671dZgZhPe9KREKIJTJiQ4LTTG1W27DcyzhRuXRUz4yMVjE6AOufxq6KHx6sbFyotcT4N6LK0W1MHtmr2l9Eila5Zck69nk9XvqlJEHxyyKcN4TaCKO1PRHtYLi76zZkfnwehB1ZmKS/4VFYQGNvk6MUKuKwHVFavWIMA1JrXOKUJREtwr/jWUWhc/RNjD7fg7GVfQUXCGdPnxtd3fsTYjtnsjvnsblQNvCq8BvTWOWsQAjH7DtBnyb881forS6Uss2RtZ6Qf2cwb4vQTN7PWrMzJAqGYnW/oVD9gnw1ba+qRzUuMzlpxLpWbzblJOfkdKg2Q4a/yFHh5VHx1GoLWaAOrBsMkV0DtWQetELISGWiUXVigX+e4aXFHmcOAG7C0hmtbrR//oj6amG61XLaoAnRONwS/8batvtEMosFydrc2eWcrMhV41HffkR6yPZw0YzJB01POqYhL/fmiOYwzZzYYQkYBbheFSeyKPGIM0vOaLvve9eHm+QzagaY5ifISsWBX9YoFiFhh4nAoCMT8k49bN/Bj1p969Ck3HFZscBuWMfyIM6eg4pyTEKVpWL9WZbYXdNGEGWP7NTPcbbEEP6nlp+piAjm8eGac1yuXZ3la56WXiOcrmPkZx/j3+qYjyyZYVBcmM5+3brAHALAm2bZu2eM5NOyxD+1tEI5fc+Y8z/BQPekNKlqE5t17mrmORHIRY3FuLT0iA+3C/rJqCxsGYzSyX5PkNRfS8Alk5AiUtyvsGkltzu+x0NWlHpeW62M9TjaYAWlAR
 0gp1dNl8
 bpMN/NDZOm3fO1V7NaJxNsoZ1y7+qFLensXu7pdcdOcbCTU96AGoJXBo8o71rdX4sXUg9CPEnfNgHxa/qyeHRaDx8yyEMw0gvv3jyLbopdMtVdNOF1uSzfGb2NQ72u5VRdjitdc/piDGScNqU5N4lpqgfnR4EbFaBU+3baT7BOerVA3HkCNnVvtrzC1hWSxQeEwP55WFrBxBsI2uS6ehvKAUZ0MBDUE/+r8zWCEEacMngnqPGMJmZ0RbB2oeGfAJGFU1PcWi3Sdr9Lq5PoUqgZ3RRemAZBEANW/n19NO45/m1zVe5a/A7e8CaPhSAJcHhn9rEFrsl2SRTSk7UjSiIy7jBAHBs3lj4Lo/Sud9RHhQX6eCgdHq09VT1IsGrWCRpnbtAK41AqJ5AUe2qnHj+6VLorzraaXiiUc1zRcW3yueoe+Oe6GdyD7Nsmy+62fdgtWLJY3iLJVzYLfMJn/f34JShMGoK+p2gUTgeJ5Kp1kdOvXQocYcrZRGne3scP5Qn2sxRYkMD9Uw/r9ENfhTHXdBgnzVmYI1uS7DHV7FBC+QymJ1Pyg67LbPlol3FEa/rf2D1j7h2/Ac+TDxcUt7ae9k+0xddr9y5PlT3im/WfFeYyYblqVnqrcxiWKbjUUFDFNo/9sxkon0yAiA/Qx5rWFRKdIQt2zLA5sJqpLkqTQYtOc6hX8B0EalYlqNTJjUvt4g6xbtdtTkdn+V48/GRP+s919h+gSZJgThxWimpTavoalw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add paddr_ibs operations using AMD IBS Op sampling via
perf_event_create_kernel_counter().  IBS delivers physical-address-
keyed access reports to DAMON's shared-layer ring buffer
(damon_report_access()), without dependency on PTE Accessed-bit
scanning or page faults.

Per-CPU IBS events are created and torn down via cpuhp notifiers
(CPUHP_AP_ONLINE_DYN).  Routing of access reports through the ring-
drain path is bound to ops.id == DAMON_OPS_PADDR_IBS at the dispatch
site (see "mm/damon: add sysfs binding and dispatch hookup for
paddr_ibs operations"), so .init does not need to flip a per-context
flag.

Sample-time discipline:
  - PERF_SAMPLE_PHYS_ADDR is requested in attr.sample_type, but the
    IBS perf driver only fills data->phys_addr when
    IBS_OP_DATA3.dc_phy_addr_valid is set.  Skip stale-PA samples by
    inspecting data->sample_flags rather than testing phys_addr for
    zero (which would also drop legitimate page 0).
  - PERF_SAMPLE_DATA_SRC is requested so the perf driver decodes
    IBS_OP_DATA3.{ld_op,st_op} into data->data_src.mem_op; the
    backend reports load vs store accordingly via
    damon_access_report.is_write.

Module parameters:
  - max_cnt: IBS Op MaxCnt (writable; writes call
    damon_ibs_set_sample_rate() to restart sampling at the new rate)
  - samples_total / samples_filtered: per-CPU-aggregated counters
    (read-only)

Source file is mm/damon/damon_ibs.c (renamed from mm/damon/ibs.c) so
the resulting module is loaded as damon_ibs.ko, avoiding the generic
"ibs" namespace.

The IBS sampling approach is derived from Bharata B Rao's pghot RFC v5
series; the attribution header is in damon_ibs.c.

Suggested-by: Bharata B Rao <bharata@amd.com>
Link: https://lore.kernel.org/linux-mm/20260129144043.231636-1-bharata@amd.com/
Signed-off-by: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
---
 mm/damon/Kconfig     |  10 ++
 mm/damon/Makefile    |   1 +
 mm/damon/damon_ibs.c | 369 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 380 insertions(+)
 create mode 100644 mm/damon/damon_ibs.c

diff --git a/mm/damon/Kconfig b/mm/damon/Kconfig
index ad629f0f31d8d..bb698d2717f34 100644
--- a/mm/damon/Kconfig
+++ b/mm/damon/Kconfig
@@ -131,4 +131,14 @@ config DAMON_ACMA
 	  min/max memory for the system and maximum memory pressure stall time
 	  ratio.
 
+config DAMON_IBS
+	tristate "AMD IBS-based access sampling for DAMON"
+	depends on DAMON_PADDR && CPU_SUP_AMD && X86_64 && PERF_EVENTS
+	help
+	  Uses AMD IBS (Instruction-Based Sampling) hardware to deliver
+	  physical-address-keyed access reports to DAMON's shared-layer
+	  ring buffer, without relying on PTE Accessed-bit scanning or
+	  page faults.  Registers as the "paddr_ibs" operations set.
+	  Requires AMD processors with IBS Op support.
+
 endmenu
diff --git a/mm/damon/Makefile b/mm/damon/Makefile
index 22494754f41e8..109d0fb1db97d 100644
--- a/mm/damon/Makefile
+++ b/mm/damon/Makefile
@@ -9,3 +9,4 @@ obj-$(CONFIG_DAMON_RECLAIM)	+= modules-common.o reclaim.o
 obj-$(CONFIG_DAMON_LRU_SORT)	+= modules-common.o lru_sort.o
 obj-$(CONFIG_DAMON_STAT)	+= modules-common.o stat.o
 obj-$(CONFIG_DAMON_ACMA)	+= modules-common.o acma.o
+obj-$(CONFIG_DAMON_IBS)		+= damon_ibs.o
diff --git a/mm/damon/damon_ibs.c b/mm/damon/damon_ibs.c
new file mode 100644
index 0000000000000..1dd99e91c3928
--- /dev/null
+++ b/mm/damon/damon_ibs.c
@@ -0,0 +1,369 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * DAMON IBS (Instruction-Based Sampling) backend for AMD processors.
+ *
+ * Uses AMD IBS Op sampling via the perf kernel counter infrastructure to
+ * deliver PA-keyed access reports to DAMON's shared-layer ring buffer
+ * (see damon_report_access()).  This enables physical-address hot-page
+ * detection without relying on page-table Accessed bits or page faults.
+ *
+ * The IBS sampling approach in this file derives from concepts in
+ * Bharata B Rao's pghot RFC v5 series for hot page tracking.
+ * See: https://lore.kernel.org/linux-mm/20260129144043.231636-1-bharata@amd.com/
+ *
+ * Author: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
+ */
+
+#include <linux/cpu.h>
+#include <linux/fs.h>
+#include <linux/module.h>
+#include <linux/percpu.h>
+#include <linux/perf_event.h>
+#include <linux/slab.h>
+#include <linux/smp.h>
+
+#include <linux/damon.h>
+#include "ops-common.h"
+
+#define DAMON_IBS_DEFAULT_MAX_CNT	262144	/* ~4K samples/sec/core */
+#define IBS_OP_PMU_TYPE_PATH	"/sys/bus/event_source/devices/ibs_op/type"
+
+static unsigned int damon_ibs_max_cnt = DAMON_IBS_DEFAULT_MAX_CNT;
+
+static int damon_ibs_set_sample_rate(unsigned int max_cnt);
+
+static int max_cnt_set(const char *val, const struct kernel_param *kp)
+{
+	unsigned int new_cnt;
+	int ret;
+
+	ret = kstrtouint(val, 0, &new_cnt);
+	if (ret)
+		return ret;
+	if (!new_cnt)
+		return -EINVAL;
+	return damon_ibs_set_sample_rate(new_cnt);
+}
+static const struct kernel_param_ops max_cnt_ops = {
+	.set = max_cnt_set,
+	.get = param_get_uint,
+};
+module_param_cb(max_cnt, &max_cnt_ops, &damon_ibs_max_cnt, 0644);
+MODULE_PARM_DESC(max_cnt,
+	"IBS MaxCnt (ops between samples). Writes restart sampling.");
+
+static DEFINE_MUTEX(damon_ibs_lock);
+static bool damon_ibs_enabled;
+static enum cpuhp_state damon_ibs_cpuhp_state;
+static unsigned int ibs_pmu_type;	/* discovered at init */
+
+static DEFINE_PER_CPU(struct perf_event *, damon_ibs_event);
+
+/*
+ * Diagnostic counters.  Incremented from NMI context, so use per-CPU
+ * counters and sum them on read.
+ */
+static DEFINE_PER_CPU(unsigned long, ibs_samples_total_pcpu);
+static DEFINE_PER_CPU(unsigned long, ibs_samples_filtered_pcpu);
+
+static unsigned long damon_ibs_sum_pcpu(unsigned long __percpu *var)
+{
+	unsigned long sum = 0;
+	int cpu;
+
+	for_each_possible_cpu(cpu)
+		sum += per_cpu(*var, cpu);
+	return sum;
+}
+
+static int samples_total_get(char *buffer, const struct kernel_param *kp)
+{
+	return sysfs_emit(buffer, "%lu\n",
+			damon_ibs_sum_pcpu(&ibs_samples_total_pcpu));
+}
+
+static int samples_filtered_get(char *buffer, const struct kernel_param *kp)
+{
+	return sysfs_emit(buffer, "%lu\n",
+			damon_ibs_sum_pcpu(&ibs_samples_filtered_pcpu));
+}
+
+static const struct kernel_param_ops samples_total_ops = {
+	.get = samples_total_get,
+};
+static const struct kernel_param_ops samples_filtered_ops = {
+	.get = samples_filtered_get,
+};
+
+module_param_cb(samples_total, &samples_total_ops, NULL, 0444);
+MODULE_PARM_DESC(samples_total, "Total IBS samples delivered (read-only)");
+module_param_cb(samples_filtered, &samples_filtered_ops, NULL, 0444);
+MODULE_PARM_DESC(samples_filtered, "IBS samples filtered out (read-only)");
+
+/**
+ * damon_ibs_overflow_handler() - IBS overflow callback.
+ *
+ * Called when an IBS Op counter overflows.  The IBS perf driver fills
+ * data->phys_addr from IBSDCPHYSAD when dc_phy_addr_valid is set.
+ *
+ * Context: NMI — no sleeping, no mutex, no kmalloc.
+ */
+static void damon_ibs_overflow_handler(struct perf_event *event,
+				       struct perf_sample_data *data,
+				       struct pt_regs *regs)
+{
+	struct damon_access_report report;
+	unsigned long phys_addr;
+
+	if (!data)
+		return;
+
+	/*
+	 * PERF_SAMPLE_PHYS_ADDR was requested in attr.sample_type, but
+	 * the IBS perf driver only populates data->phys_addr when
+	 * IBS_OP_DATA3.dc_phy_addr_valid is set.  Skip stale-PA samples
+	 * by checking the sample_flags rather than testing phys_addr
+	 * for zero (which would also drop legitimate page 0).
+	 */
+	if (!(data->sample_flags & PERF_SAMPLE_PHYS_ADDR)) {
+		this_cpu_inc(ibs_samples_filtered_pcpu);
+		return;
+	}
+	phys_addr = data->phys_addr;
+
+	report = (struct damon_access_report){
+		.paddr = phys_addr & PAGE_MASK,
+		.size = PAGE_SIZE,
+		.cpu = smp_processor_id(),
+		.is_write = !!(data->data_src.mem_op & PERF_MEM_OP_STORE),
+	};
+	damon_report_access(&report);
+	this_cpu_inc(ibs_samples_total_pcpu);
+}
+
+static int damon_ibs_create_event(int cpu)
+{
+	struct perf_event_attr attr = {
+		.type = ibs_pmu_type,
+		.size = sizeof(attr),
+		/* config=0: IBS perf driver uses sample_period as MaxCnt. */
+		.config = 0,
+		.sample_period = damon_ibs_max_cnt,
+		.sample_type = PERF_SAMPLE_PHYS_ADDR | PERF_SAMPLE_DATA_SRC,
+		.pinned = 1,
+	};
+	struct perf_event *event;
+
+	event = perf_event_create_kernel_counter(&attr, cpu, NULL,
+						 damon_ibs_overflow_handler,
+						 NULL);
+	if (IS_ERR(event))
+		return PTR_ERR(event);
+
+	/*
+	 * perf_event_create_kernel_counter() returns the event already
+	 * enabled; no perf_event_enable() needed here.
+	 */
+	per_cpu(damon_ibs_event, cpu) = event;
+	return 0;
+}
+
+static void damon_ibs_destroy_event(int cpu)
+{
+	struct perf_event *event = per_cpu(damon_ibs_event, cpu);
+
+	if (!event)
+		return;
+
+	perf_event_disable(event);
+	perf_event_release_kernel(event);
+	per_cpu(damon_ibs_event, cpu) = NULL;
+}
+
+static int damon_ibs_cpu_online(unsigned int cpu)
+{
+	int ret = damon_ibs_create_event(cpu);
+
+	if (ret)
+		pr_warn_ratelimited(
+			"damon-ibs: failed to create perf_event on cpu %u (err %d); "
+			"this cpu will not contribute samples\n", cpu, ret);
+	return 0;	/* never block CPU online */
+}
+
+static int damon_ibs_cpu_offline(unsigned int cpu)
+{
+	damon_ibs_destroy_event(cpu);
+	return 0;
+}
+
+/* Caller must hold damon_ibs_lock. */
+static int __damon_ibs_start(void)
+{
+	int ret;
+
+	if (damon_ibs_enabled)
+		return -EBUSY;
+
+	ret = cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "damon/ibs:online",
+				damon_ibs_cpu_online, damon_ibs_cpu_offline);
+	if (ret < 0)
+		return ret;
+	damon_ibs_cpuhp_state = ret;
+
+	damon_ibs_enabled = true;
+	pr_info_once("damon-ibs: first start (max_cnt=%u, pmu_type=%u)\n",
+		     damon_ibs_max_cnt, ibs_pmu_type);
+	return 0;
+}
+
+/* Caller must hold damon_ibs_lock. */
+static void __damon_ibs_stop(void)
+{
+	if (!damon_ibs_enabled)
+		return;
+
+	cpuhp_remove_state(damon_ibs_cpuhp_state);
+	damon_ibs_enabled = false;
+}
+
+static int damon_ibs_start(void)
+{
+	int ret;
+
+	mutex_lock(&damon_ibs_lock);
+	ret = __damon_ibs_start();
+	mutex_unlock(&damon_ibs_lock);
+	return ret;
+}
+
+static void damon_ibs_stop(void)
+{
+	mutex_lock(&damon_ibs_lock);
+	__damon_ibs_stop();
+	mutex_unlock(&damon_ibs_lock);
+}
+
+/**
+ * damon_ibs_set_sample_rate() - Set IBS sampling interval.
+ * @max_cnt: IBS Op MaxCnt value (ops between samples).
+ *           Higher = fewer samples/sec.
+ *
+ * If IBS is already running, restart it with the new rate.
+ *
+ * Return: 0 on success; if a restart was required and failed,
+ * propagate the error so callers (e.g. the max_cnt module-param
+ * .set callback) surface it to userspace instead of silently
+ * leaving sampling stopped.
+ */
+static int damon_ibs_set_sample_rate(unsigned int max_cnt)
+{
+	int ret = 0;
+
+	mutex_lock(&damon_ibs_lock);
+	damon_ibs_max_cnt = max_cnt ? max_cnt : DAMON_IBS_DEFAULT_MAX_CNT;
+
+	if (damon_ibs_enabled) {
+		__damon_ibs_stop();
+		ret = __damon_ibs_start();
+		if (ret)
+			pr_warn("damon-ibs: restart failed: %d\n", ret);
+	}
+	mutex_unlock(&damon_ibs_lock);
+	return ret;
+}
+
+
+static void damon_ibs_init_ctx(struct damon_ctx *ctx)
+{
+	int ret;
+
+	/* IBS is the access-detection source for this ctx. */
+	ctx->sample_control.primitives_enabled.page_table = false;
+
+	ret = damon_ibs_start();
+	if (ret && ret != -EBUSY)
+		pr_warn("damon-ibs: failed to start IBS sampling: %d\n", ret);
+}
+
+/**
+ * damon_ibs_discover_pmu_type() - Discover IBS Op PMU type from sysfs.
+ *
+ * Reads /sys/bus/event_source/devices/ibs_op/type to get the PMU type
+ * identifier needed for perf_event_attr.type.
+ *
+ * TODO: replace sysfs-read with a PMU lookup API when one becomes
+ * available.
+ *
+ * Return: 0 on success, negative error code otherwise.
+ */
+static int damon_ibs_discover_pmu_type(void)
+{
+	struct file *f;
+	char buf[16];
+	loff_t pos = 0;
+	ssize_t len;
+	int ret;
+
+	f = filp_open(IBS_OP_PMU_TYPE_PATH, O_RDONLY, 0);
+	if (IS_ERR(f))
+		return PTR_ERR(f);
+
+	len = kernel_read(f, buf, sizeof(buf) - 1, &pos);
+	filp_close(f, NULL);
+	if (len <= 0)
+		return -EIO;
+
+	buf[len] = '\0';
+	ret = kstrtouint(strim(buf), 10, &ibs_pmu_type);
+	if (ret)
+		return ret;
+
+	pr_info("damon-ibs: discovered ibs_op PMU type=%u\n", ibs_pmu_type);
+	return 0;
+}
+
+static int __init damon_ibs_init(void)
+{
+	struct damon_operations ops = {
+		.id = DAMON_OPS_PADDR_IBS,
+		.owner = THIS_MODULE,
+		.init = damon_ibs_init_ctx,
+		.prepare_access_checks = damon_pa_prepare_access_checks,
+		.check_accesses = damon_pa_check_accesses,
+		.apply_probes = damon_pa_apply_probes,
+		.apply_scheme = damon_pa_apply_scheme,
+		.get_scheme_score = damon_pa_scheme_score,
+	};
+	int err;
+
+	if (!boot_cpu_has(X86_FEATURE_IBS))
+		return -ENODEV;
+
+	err = damon_ibs_discover_pmu_type();
+	if (err) {
+		pr_err("damon-ibs: failed to discover IBS PMU type: %d\n", err);
+		return err;
+	}
+
+	err = damon_register_ops(&ops);
+	if (err)
+		return err;
+
+	pr_info("damon-ibs: AMD IBS backend registered (max_cnt=%u, pmu_type=%u)\n",
+		damon_ibs_max_cnt, ibs_pmu_type);
+	return 0;
+}
+
+static void __exit damon_ibs_exit(void)
+{
+	damon_ibs_stop();
+	damon_unregister_ops(DAMON_OPS_PADDR_IBS);
+}
+
+module_init(damon_ibs_init);
+module_exit(damon_ibs_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Ravi Jonnalagadda <ravis.opensrc@gmail.com>");
+MODULE_DESCRIPTION("AMD IBS-based access sampling backend for DAMON");
-- 
2.43.0


