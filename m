Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 639A7C5AC82
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 09:40:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BA186B00A1; Mon, 10 Aug 2026 05:40:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 491826B00A2; Mon, 10 Aug 2026 05:40:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A7236B00A3; Mon, 10 Aug 2026 05:40:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 142A26B00A1
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 05:40:39 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A5A18806D5
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 09:40:38 +0000 (UTC)
X-FDA: 85084864956.25.104A2D1
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf23.hostedemail.com (Postfix) with ESMTP id E6C68140011
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 09:40:36 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XlN7bvMx;
	spf=pass (imf23.hostedemail.com: domain of gxxa03070307@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=gxxa03070307@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786354836;
	b=7AO4xRhJaEItSsmVKraRoifdmN9Go5MQZrGJ2wMK8w0Y4brLvPWHs6KNgKA2cG0692t89+
	V5IWDb4RkXagkRqzkkmKXXcakPUwAkdAthmAUF4rWFagLcWB3coQF7NzLnriKrRq8Wizz1
	z9SlK+G98sSLaYcC4LnLJIhnrh/K/9I=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XlN7bvMx;
	spf=pass (imf23.hostedemail.com: domain of gxxa03070307@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=gxxa03070307@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786354836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=h8TjGG7W8xBATTSwzzjsDpLSfAeA/sVM6NcS21BdVcE=;
	b=aNDauHDYcO6Pes29XnE3qpisel8T9/1ELPmziR3cZnCRd0tMN7fUuzaCvfwOyrsbG9rnjE
	CWT0JobTwq1WDY9HY+lN4F9+6hyFXGWai47z+U8NmrVi/QwoxvrpuVYPmh7+weLKwaX2t0
	lC4lE1EzkxoLx4qqkohCi/XKI/0CD+8=
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-38fdeaed181so1996363a91.1
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 02:40:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786354836; x=1786959636; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=h8TjGG7W8xBATTSwzzjsDpLSfAeA/sVM6NcS21BdVcE=;
        b=XlN7bvMxaNtNbgLOlRJUnY4W1XLEs8iR8cHFUhQLQ/ET/Qt3XKYObJnpFbIMxFQ3n/
         nc6ITaK8zpUYIAJegtipq948xTkSczUKPVwxj4AAKPcH7XFJNP1+r++CVM71IqxajlL1
         i7GDVt5+U4SpIUNah0lzBTwBH/8EyFgQG/KeGcg7KexG0JC39mVJn4tyRho1u8y57MTT
         6dFQ3LmjLVUxjAL9aViT9kddVa1UY6CkgVgawEVvTaQ0bV+nzPljw9f5ZWD2YirqlqE0
         1oZ7ec60kY2yUTi5JotvjTrvFJB827jol/RqrY5YHgils3xlZLuI7gpLFz3LVfJRCk3u
         uJfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786354836; x=1786959636;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=h8TjGG7W8xBATTSwzzjsDpLSfAeA/sVM6NcS21BdVcE=;
        b=MTNcSx9ZI+ozXthr5tdgdb9+R9TXo/C8xyvQ0Fe9ZNouCYJURCxW8Xym6i1qDOhkwi
         StianiTWzjXyd4o8PegAdYz7NLEHsffGmX3zn6/j5WHGYUcHZ3ZtmYKyWq+cA1Cg7jBj
         Zsy7M5ao5zzywuHLahbe8R60iJdSSVfvyABUdNorvVd0Up1Q376GtAzU0dAI8W8YKev5
         LiMlo8UqOwSu4ZWV3DlBMspzLbGXNN+gOPkMqZXEPJFVeThBGcvXdXOs+xldualr+egT
         goYJQ6whbQFua8wuKSaCwygKIPv/aWUtzqCoDQzaldocFzBmtj3oHGuZHsehjD6MFxnO
         HMJA==
X-Forwarded-Encrypted: i=1; AHgh+RqbcZf9TJ5tKZz9F1Bl90dHcpjxJ27M16RhxBGgdCkPSx9cN+K75/NDgv8Fk9DpVQiQYdZRPuTebg==@kvack.org
X-Gm-Message-State: AOJu0YyIg/Fpg09m29j40M/actiMzqZEQYDfHbc/sAVDukoRoJi9gq4Y
	unqKCiNL0ad5DxHkibwiqqVn+fhaDYNGyh/2ylTuo+IFq7WX67pjboRc
X-Gm-Gg: AR+sD11NwxEKnXbY1a8nHw1DmyVGywXvkZvS2jmrHIGb8GtjXzvVrhUKgWoDqIgfX0Q
	3W+f1Q0n71Knm63XUoGmzT+rNlpZxoGYgKHixA5HFoelFa/chrTEfcZnSI5eFvrtmTZYfK+pdwl
	I0aCarkwdYPzxR79cBdxbUtQSIcl+9XoHmC4E+xWF+qbAi3yFtj/RlWXzCJHJlffcDjNDIgu7Vq
	6gT86MNm1dyV1U4cWXnUtypecyOZhIx5cRLau9BohHG43b0QFtFmc87/t6fRvZ5jovZy0Nf/GUy
	BgXl/UyWWXWU3DHEvIqfBKGl0KghpImH3oKnaTxTQqUDvB21Bq2xmsgkFlKQVEik6cKMuEOlSdi
	xki9gWb1NR6JyQ2QvtJqPh1UiB1gy6AnLyM3fjun4nzHXfuF8JesNkaatSpb948rnmZo8OkEjox
	NCEwFbOY5xdQhRSiEvoSPJuS5V7ZMojQ7xHRjfkUR1rWRRjq2s21xoorfTjfQf0gTcQUmKmaCTY
	k5ZzfccCEdB0qQrGIKtR7JiuZXAs9hK6Wd+Rhk=
X-Received: by 2002:a17:90b:578e:b0:383:5a16:bd70 with SMTP id 98e67ed59e1d1-3903c5ebc8cmr43653966a91.16.1786354835714;
        Mon, 10 Aug 2026 02:40:35 -0700 (PDT)
Received: from bj-kjy-standalone-gaoxiang17.mioffice.cn ([43.224.245.230])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39085de9f6asm14070527a91.7.2026.08.10.02.40.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2026 02:40:35 -0700 (PDT)
From: Xiang Gao <gxxa03070307@gmail.com>
X-Google-Original-From: Xiang Gao <gaoxiang17@xiaomi.com>
To: Steven Rostedt <rostedt@goodmis.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	liam@infradead.org,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-trace-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Xiang Gao <gaoxiang17@xiaomi.com>
Subject: [PATCH] tracing: report buffer memory in /proc/meminfo
Date: Mon, 10 Aug 2026 17:40:25 +0800
Message-Id: <20260810094025.136705-1-gaoxiang17@xiaomi.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E6C68140011
X-Stat-Signature: h4e5uz6poo5bnq44nurbsraz3cya6rxd
X-Rspam-User: 
X-HE-Tag: 1786354836-254287
X-HE-Meta: U2FsdGVkX1+Wy+rH2/yzVgzMeiwXMO7imVsL4VOhojeX6rOT2aPq04MeU3b00TJfmSL5AQyEQWzp6dOl5bpvOGx6WLkVV1R6MrqepwbvFEOv4S21sV6EPmaPyEmNT9/aA3HIOBoDvD0QzF9M/qTcLgWtTT0kQWm4TRWjPdBY2vFCXvGy7YTJtcXKxkDeO2jhYxSrugpCWR79rJYy+Pqd++J96S6Vsl7UATT6gMz1qWXOUuucfBBDiQZB0A9NTeM+ulF1zFUwGCbM8GxlDL1/K+ifTgFrlJDeFRSXLoW9DIbfUKjenkPyLrCmdW4RJbgigwN4AoK6iMolELueOdBf4DqgNBG8TSwH70mY7W1aahvWNS+twu7/vk+7tYvMWMZNvxasskFGThEF+furHmRDwr7HB3QIp1KOMssXe3Osiiou/+xNivp/i+/ZW06FXWTnowONPRCoukh/SxMVGc8htVhaAA/cI1oxM86fVztkfwH37UruxAaa3e94fTY5qRH1LycHuKFjtQIZgtqFvkXwkhj8XXhFCoXGpK4aMyFtv9LHAmdP23ZpH49/pktoMEWFaO2UhzjavtFEXzmiUrOetc2OHUD/Fhey+/IKpBE82YwBIa9OvW/ryDzBHRkTpUoQvpJ1hH7y8HsAPJLYTZ6o5efGfeDrWJ7hD3u1y9a+Hu0pZzOMmePl5aagrx81VdlL6xrsu2T3KFvc+bD+bBw3ka/GN6TWbAOfx1A6oxsBhSZK6mCYBXIMeIg7by7klrUd3WpbddvYKCzD7JRQmGfHpbdBCQudYNZ0vrm2OCEubh1uSvCFyuV33eTHFs5C426bEYu0eeUXT7AxcvEJO6azfKtNyP2iCXuWpZpA5uZIc2XHHsNK7q+LKW4rYYMBInvIHSGmUakFs2EsYjQtlKCDUJ3hXpsp8/n4TXF3J05P+faJmfRhYVXYTloH92TjIgOIr5njS4/S3Z07ZNU21/4
 IDPnTyrW
 nWXtb/m9s0ub3T/KsEMzzTQi3sxi6E8mx9OPbjkJgTUIwVyDA549sC/hYYlYrqSitaTAsjfQBYvy6hvrW37fPsbkzCPStj/FO0JGO6cxtFF5aFeVHa2UmqubTYIQBgQZ9/sM+QPnMwr/XeGfa53smPUwKsRj4HVcAsQWoZsYd2S8Q+Btl8ZvwLTFbx/6z2aP7zbP0wzcqtStXeq1/EA/wuYdESbrnTK4/vDjBEV4XbBI0okC6Vb8Buq/oQbaxAnL+ezedpm20JzzMCK37dJKju8RGLBwWsvTEvLvgcXgBjQonV4f3m0khARI7FQHlVzgTCSX3StIbaiEPB2cHMOeqNW9PEcYaQnDYyQQ6WLO6NVhSYvY1ZW4ckT8MJAA1XwOD0ia2NQjra/DcW173YmXtmLJ14Rv2xaKiEHkw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Report the data capacity of all ftrace ring buffers through a new Ftrace
field in /proc/meminfo. Include the main and snapshot buffers of the
global trace array and all tracing instances, while leaving ring-buffer
metadata accounted for by Slab.

Keep the interface as a no-op when tracing is disabled so /proc/meminfo
does not gain a configuration dependency on tracing.

Tested on arm64 QEMU:

  CONFIG_TRACING=n:                   0 kB
  Global resize/restore:          7 -> 4099 -> 7 kB
  Instance and snapshot lifecycle: 15 -> 1434 -> 2836 -> 1434 -> 15 kB

Signed-off-by: Xiang Gao <gaoxiang17@xiaomi.com>
---
 fs/proc/meminfo.c     |  3 +++
 include/linux/trace.h |  5 +++++
 kernel/trace/trace.c  | 30 ++++++++++++++++++++++++++++++
 3 files changed, 38 insertions(+)

diff --git a/fs/proc/meminfo.c b/fs/proc/meminfo.c
index b2813ff13cb2..96a38ffc4e35 100644
--- a/fs/proc/meminfo.c
+++ b/fs/proc/meminfo.c
@@ -18,6 +18,7 @@
 #include <linux/cma.h>
 #endif
 #include <linux/zswap.h>
+#include <linux/trace.h>
 #include <asm/page.h>
 #include "internal.h"
 
@@ -108,6 +109,8 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
 	show_val_kb(m, "Slab:           ", sreclaimable + sunreclaim);
 	show_val_kb(m, "SReclaimable:   ", sreclaimable);
 	show_val_kb(m, "SUnreclaim:     ", sunreclaim);
+	seq_printf(m, "Ftrace:         %8lu kB\n",
+		   ftrace_buffer_total_size() >> 10);
 	seq_printf(m, "KernelStack:    %8lu kB\n",
 		   global_node_page_state(NR_KERNEL_STACK_KB));
 #ifdef CONFIG_SHADOW_CALL_STACK
diff --git a/include/linux/trace.h b/include/linux/trace.h
index 7eaad857dee0..f9935231560c 100644
--- a/include/linux/trace.h
+++ b/include/linux/trace.h
@@ -53,6 +53,7 @@ int trace_array_init_printk(struct trace_array *tr);
 void trace_array_put(struct trace_array *tr);
 struct trace_array *trace_array_get_by_name(const char *name, const char *systems);
 int trace_array_destroy(struct trace_array *tr);
+unsigned long ftrace_buffer_total_size(void);
 
 /* For osnoise tracer */
 int osnoise_arch_register(void);
@@ -92,6 +93,10 @@ static inline int trace_array_destroy(struct trace_array *tr)
 {
 	return 0;
 }
+static inline unsigned long ftrace_buffer_total_size(void)
+{
+	return 0;
+}
 #endif	/* CONFIG_TRACING */
 
 #endif	/* _LINUX_TRACE_H */
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 01a5e87af299..f0bb553e3688 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -5769,6 +5769,36 @@ tracing_total_entries_read(struct file *filp, char __user *ubuf,
 	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
 }
 
+static unsigned long trace_array_buffer_size(struct array_buffer *buf)
+{
+	unsigned long size = 0;
+	int cpu;
+
+	if (!buf->buffer)
+		return 0;
+
+	for_each_tracing_cpu(cpu)
+		size += ring_buffer_size(buf->buffer, cpu);
+
+	return size;
+}
+
+unsigned long ftrace_buffer_total_size(void)
+{
+	struct trace_array *tr;
+	unsigned long size = 0;
+
+	guard(mutex)(&trace_types_lock);
+	list_for_each_entry(tr, &ftrace_trace_arrays, list) {
+		size += trace_array_buffer_size(&tr->array_buffer);
+#ifdef CONFIG_TRACER_SNAPSHOT
+		size += trace_array_buffer_size(&tr->snapshot_buffer);
+#endif
+	}
+
+	return size;
+}
+
 #define LAST_BOOT_HEADER ((void *)1)
 
 static void *l_next(struct seq_file *m, void *v, loff_t *pos)
-- 
2.34.1


