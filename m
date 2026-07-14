Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 864F0C44507
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 18:33:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E1386B00F1; Tue, 14 Jul 2026 14:33:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 691CC6B00F2; Tue, 14 Jul 2026 14:33:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A8836B00F3; Tue, 14 Jul 2026 14:33:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 255CB6B00F1
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:33:11 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 86DB780437
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 18:33:10 +0000 (UTC)
X-FDA: 84988229340.04.DF1409E
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	by imf17.hostedemail.com (Postfix) with ESMTP id AC7494000A
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 18:33:08 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="PVRB/Ca6";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.222.180 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784053988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=88qx9YixiLkFD/vh8cYDKX7z/SdNlgRZ6Zz58PjlN0k=;
	b=eD1tgcRkvBygm5vrGwoNuSiJszdUkoRdVL9kTQ5fGaVqmik1XMz6t+ZTjgK0AhpBo+EVq/
	R3iv+UmYVcrqSzhedtjkIfmDybAAmpJ+iB5yawBnzO09edTCnXnFmxYwmyZM1D+8BMbcJL
	6XitQsLfpnUIU0ifcIyciLq55RMBBpU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="PVRB/Ca6";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.222.180 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784053988;
	b=FZzTF83foxgcu12WhrGD0msj+BKJqwI5rD+4ZOKyqdBetCvhEoJTg58U1Xe5gjj+V7klhH
	6kkz91GgUtPmQGCMWxomgTkfnJdNCR0gF8OHzPWYTWZZpJW0JlaN+xpTLeyOGMbTKlc8s2
	2/t17/UgYYNr6M5+Wl/Y0CEWRJtTnLk=
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-92e7c6ec9dbso197554785a.0
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 11:33:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784053988; x=1784658788; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=88qx9YixiLkFD/vh8cYDKX7z/SdNlgRZ6Zz58PjlN0k=;
        b=PVRB/Ca6rFEvgDN5jkjwVVbSF6lsLBz2rW+vFouT5qiE7d9lwdaR7s93dVyKjX+rtI
         enCxT+qCBGhrkIuaJMqWvo1G/uLcxPy6Lqk39EA3C6qfrqhgBhZfhmXfkt6yakD7UovK
         4L1Q44n0sG3Eb/NnFfWmXNa4zQYm+eyWxMpgxKtCpIlyIke/xyHL23Y2wUdfObDw3Z7M
         jCV+IugQVjZsqFNpUgzuHs1VERMxxoeKSFt0/Uwcwou2TkfKdx9VklQ5js80wHXgrdy3
         DG7gHlqbeymQl3dzZOZ5UidcfNYlWx3wkrnfZyLWogR6CKCbue03yxl+qhCI9E/hIShB
         PdZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784053988; x=1784658788;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=88qx9YixiLkFD/vh8cYDKX7z/SdNlgRZ6Zz58PjlN0k=;
        b=qbTklyaKs1cbodFMyHdv1jL0cCD/LPPrfh/0nthiDdPQGSnN4YPA1JJ3DedCNZBFuh
         iaBdgu0gxh7HuPOTs4Cigwzl0NG9BBtsmbdhhetNMkQ0wdd9DWvON9G94iUDWuELnlly
         HiB2NJQAkWAOxCZFC9ldN1lLbG5fS7PrCHe1QkZdC8YwBYz4AUAgl52s6g/ME3N5u754
         UW9jAKAH+F8TvebB8Ojau4am5BsaeBF7HN1uuTe9KYr98Zw3ocwGMQX97z4uEzgwIhS5
         pZpM+qLbvmy0dFQwFelQ1smvuj0qfOoyAw9gYbACnny8di0LSNdOAYWWJM44uLWdaRLL
         LN/g==
X-Forwarded-Encrypted: i=1; AHgh+Rr26sYvMsIExftOKM1sNJzC8qDzj+DHw5aAK42iQCCc1QMCc1yCxdT/JrRQsGDIp0sU6AoMQU3gJw==@kvack.org
X-Gm-Message-State: AOJu0YwQZUrUCIUXGZ9MjpnMgdX6vx24uRkuDDP2xLwYr9fhbnf0xC+c
	TdM1Ty2flwWo8w72BaEBcqr0kYNVYSRKUCV3JOLJjr6VorircI5n6IQD
X-Gm-Gg: AfdE7cn+TI9JoPv9duLhBSps9uRa47ewVtRtUta6N1FuZYofng8m3eNpFirTkq+FNIQ
	/ha+TpDIN2I0s1OXHsn4GabAo8j1C0AgEocRI3lLPUE77SWXQnKVtKJieZ8AoA0l/Z6oK/W4sJ6
	Btz/CNqD4YEPcjcTSVB1KAchcYMSP6U96NRsmL8n/djCeP+8nc92i/NbiRwkeAsZFy6j9Lx5TuC
	LQFE+upa8R2t64QS4CJkystMnltVZ7wXyvxvUg9tyydFOyXku/npfZfiSAK7Z+z6sqDHixqNfRs
	hsEAFy8jn70OVb3075yP8y9AZyhzO+1plsYISq2OiZbGQ6hdEfxUgFE8Oj0iYXhKqbSfnF6VIC3
	BirX+WCDoxrdQEIUq8iNgRzcyTjtuZl3UJfRuk0I8yF89Eh78+UGuU3HF35Ljo1L50Kp3gklbd1
	Bzb5eWEBA1htK4OXO9c+EjoFBZB/M3LVALzRZG8pBPCuGM+8BoBBd5kvtmuvjZTA==
X-Received: by 2002:a05:620a:2623:b0:92e:7ba3:740d with SMTP id af79cd13be357-93086c1dfb1mr389163985a.68.1784053987420;
        Tue, 14 Jul 2026 11:33:07 -0700 (PDT)
Received: from localhost ([48.45.163.146])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92ee5d6c28bsm1566578185a.46.2026.07.14.11.33.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 11:33:06 -0700 (PDT)
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
Subject: [RFC PATCH 10/13] mm/kwatch: add anchor thread for global watchpoints
Date: Wed, 15 Jul 2026 02:32:53 +0800
Message-ID: <20260714183253.12848-1-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260714182243.10687-1-wangjinchao600@gmail.com>
References: <20260714182243.10687-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AC7494000A
X-Stat-Signature: h5pa16ms1znazrhpoc6q75mdbrqbrf9k
X-HE-Tag: 1784053988-756958
X-HE-Meta: U2FsdGVkX18JQU18Ah3y+qXo7W0gAoYahqvBWoR9c5v3kMLsyb02R6Svxxy7cKwpd+PBXnzDiqbXjVpFOS8c4mN25/4O8sWJyEjMfZO6ZxxoB/DTsiUje6qiF0j9CfJvMo/LUqyuHJeJqCCkgoKf5LN2ub61znUFmCkY6LBI/DPMgS2+3z2epNPcZk/uCJOYbgyzuJ+3bGvSIOk4z8BeAQdIHhpR71wmF5XU7frMJexhSntaKLPcc4qBSJ5kqEprtuTTc+PJjTh+TyIzibui25mfXGHTmuMi5Ml+ApQ6haUEWDi2ud9DXdaVz4Ve2A/ekukMkbu+t2fqfhx9NMfONDh1xdOGQxVtZzhL5akhI/fTeTVBvpOYNKht3SipjMtMKNjsiSn0MwpDIaIHmIUJ6w5tN92om/xhi1sli3jstnkCPIjT3E0+t7DADl5/xc8yGzlQd0oAJj3HgqK9IVXEaHzgpIeXBxxseLesNTeLUyT/BRV3WaYl5/p7rkCMipePqHdqAXHwK0PYOLevfxqn3ZMkZyc/BLBDSie2Ggtw9hnzE8f7igU7wn8sOZIzqBkoCXga34RVKM4YOZ8xm2rk1czCdaPGTM38WgFXU6cWfJTjm2In5ZJA0ZNp6W2T5I0g6IT25RhXqAxkXUgGWAMoPvkFbB5xmGALM+3D7YV++r55HD23JfgIZV2bUDec6qIE/bc+1nIKdEvnJ5lRGOSsyo5jyz9e1PfNSF09sQXUjeq/nQHKbV5xdL+V8qtTK15Isq7H4WnsrWgUDQFQ1mciKvv1znMKbCUp9DgfgG78EkV7P0vu4t27IdmRNqUmOME+JSJ3/7B3Leq5ua+ZqOPJquee/KKWF6+6YhIzStebTo0A/+4bYi7lohty7FR8SjrJGgwrXoe18eGa3a/cKle668u3cqxBMncHY0DSX3n1k+RoPv/yvDiiFPvT2veycq9ftnElRvV6BBMvRnIcy0O
 1pbdEZ0Y
 yuxhJDRr96cXHhwpIj/tVrywAdh/k5DUl8DHKdRLGpwS9TlGjch+aMkk2RI4iIzTN4oQOYd2VkA9zo0miqqQ4tlhItTiiiRMvQsynNLJeae1xntZPOALz19KlK9ZXcCGASawrgZR8fVqYI0soxRX7bU7nyhK5o8fN3lBNTI00HIOv5CAf/ajkO0Ri76WpziCvsBkrnvkWx6l5XfY13MI5giWjA/L7Y6Vj9oybmegWdw/CXa8kohZ3bEspOZMaxyMxX+ex6ZckSbGwKqZPsViT6LpuLjA+Z4NB9ZsuqypC1Ag8OPZTFGFvkr1ojloRGMXCQtXAFyx1kvz1yk8lfzmdQ3KW5Labeol0XB1R9By1oCDmsNp3c+9OhYQaVDZnMhRVg7mogpi9cbleQ9uwzgh53mCAH1mnot0+yLqQesSV/MYsr7VI6AGvt+RmZj4EraokuacY0kX1286XGHoGfPsFgJjC8Qqaoum2cPYJNfvNd+RPqF7TULTh6txaK1f1OAnOmN6sn7XKJULXRds=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Global variables have no function whose execution can bound the
watch window. Provide one: a kernel thread sleeps for the configured
duration inside a dedicated noinline function,
kwatch_global_anchor(), and the probe runtime hooks that function
like any other target.

When the duration expires the thread schedules a work item that
tears the session down; the expired flag is cleared under the
control-plane mutex so a stale work item from a previous session
cannot stop a new one.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/kwatch/Makefile |  2 +-
 mm/kwatch/anchor.c | 82 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 83 insertions(+), 1 deletion(-)
 create mode 100644 mm/kwatch/anchor.c

diff --git a/mm/kwatch/Makefile b/mm/kwatch/Makefile
index f04673cc5b1c..b196c794619a 100644
--- a/mm/kwatch/Makefile
+++ b/mm/kwatch/Makefile
@@ -1,3 +1,3 @@
 obj-$(CONFIG_KWATCH) += kwatch.o
 
-kwatch-y := deref.o task_ctx.o hwbp.o probe.o
+kwatch-y := deref.o task_ctx.o hwbp.o probe.o anchor.o
diff --git a/mm/kwatch/anchor.c b/mm/kwatch/anchor.c
new file mode 100644
index 000000000000..11da6aff9413
--- /dev/null
+++ b/mm/kwatch/anchor.c
@@ -0,0 +1,82 @@
+// SPDX-License-Identifier: GPL-2.0
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/kthread.h>
+#include <linux/wait.h>
+#include <linux/jiffies.h>
+#include <linux/err.h>
+#include <linux/workqueue.h>
+
+#include "kwatch.h"
+
+static DECLARE_WAIT_QUEUE_HEAD(kwatch_anchor_wq);
+static struct task_struct *kwatch_anchor_tsk;
+static bool kwatch_anchor_expired;
+
+bool kwatch_anchor_has_expired(void)
+{
+	return READ_ONCE(kwatch_anchor_expired);
+}
+
+void kwatch_anchor_clear_expired(void)
+{
+	WRITE_ONCE(kwatch_anchor_expired, false);
+}
+
+static void kwatch_auto_stop_handler(struct work_struct *work)
+{
+	kwatch_auto_stop();
+}
+
+static DECLARE_WORK(kwatch_auto_stop_work, kwatch_auto_stop_handler);
+
+noinline void kwatch_global_anchor(unsigned long duration_sec)
+{
+	wait_event_timeout(kwatch_anchor_wq, kthread_should_stop(),
+			   duration_sec * HZ);
+}
+
+static int kwatch_anchor_thread_fn(void *data)
+{
+	unsigned long duration = (unsigned long)data;
+
+	kwatch_global_anchor(duration);
+
+	if (!kthread_should_stop()) {
+		/* mark before scheduling; cleared under the control mutex */
+		WRITE_ONCE(kwatch_anchor_expired, true);
+		schedule_work(&kwatch_auto_stop_work);
+	}
+
+	while (!kthread_should_stop())
+		schedule_timeout_uninterruptible(HZ);
+
+	return 0;
+}
+
+int kwatch_anchor_start(u16 duration)
+{
+	kwatch_anchor_tsk = kthread_run(kwatch_anchor_thread_fn,
+					(void *)(unsigned long)duration,
+					"kwatch_anchor");
+	if (IS_ERR(kwatch_anchor_tsk)) {
+		int ret = PTR_ERR(kwatch_anchor_tsk);
+
+		kwatch_anchor_tsk = NULL;
+		return ret;
+	}
+	return 0;
+}
+
+void kwatch_anchor_stop(void)
+{
+	if (kwatch_anchor_tsk) {
+		kthread_stop(kwatch_anchor_tsk);
+		kwatch_anchor_tsk = NULL;
+	}
+}
+
+void kwatch_anchor_cancel_work(void)
+{
+	cancel_work_sync(&kwatch_auto_stop_work);
+}
-- 
2.53.0


