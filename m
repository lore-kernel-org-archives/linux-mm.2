Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D983C531EA
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 23:37:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AA946B0005; Thu, 19 Feb 2026 18:37:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 658606B0089; Thu, 19 Feb 2026 18:37:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 564476B008A; Thu, 19 Feb 2026 18:37:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 404C66B0005
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 18:37:17 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C5F9E140943
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 23:37:16 +0000 (UTC)
X-FDA: 84462819672.30.5A7218B
Received: from mail-dy1-f201.google.com (mail-dy1-f201.google.com [74.125.82.201])
	by imf19.hostedemail.com (Postfix) with ESMTP id 19A511A000B
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 23:37:14 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=LqitZZjL;
	spf=pass (imf19.hostedemail.com: domain of 3qZ6XaQsKCJgC2D6K9KAF898GG8D6.4GEDAFMP-EECN24C.GJ8@flex--kaleshsingh.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3qZ6XaQsKCJgC2D6K9KAF898GG8D6.4GEDAFMP-EECN24C.GJ8@flex--kaleshsingh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771544235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=fMf1qxcGK6Wxv/U+V8Of3DjwHpI1qGbRPjrj7xoTTd8=;
	b=kQ4sne7QV4PChhoQzCSPm9HA+re71vrSdP5JsiKVeRunaxBODfGPpNHrhPS2P5EWXPFXdH
	qYQ9JuYVUmOSjquTUbeLgKjCI+x09JtQrwY+5PIqwt3yHWRTPH4gX/OGOv0SjJU+eBoSHi
	c4+H0t3zjMYSk/nr6q3cizhMksaZKYg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771544235; a=rsa-sha256;
	cv=none;
	b=gqhTEhLedKxR9QdNB9/BSA4H21Bx7s3i9lsFjnNzjtrCmKyi6ZNeU83bIrfUVF3pLeK123
	I604CAE/i/FHBOSnHOUxOzQmJ2Ez5DmxM9vVzlkoboxpSuG18l1B+oNuHxadLMRbyfHg3v
	SV7+R8Biu2Awhu0CN6ZEsY4/ZJeTCBE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=LqitZZjL;
	spf=pass (imf19.hostedemail.com: domain of 3qZ6XaQsKCJgC2D6K9KAF898GG8D6.4GEDAFMP-EECN24C.GJ8@flex--kaleshsingh.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3qZ6XaQsKCJgC2D6K9KAF898GG8D6.4GEDAFMP-EECN24C.GJ8@flex--kaleshsingh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-dy1-f201.google.com with SMTP id 5a478bee46e88-2ba8013a9e3so1678497eec.0
        for <linux-mm@kvack.org>; Thu, 19 Feb 2026 15:37:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771544234; x=1772149034; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=fMf1qxcGK6Wxv/U+V8Of3DjwHpI1qGbRPjrj7xoTTd8=;
        b=LqitZZjLpf2L0eM4aNhVk84CFPHOmtc1sdd8Ibo96PvU+OLmMM67nyTZ2Z2SZVJ1Rl
         0TIZFKwBUZRB7KPDW616G6tJSHMjEBzZ21Jr9rnihnhxvKTLXjJiujcx8N4SUQga6OTC
         3QPCfaf6Ot+YYN96oVw/jlsfmWFsFIprab5+CU1XLBDYJp8WTBjBJd5jtX1mnm0uU19g
         IxPlwhIQskBfgaP3/JEu2M2nnPomCUGxhIKUu1ovVrvfJ/Ev5knNjj/tO4Itlk4wbHdl
         UJvxYUI14lVc1v92BvP+SjvjdhfmZL4ihWgftwDIR4H+rAz3yD97rApEl8VT9UTEx5cj
         XYfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771544234; x=1772149034;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fMf1qxcGK6Wxv/U+V8Of3DjwHpI1qGbRPjrj7xoTTd8=;
        b=McHA+pLj60JVUcbo60T9a3Zn2LqvPGvIWfcaVgLQLCZfNsYj4D/b53EQkgoWKSGF6V
         ummGgXS/aEuq1gk+nag9DMBtaxj0MEtMUl/Fhb/TQenK3kvzSRd97J6Ynqubq9vV3amT
         XB0b+QuaF54sknNgK9rou75oJxEXL3JwUlZG1d/JZBMVsWLDLI6m8gFusrrWAm222T/p
         uh9S3NtZPFPxBsgSkIlegk/LYYFXtglcwGdwbREBklIR+WO2j33lfpla2kwj1iFmhjK7
         E2XxNC6WLJFIdI0fgoflBTiK6iXa1mfa7ThDgYmuAm83xK7JQ3k3tkqasKEwRFjVkct+
         WTOQ==
X-Forwarded-Encrypted: i=1; AJvYcCWgCf8gDVmCifK82LKuDHYzasZRMbWOENKuKVyrBgQfD6R7itIxvPrkcPIbILSuXvg71Ob6OHsteg==@kvack.org
X-Gm-Message-State: AOJu0YzdqeLY5nMqhynIRefsU8wfpf6s8BU4bap3rCzM72oo4fsxqF1u
	MbLX+lYIxRfGjR4ktQsg3YeItCCyULb8dBirQ8iHFzZ051NJ5Jxg2CGXTgBT5Uk7zTLRJw45QIN
	ZF7ztL9E4ATL4hxhf8eAZarpdTg==
X-Received: from dybic28.prod.google.com ([2002:a05:7300:c71c:b0:2ba:8e16:e465])
 (user=kaleshsingh job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:693c:3108:b0:2ba:6854:8d4d with SMTP id 5a478bee46e88-2bd501701e4mr3357396eec.20.1771544233484;
 Thu, 19 Feb 2026 15:37:13 -0800 (PST)
Date: Thu, 19 Feb 2026 15:36:56 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.371.g1d285c8824-goog
Message-ID: <20260219233708.1971199-1-kaleshsingh@google.com>
Subject: [PATCH] mm/tracing: rss_stat: Ensure curr is false from kthread context
From: Kalesh Singh <kaleshsingh@google.com>
To: akpm@linux-foundation.org, rostedt@goodmis.org, joel@joelfernandes.org
Cc: kernel-team@android.com, android-mm@google.com, 
	Kalesh Singh <kaleshsingh@google.com>, "David Hildenbrand (Arm)" <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Minchan Kim <minchan@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, Martin Liu <liumartin@google.com>, 
	David Rientjes <rientjes@google.com>, Zi Yan <ziy@nvidia.com>, 
	Wander Lairson Costa <wander@redhat.com>, Petr Mladek <pmladek@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 19A511A000B
X-Stat-Signature: jp1dau3heyphytifkhjuck7jmznyc4ok
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1771544234-294247
X-HE-Meta: U2FsdGVkX1+cL30jIOL+ksG26R2lsjcTdikuv9g+G1lv2x1uKB5wmGVvQAEnPY3DZ9g0s0TMRtqVWtmY8Rc39NxCzlj2PjUN4DRFXGt7psjnL580iGZJoyIJhgyEk1NLMuxQCcfVNY9z+o8qms97902bs2ig9qe+89YRdzMO9VYScJR11+2ZY8AA9IGZLDI13649vbeHk2TqRNqrcqFa0Du9WO0S2ScwYHCVSV3AeAXjxi8m8SwRzbPQ2hMCwxUPHOIEdfWrCNMBo9syr+O194AcIaQyxn+2PoTPUNuVgYhvyt5RdZ1EVMF06rR/8OKhrV3XyoYnrPeBmCbatw0hYDuR4tlvTIy2Y4IuDAVoFS1jGrjVh2hbCSryDpGk74buaq8WzkYoCNC26hz+qs1u3HSMzrVoBroq1ei5gnd/SEC9SSvGxufkJQs7prNB2ZpkOTRvvkUrM8eCpprcUg9OK8Y+sFVM4xC60q32pBidWiW6R1+vHKEOqsFT/imVtBqiNDtUsUCLsfRlsprnuHLM5otDMIlpC/G381gc9UpCig6I/Y3Qs0Sm17UJvmQ0k8XkcVzuONVoW5W5nDQrYuTpLZNj8a1p/R9ppu0J9J9xr36CHhoOBHaax+pcARt2Vq6csvUp/1aj/w6gCrfCjYOhyClYdqpKUS7r5hBVCm7gzyqiknGeNMrO86My+PFqjtgxCyEBleSIbCbklv8U53UJtPKMf+zakt3wH5qRjSKdaIhd3UCu5/ksbwxgcCavxUczOVnaT14droH5eYJxhm6O42aygNzA5aSCyo7oUa62egaQptOJV1Xs0tDGsMq1ostk1c8h0LBbSFtAvM86+oIsoBsts9dyxKjFFJu5ccSAOq0zbmHnA90Rla3YTqsqkd7jSGH1J9NRloksTw8Eg4ra85g/WW93M5eCapCvE0ki7etJzPDp0OsuvNqhr3Q8hGIBBcIXJy6HgIA5+NY8/SD
 PyH6qexP
 VvfFYbSoeYmOYfG2L37gjk+yJ9ZXyIObL9fsdvckPP7aCPsInlK4MVNZndvv6jxGzb5IcCibiSGP/HBm54P+619VjTFmHgexmPDUk/I94dOBqE72Y6tZmjOoWJU6lTPMydurtm6ckI9pk2cdYn/VQVAEL+3YgOnyD81yY1sPf6Xmd7JbRnXq404QOYraPtmfhI0rVSxnCvxKT289wJnAzEC6Ez1FGIk9pWt091zuCYvm1RlT16EY654XHUoPjHAb+kMpwC7u8VKc6KJUVunCwYWkXJO7QQVh2r9cUPeq5gf5df1DT7dEYqChRSNc2p6UxdfVeKIQZEcmqUaTQQTLUDplELN8CzsnnF+QNqsGRVZmIjfYfm7F8O371lObGfSz6IZLwbt73FcPg22o4wbJj7u5QdNdOf3Ov13tuR1ObnyU9bCg4vxrA2m1DTBfxfKylF9v/ZVlwtXCpVCq2FvZ9ZZEy3lEGn4Prr69zThbdgLWNkxiPn3iFC+Qv+XZi6AQ3WxlK2AbdlvSsf6GrbRWazYBN3yMXlxhTKGiPF6hqvN+AXZxhlUMH1lGBGFntvihjQrIV02v8nEwG/SCKjh3hZV0DM3Wt1k/P4IPHEbu9NqkkHl0/b2mNP3LA3+V6ZzfUP0OMp+gRYwuLga8+WIxpmBboHvWiMlYxQ+lMXnmK9ldud0qZw5ko+mM8M2Tq1rtoW99sIUU5aElFuq/1QbTaltaN1THNKsvLs1Z/GDNZIpYP+21KvdkL9662BeCPWt5JGltTp5e7BOZXC0ly+3dmJX7r4qMp4UX3cgsWkHRecE88Uw4HnPfc+rDRm2j3EHI6C9XAAUWeSoFMuRXhULHCRDo3p4unMYmVb6rBoShF5EiNCK/IptfLp6vLBHX77XkhoZromZPdT4SU4ZTMJ/eI8iBc2I7/Ogn72Sl9jZijk6UeBX3QuCFIWApX5Y+MVDUKhsYNwf0Z2/DUNpYLOjX5dmZuhTiH
 8nR4N0wU
 X5dMz2jvpFhHOdEadK1JOA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The rss_stat trace event allows userspace tools, like Perfetto [1],
to inspect per-process RSS metric changes over time.

The curr field was introduced to rss_stat in commit e4dcad204d3a
("rss_stat: add support to detect RSS updates of external mm").
It's intent is to  indicate whether the RSS update is for the
mm_struct of the current execution context; and is set to false
when operating on a remote mm_struct (e.g., via kswapd or a
direct reclaimer).

However, an issue arises when a kernel thread temporarily adopts
a user process's mm_struct. Kernel threads do not have their own
mm_struct and normally have current->mm set to NULL. To operate
on user memory, they can "borrow" a memory context using
kthread_use_mm(), which sets current->mm to the user process's mm.

This can be observed, for example, in the USB Function Filesystem
(FFS) driver. The ffs_user_copy_worker() handles AIO completions
and uses kthread_use_mm() to copy data to a user-space buffer.
If a page fault occurs during this copy, the fault handler executes
in the kthread's context.

At this point, current is the kthread, but current->mm points to the
user process's mm. Since the rss_stat event (from the page fault)
is for that same mm, the condition current->mm == mm becomes true,
causing curr to be incorrectly set to true when the trace event is
emitted.

This is misleading because it suggests the mm belongs to the kthread,
confusing userspace tools that track per-process RSS changes and
corrupting their mm_id-to-process association.

Fix this by ensuring curr is always false when the trace event is
emitted from a kthread context by checking for the PF_KTHREAD flag.

[1] https://perfetto.dev/

Fixes: e4dcad204d3a ("rss_stat: add support to detect RSS updates of external mm")
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
---
 include/trace/events/kmem.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/trace/events/kmem.h b/include/trace/events/kmem.h
index 7f93e754da5c..cd7920c81f85 100644
--- a/include/trace/events/kmem.h
+++ b/include/trace/events/kmem.h
@@ -440,7 +440,13 @@ TRACE_EVENT(rss_stat,
 
 	TP_fast_assign(
 		__entry->mm_id = mm_ptr_to_hash(mm);
-		__entry->curr = !!(current->mm == mm);
+		/*
+		 * curr is true if the mm matches the current task's mm_struct.
+		 * Since kthreads (PF_KTHREAD) have no mm_struct of their own
+		 * but can borrow one via kthread_use_mm(), we must filter them
+		 * out to avoid incorrectly attributing the RSS update to them.
+		 */
+		__entry->curr = current->mm == mm && !(current->flags & PF_KTHREAD);
 		__entry->member = member;
 		__entry->size = (percpu_counter_sum_positive(&mm->rss_stat[member])
 							    << PAGE_SHIFT);

base-commit: 8bf22c33e7a172fbc72464f4cc484d23a6b412ba
-- 
2.53.0.371.g1d285c8824-goog


