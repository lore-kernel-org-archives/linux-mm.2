Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DB0FD25922
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 02:45:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B60926B00AA; Mon, 26 Jan 2026 21:45:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF5856B00AC; Mon, 26 Jan 2026 21:45:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D3B56B00AD; Mon, 26 Jan 2026 21:45:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8B9BB6B00AA
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 21:45:16 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 56327C23CE
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 02:45:16 +0000 (UTC)
X-FDA: 84376202232.25.007EC4E
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf19.hostedemail.com (Postfix) with ESMTP id ABE921A0003
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 02:45:14 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TLpEx4wa;
	spf=pass (imf19.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769481914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z3nsZCHloDjEFT63wrJPNHkkbtPu1NO+p+ag9oOS/4s=;
	b=JE1fWy8UHcbF2Qf+OsnW3dMMKiQNDmn0Nv//RZMzqJZRKKrQVG3dXYzeGe1uo4Tw8VBCRG
	Ezk2qsHxoUseYCZ2YERTdy5vlyPkf9hB7hegrMOrp6WMDIiDbZU7U97Lb/IRxRJG3Wuid4
	USNq+X3CFW2vrjjxPggP+A7VSoBEnYQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TLpEx4wa;
	spf=pass (imf19.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769481914; a=rsa-sha256;
	cv=none;
	b=vFme/iH2PC8qovl32LhSMn8q3tKkGvdcRXATd9DiY50QSzXKOHOvl6B33srsY07HgHvVTu
	0I6XHBtqjJ3IGklRw53oHyvsYK9McMBkSnykrnPAvfYNh32QSsezVnzdWckuqaJLbDdIXM
	r/2EkeTMYQZEiZbfBrLVBH1L/pmZ7xU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769481913;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z3nsZCHloDjEFT63wrJPNHkkbtPu1NO+p+ag9oOS/4s=;
	b=TLpEx4waOFjLCEtMyKYbSF7YnojCZxnLYrXP50WDo8bqSLwGFx/HZiKKsCkbSGJDWbHBeu
	x9hp2U81qFGa0LwaEVL+Y6HlGMaqxJCmDlfoIAvobc8Box8efuEi1XBeRL8orFcrYoTtr5
	qO+DZmBfWe2+lrYYtWn3/FpwVcs1lgQ=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: bpf@vger.kernel.org
Cc: Michal Hocko <mhocko@suse.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Matt Bobrowski <mattbobrowski@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	JP Kobryn <inwardvessel@gmail.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Suren Baghdasaryan <surenb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: [PATCH bpf-next v3 13/17] sched: psi: add a trace point to psi_avgs_work()
Date: Mon, 26 Jan 2026 18:44:16 -0800
Message-ID: <20260127024421.494929-14-roman.gushchin@linux.dev>
In-Reply-To: <20260127024421.494929-1-roman.gushchin@linux.dev>
References: <20260127024421.494929-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: ABE921A0003
X-Stat-Signature: cdpdyw4gwm66knzhufq6xso5hpd8mspj
X-Rspam-User: 
X-HE-Tag: 1769481914-336519
X-HE-Meta: U2FsdGVkX19Md6PO3IRTnPinZhwCIdEMgDhLyFsZQ2OIfgqz8CadAq7iJdXVPN30hU/lE0DUtAl6GeU9KRi0DUX31XfH7Bih+o2L3Vqfj7nYRsrPJsDCCS4lLSvqv+OGYCyRo5ADaI+u9OIPAmb+Z1+KETrTU2FUXiKocKC0MaIbqn0jRnafT5W1V7oC3OfLzJPFAvRX/3TNmNenUYjsjVDWftc7vWx7tpzTuuMhvgS++tAMQzagcduBRWsQ5JFdPtScoPIxum5VUHiUdbJlMcJ5+KO5w5bKLI5ZB6DrSQbp3OWBC2bmSBW5enwt5e8j/r2EkTo4kc/fhKTLAHVqphIS2KqLf9uLIJPnd8djultuaCCqJl2j+uNrlMai69ft/xYjqC3PJ6kG5L+6U+7Q7vE8hKzPfO8yG5DUvmwm0CWfekwfAGsTzpIsgbchL1ZvmwQCeo1k7+zaHAiypptLn5vWQx1uKBpT6wb5eHUNvmyQQOV5n9eYYVnG9CKILO0rKLRlHNlvzQ6wqwI1CMTDWubz4uEdqqETMwOYzO2yeKP8b6VW30WfKWKw60Cvqx9dzxvsUohDi5KSifVepUx2AOpZy/erv7aOxsmNPPlFoghUTdmiWITzvy4voFQcIpLCvLSn0nIpy711yoTtygRDuNPlwaoflBRbuygl4AtfIy7JVs3RSHIkz2FN7HuCy7yEbSIOV8Bue6/47LA12K3ki69UtM9+4CypJn2euXg9hrLOfaILpFNT6seUhLQxGeY6tILIxfuY4vqp4IpM1nyMDTAwNht3/bLavnbwbf+9cr6xx7QQNUL1zX+nYtYKNYpI8fqkXgHT9euo2liHIoXOfP8wPoNNvUVvuMgOMYdvgLmOejVXK/YYLivXoQTOi2acafcpjlzNEL/3bMbWrMvUyUBYRIU1SYMCkJSsbmevr5fdmH9BkQxzB4cETOyM8N5kiIKYeLzlMoVIHQHEQMc
 HusLrQfa
 WvfldVVBYKpqTgO7kMo1xl2zVM8lw0IJfqHxinAtbTAyjXiRqIFtgC+NFqy27xSmGPtdXPrZxXOWofyaRgu0/aGlR9PVzRyC6S3Qg+z79G3NdI+5QBBe0dSXQslVpprVihqDe858W+fts1/XZKPvHM4obodXkThWzTNsKzbl2yS2qHcBTzhHB5oYL7VdtTf++xDmSH+paACDmGLTNQKSpQRHf+Oy4wjFWS5fdiFwr9of5eyVQ9g1NaTi58vp0myMUxkChS7rf2iuz27905ivxUxBPOg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a trace point to psi_avgs_work().

It can be used to attach a bpf handler which can monitor
PSI values system-wide or for specific cgroup(s) and
potentially perform some actions, e.g. declare an OOM.

Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
---
 include/trace/events/psi.h | 27 +++++++++++++++++++++++++++
 kernel/sched/psi.c         |  6 ++++++
 2 files changed, 33 insertions(+)
 create mode 100644 include/trace/events/psi.h

diff --git a/include/trace/events/psi.h b/include/trace/events/psi.h
new file mode 100644
index 000000000000..57c46de18616
--- /dev/null
+++ b/include/trace/events/psi.h
@@ -0,0 +1,27 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM psi
+
+#if !defined(_TRACE_PSI_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_PSI_H
+
+#include <linux/tracepoint.h>
+
+TRACE_EVENT(psi_avgs_work,
+	TP_PROTO(struct psi_group *group),
+	TP_ARGS(group),
+	TP_STRUCT__entry(
+		__field(struct psi_group *, group)
+	),
+
+	TP_fast_assign(
+		__entry->group = group;
+	),
+
+	TP_printk("group=%p", __entry->group)
+);
+
+#endif /* _TRACE_PSI_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
index 59fdb7ebbf22..72757ba2ed96 100644
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -141,6 +141,10 @@
 #include <linux/psi.h>
 #include "sched.h"
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/psi.h>
+#undef CREATE_TRACE_POINTS
+
 static int psi_bug __read_mostly;
 
 DEFINE_STATIC_KEY_FALSE(psi_disabled);
@@ -607,6 +611,8 @@ static void psi_avgs_work(struct work_struct *work)
 				group->avg_next_update - now) + 1);
 	}
 
+	trace_psi_avgs_work(group);
+
 	mutex_unlock(&group->avgs_lock);
 }
 
-- 
2.52.0


