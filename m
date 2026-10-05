Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C878CA5FCE
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 07:06:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 035EA6B0098; Mon,  5 Oct 2026 03:06:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F29306B0099; Mon,  5 Oct 2026 03:06:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E179C6B009B; Mon,  5 Oct 2026 03:06:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B98776B0098
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 03:06:41 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 543A3140157
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 07:06:41 +0000 (UTC)
X-FDA: 85287689802.25.8EBAF0F
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9302A2000A
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 07:06:39 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bREG3I0k;
	spf=pass (imf13.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791183999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xfZ3u+8kppu334roBh57uG8qfuX2GjTQB+h2l+yzJBo=;
	b=c/dHPCAAQbBnAfFGiqJtrOKixnzs71/UxnHD8LIJo0e0EOc39yQttqeyOGZ/7sz0+OpBbq
	Rngy+7hIakwyn6LAfbsog/VKmjTftRzMy7Aricu7+2AtrBanRpW9vrJP9cil3qmk05xsCw
	lFC5DBUOAMVGTBBxEVsYSAimAuQ+hus=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791183999;
	b=tFwT4qtDMm5vuTkSbkJMo+Ruwtp4O+DBWntax/SgABVKgSHEulD7txCl7W4/BgpV/nGmCX
	P9cYE8Lfka0qL4No+I65+RyOIBSQSVsV+z/KrwTBf0LC05O3R/uEArHveqxY+D8SUNNgCE
	+usVHP8wpO/p0bVs+F2dea3kRz2y/Tw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bREG3I0k;
	spf=pass (imf13.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49fff72474fso9364055e9.3
        for <linux-mm@kvack.org>; Mon, 05 Oct 2026 00:06:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791183998; x=1791788798; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xfZ3u+8kppu334roBh57uG8qfuX2GjTQB+h2l+yzJBo=;
        b=bREG3I0kv6na28LRDtKD/1knpqokX0yroDukUHHR32ktliBVTqRKH47Bce2wuX6KWa
         DEL0SSkhz1dkstYUw1YyI4O2KVsHGxaUGMwjYjZc/WsAj28jVQkTLL2HLW7OygGDRb6P
         aj0tOddCTEl65Y4BILU/QmxAKytdZYki6WYYEK50bCcrsaO6bL9AJMxYhWHCM9sUUw7I
         fRAlHSIZTZIiBHGOfklhd4ymhV/y2B+6lKwL7NL3cFpIFNo1mjmrfirW8FtyQwaRBNol
         o9XcXEdAiQPDI+0V9HF8ZSe3nn+N4IVZTgdiZGsP4QvTsaDUgAvQs0uvlWsBm2PRDB3Q
         fesA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791183998; x=1791788798;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xfZ3u+8kppu334roBh57uG8qfuX2GjTQB+h2l+yzJBo=;
        b=jw1ONTIMMv2H7ObWPJsZcEHXXqFC8IpIOLRek5O+Pzi83c6J09RhcJZYhFUQyvt5B1
         wjaOBu/aznxkRm/xVlI0Xoq3wei2Np8+tKLy4OCWi1MG12qYvgRbR/QejQ5EGaek8jSW
         C9XX7Fnhx1P09gYltm4+TEIHG/9bRvs8aYur1XT3+QYgPYg83CFMYmL4V2u6DEOdI/iB
         ZL/wMxoVhhYXG6xK3OocI/kkrmBaJLfZNrLmbU3AMieVJapypNSgo0bHJd9I4rxIgG13
         POmjgzPMRyDPg+VcnAfY4TE1baaRmy1ClIlmcMkLQq3C3VKc7cl509uFv135pYxjyfmo
         x9/A==
X-Forwarded-Encrypted: i=1; AKwUvBzJIF+sOvwr2T/wKctL4WvhiDs2VhdmfMAu2nptavY5qRaopB7V8rqylwatp1bSM+mcLFIR5TB5kw==@kvack.org
X-Gm-Message-State: AFuF++kzBQPzCxC6HP4DD5bts0wMmb+M5ogayUXZSNNk8kEc/nC2zORF
	76cOkBpRe4xHSJgKw433k5mXg7c3WyJEoaHA3D0zbZnf0g1WuCyERzwb
X-Gm-Gg: AYBFou3XE0MIaf4RpBPqPYsevC6NcVtVTG8nFdJHInRjSgFP6gzLs6Jx+f691PHc9PF
	Z/8EGg/gVk6/DOFkKtgVI9OFopuLyFYZAyRJ7OE6BZLIVLlon5YSxX0csx4Vg3RRUPyKFPCu7YB
	pq7zOzLwg1lHX+C3LXW0Wj1pd0xKv0L8EJLjc6HP2pr8ZRZxRJ1yE0Gj3EQjd8gD0I+pfKveFql
	G43gjKUJmgrrLtyMIbsUQ+7qLy6vLHgwkfetdh5MntggwkcNbDMLEiwG2iIMSE5pgu8URh5VvWm
	HPN9UsQK43Txu8swa7WjKzL0TGX49u8XJTC/OGc8k9mdoHfsZPnwvNV2DrSslHbLGbp0K7vE/QW
	ep9Wk18JozlQ8r8TimjaJvWmW965WquOBXfrUluM+iu2PkuJMjDK/+giQKWQxGX0+p7dM63OqsN
	QSVxRjCF8FZB0kA49T0NYsqEIS6OOxTQp6gW8Uea/EzY5P/0Er/y661P7HD/tOziypuxgaimQf1
	2S1N8EF01THrn1i/TeoVv9v407/0FQd5KQkoDvULNjZJF7GrwUmfElKeGIQR3mDfE97JisoPraW
	6jFakK6pqJki0FUl+zKfi4+aLOEv3r70yYoA3wGHOoT7YWsdbqUAESujjxGdBcyPAYmJuYYViVY
	YVw==
X-Received: by 2002:a05:600c:46cc:b0:4a0:258a:8de4 with SMTP id 5b1f17b1804b1-4a0274e9c3dmr145299735e9.4.1791183998159;
        Mon, 05 Oct 2026 00:06:38 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-b305-2001-39fa-3d24-821a-4eae.310.pool.telefonica.de. [2a02:3100:b305:2001:39fa:3d24:821a:4eae])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a16bcb9a21sm283461465e9.10.2026.10.05.00.06.36
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 05 Oct 2026 00:06:37 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Waiman Long <longman@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	David Stevens <stevensd@google.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Shuah Khan <shuah@kernel.org>,
	Amery Hung <ameryhung@gmail.com>,
	Swaraj Gaikwad <swarajgaikwad1925@gmail.com>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	linux-rt-devel@lists.linux.dev,
	bpf@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: [RFC PATCH v2 3/3] selftests/bpf: exercise task storage from hrtimer_start
Date: Mon,  5 Oct 2026 09:06:25 +0200
Message-Id: <20261005070625.8871-4-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20261005070625.8871-1-kmehltretter@gmail.com>
References: <20261005070625.8871-1-kmehltretter@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9302A2000A
X-Stat-Signature: 9d9pa4jnqg87dza9th3j61tpgok7qudf
X-HE-Tag: 1791183999-553023
X-HE-Meta: U2FsdGVkX19cnIDPmbniokC6SnrB/MzWpQusrQ87qChqYNMUVO1k0CXQR5vZp+fjsk1KDqMIeC8f130CT8KMf4RkF7A5p9hYGRjsrImvQSluim0XlUlaUciVNw7XdHE6PsBtKfprfD3Rav5tNAk+9eUdTXosC41z5XFFRPJJnuNWu2vaLzwnE4gbgfqLLlaP2OUbdbERC6b0jZLXPz0F94+qNCl77qAqehmEKEhhtohdCpKh2o03FhagDNkTGsP+zkwQ4G9WjHCOBgcPfJc9f4ATWWyOetA0a1+6QH+7qJKuq5j7yD+NGjX6vCL2t4HwInPP5LVLuncYnCgivRARunvW2dFz5M8ZcyDxTW5CtM+LEV7vi6Iah1Kx40IRGqm3J5YPNjMWq6GD8n27DW2yodICi3PiFEOMOYgaw9LPYPXe6U5Y+q3ed8y4pixgMDV/KeD9+t0bkP57fqaLsliA0521YA83bX7NzrF+rRN8Zp9MuA3KMM61/3Hb+cLUMLDsPF02F4YJxfOWED75fT3fnL5321aWZVQcCVcVwRbhsEna4Vl8dCN1jtLhGK0cTVpX8xU4Vdm1ChTdoVQG63eygzjFz00Cns8dGS5hjq4hpZZysw97taay1nMsws9MbIO5fHqOumW1WGPw0GCX2ILCwJXk15dOAq5MjnQIGpkfOagHjiXFRCNWJtnzaLgRX8vwlKYcr0+LO+t5ATqipIKPEYJMC5rG6AzPWo5v9qU2gfZg8DIlsCAAj83m9jgyVTRZx3Jqmq4RwHtPOrcBQ0MiH2yLZeEqmzK1ON71Ky9hBq3qAA05/NOcnGx65JbtYlOmwieiDtp9Pm8KIo6X821BiTzt/sw/PajSDdK6r/HqByK4t4zFGPtRPC1Rs+yspB2HEhMexTTssbJ9vJnYuS4E3vii4kAt1AlgymCLABntmfiNpjffjwDfgzolnSzso0qWjqs9V1dhfNREFGp5Vu+
 ZgEt7s4K
 Ot6yUXwDzEEJVBrX+6tlaZcmoUjC1fFl52DwGUpBiHp8bQOvHimaN9JqaKydWSnMJdqTgkrghey/YZRBDw6d4TEOtYHjomGSR7upQ31RHy5+zvfyaRqkl1UvMSw15NIW/yMJG8wJbI6ibL6sSr3abEvtZ8AU/ZyKKp+cW1BTUCsFjvTN8HHrsufgSkF0MvUugNVNLyLiH7vSFdRe4ar6DGsqsteUmHAqvQ0xCMnfFoLi9x4PHh2r1s40nPznkSzdPuzfYyMzOwrk55Qx/GrpMpDktiVh49DxkQVrcJajhlRrHDEzg2iFU+MAsHwPI0AZZsXJNPvwz7o7LCXQ7ml0KLR8MUVTc1yA2Q7x+0TEv1fgm1R6mI92bEJFEgb24q8b8zULkExtM1rDPgURj/Wkl97niTNpRt94fYB28s4YJHHYvths2LqxEVUAuNBx+uWjeRLgE7XxPJM4Ui2mnyAY84Qgksg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

No BPF selftest creates task-local storage from a tracepoint which runs
while an hrtimer base raw lock is held.  On PREEMPT_RT, this can exercise
allocator rtmutexes inside a raw-lock section.

Attach a program to tp_btf/hrtimer_start for the test process.  Create and
delete task storage on every event and trigger 1,000 events with
timerfd_settime().  Detach the program before reading its counters, then
require at least one successful allocation and balanced attempt and
outcome counters.  Allocation failure remains valid for the best-effort
no-lock API.

Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
 .../bpf/prog_tests/task_storage_hrtimer.c     | 50 +++++++++++++++++++
 .../bpf/progs/task_storage_hrtimer.c          | 48 ++++++++++++++++++
 2 files changed, 98 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/task_storage_hrtimer.c
 create mode 100644 tools/testing/selftests/bpf/progs/task_storage_hrtimer.c

diff --git a/tools/testing/selftests/bpf/prog_tests/task_storage_hrtimer.c b/tools/testing/selftests/bpf/prog_tests/task_storage_hrtimer.c
new file mode 100644
index 000000000000..216e66263bf6
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/task_storage_hrtimer.c
@@ -0,0 +1,50 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <sys/timerfd.h>
+#include <unistd.h>
+
+#include <test_progs.h>
+#include "task_storage_hrtimer.skel.h"
+
+#define TRIGGER_COUNT 1000
+
+void test_task_storage_hrtimer(void)
+{
+	struct itimerspec timer = {
+		.it_value.tv_nsec = 1000000,
+	};
+	struct task_storage_hrtimer *skel;
+	int err, fd = -1, i;
+
+	skel = task_storage_hrtimer__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "skel_open_and_load"))
+		return;
+
+	skel->bss->target_tgid = getpid();
+	err = task_storage_hrtimer__attach(skel);
+	if (!ASSERT_OK(err, "skel_attach"))
+		goto cleanup;
+
+	fd = timerfd_create(CLOCK_MONOTONIC, TFD_CLOEXEC);
+	if (!ASSERT_GE(fd, 0, "timerfd_create"))
+		goto cleanup;
+
+	for (i = 0; i < TRIGGER_COUNT; i++) {
+		err = timerfd_settime(fd, 0, &timer, NULL);
+		if (!ASSERT_OK(err, "timerfd_settime"))
+			goto cleanup;
+	}
+
+	task_storage_hrtimer__detach(skel);
+
+	ASSERT_GE(skel->bss->seen, TRIGGER_COUNT, "seen");
+	ASSERT_EQ(skel->bss->attempted, skel->bss->seen, "attempted");
+	ASSERT_GT(skel->bss->succeeded, 0, "succeeded");
+	ASSERT_EQ(skel->bss->delete_errors, 0, "delete_errors");
+	ASSERT_EQ(skel->bss->attempted,
+		  skel->bss->succeeded + skel->bss->failed, "attempts");
+
+cleanup:
+	if (fd >= 0)
+		close(fd);
+	task_storage_hrtimer__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/task_storage_hrtimer.c b/tools/testing/selftests/bpf/progs/task_storage_hrtimer.c
new file mode 100644
index 000000000000..a53c966f15b5
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/task_storage_hrtimer.c
@@ -0,0 +1,48 @@
+// SPDX-License-Identifier: GPL-2.0
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+char _license[] SEC("license") = "GPL";
+
+struct {
+	__uint(type, BPF_MAP_TYPE_TASK_STORAGE);
+	__uint(map_flags, BPF_F_NO_PREALLOC);
+	__type(key, int);
+	__type(value, long);
+} task_storage SEC(".maps");
+
+u32 target_tgid;
+u64 seen;
+u64 attempted;
+u64 succeeded;
+u64 failed;
+u64 delete_errors;
+
+SEC("tp_btf/hrtimer_start")
+int BPF_PROG(on_hrtimer_start, struct hrtimer *timer,
+	     enum hrtimer_mode mode, bool was_armed)
+{
+	struct task_struct *task;
+	long *storage;
+
+	if (bpf_get_current_pid_tgid() >> 32 != target_tgid)
+		return 0;
+
+	seen++;
+	attempted++;
+	task = bpf_get_current_task_btf();
+	storage = bpf_task_storage_get(&task_storage, task, NULL,
+				       BPF_LOCAL_STORAGE_GET_F_CREATE);
+	if (!storage) {
+		failed++;
+		return 0;
+	}
+
+	if (bpf_task_storage_delete(&task_storage, task))
+		delete_errors++;
+	else
+		succeeded++;
+
+	return 0;
+}
-- 
2.53.0


