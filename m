Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5BEECCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 23:56:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19E6A8E00B4; Mon, 13 Oct 2025 19:56:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 127D18E0024; Mon, 13 Oct 2025 19:56:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0B628E00B4; Mon, 13 Oct 2025 19:56:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D7A838E0024
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 19:56:34 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9DBF6B9BE3
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 23:56:34 +0000 (UTC)
X-FDA: 83994753108.03.BD20B2F
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf12.hostedemail.com (Postfix) with ESMTP id BF3904000D
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 23:56:32 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ZaqQXn+I;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of 3r5HtaAsKCNYC2D6K9KAF898GG8D6.4GEDAFMP-EECN24C.GJ8@flex--kaleshsingh.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3r5HtaAsKCNYC2D6K9KAF898GG8D6.4GEDAFMP-EECN24C.GJ8@flex--kaleshsingh.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760399792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nPYU+2umQYN0e1OeO8X1leEMEVeMTLGsEK2ETVKaSgA=;
	b=CFQ9IE4s3Q1UExv5SkdPTXpWygAJ1CzpKYy31Mt1IlNaGca1QLR9Yc/w+MzSWxsxzjhn3X
	gN6EWhi1Zf7wbYmLyuB3s9EVAAOMb4U1zL0ecJ4RqyEacg//03HDF3ua95+tj09b78nd4u
	z3s3IHhQ8zoduzDexeR4bgGRbRu+eGk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ZaqQXn+I;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of 3r5HtaAsKCNYC2D6K9KAF898GG8D6.4GEDAFMP-EECN24C.GJ8@flex--kaleshsingh.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3r5HtaAsKCNYC2D6K9KAF898GG8D6.4GEDAFMP-EECN24C.GJ8@flex--kaleshsingh.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760399792; a=rsa-sha256;
	cv=none;
	b=vrdJBISH0AALShv9uRHiP1gG6iN4SBJZjYyrQL/h4uA3bOgg6X5sd22QlWPjDbu1s+Giv5
	DyDcPR2qmr+BFKMK1H5B1cxE6PPtYDNVXwSA3NX16TVLXeietulOXq0+XxxSHlIvGnCVj6
	wKN54PbkkD+UeTmx5w5M4wb5DpruRBc=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-339ee7532b9so24349883a91.3
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 16:56:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760399792; x=1761004592; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nPYU+2umQYN0e1OeO8X1leEMEVeMTLGsEK2ETVKaSgA=;
        b=ZaqQXn+Ibs7Ye05V56x84RGYWUcH/jP8lim5rc9NGI5lzuihJUIiteszySssTa+dKA
         YVLq1SIlPFkdFt1LUwTh45Q4X4PGqQiu6EV/1XgknPj38MuFws26tJvd++lM8fLEWV2Q
         tctL0V21JDzUj3rlztrYDyypEAtXYn41Vc53IeL69hX+VngkLDmPLqk89FRXST4kOV+7
         43uDJ3Ij6oLNqz+kV2lEIWjhNiRaYUC8zUImTV3AzVTh0WJdbqDBYwvcURFjoWYGCvAE
         krVP+u1yBGCaW/ituZ2q30GPYMibiIRbsejP9NbHc369KfkooyLDXIiET/M3rARsEmAN
         mGLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760399792; x=1761004592;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nPYU+2umQYN0e1OeO8X1leEMEVeMTLGsEK2ETVKaSgA=;
        b=ak7kgwF7cMUXyUuj+46cedK0IZsYtmenWFzyj2w/dvRWSvhlCihadvF+rOxV6dOtmx
         +3puVDuV5fC+aZreaGENUuP5mW/rUd5D/QSmlIC1qL5BrIMKrOKQDtRpGmWvNSx2nk1x
         pJu5l68UpZIJurBYdUR6Xi8SAUmlegcbQPndkUUum7nFPI5qs9jGEmOqx6us9impoGLd
         XCq9obEEypXRnfANydmF5kwJ6E+wYOearLL4C8xGUar3WZOUkLkyOwEZp2kNcxdYXnzN
         BB+ljgZEWtDr1GrW5AcOeLsiSYc5b4nkxRrUSdsTV2i0f+nOZA5Tw4Ybb8kLilZyC+ak
         uAJw==
X-Forwarded-Encrypted: i=1; AJvYcCWZ8hBRuAi78gr0fu/tfkudzhD/T/0cf5qoZz2k2kpTvYQAm7dcTRXYLaaeZ3sJiLpRNSQ5h00R/g==@kvack.org
X-Gm-Message-State: AOJu0Yx617Y8wnELMw3tlwGQLC8994+630mLDbmZgu134b+GF9ssT2n4
	M5EC4rzaJNT2denla0Ln3cDaVh7yDZvXdYlV2cIC0aSDnJqyagYT+VUOr3jX3c/KB3TK0cMgGEG
	I9HPNflgjlqAaVnRwqQo/ugm9jw==
X-Google-Smtp-Source: AGHT+IG8lrB7VX+K9dIOGBRbbEFaAljZfdwJaT5C/S0Dp/zoN1fe4Txo8ye3OLt4nWf6mVkw5tVIPzsscYSebRBbqg==
X-Received: from pjuu4.prod.google.com ([2002:a17:90b:5864:b0:33b:51fe:1a78])
 (user=kaleshsingh job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:4b8c:b0:338:3dca:e0a3 with SMTP id 98e67ed59e1d1-33b51118f99mr34203500a91.16.1760399791496;
 Mon, 13 Oct 2025 16:56:31 -0700 (PDT)
Date: Mon, 13 Oct 2025 16:51:56 -0700
In-Reply-To: <20251013235259.589015-1-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20251013235259.589015-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.51.0.760.g7b8bcc2412-goog
Message-ID: <20251013235259.589015-6-kaleshsingh@google.com>
Subject: [PATCH v3 5/5] mm/tracing: introduce trace_mm_insufficient_vma_slots event
From: Kalesh Singh <kaleshsingh@google.com>
To: akpm@linux-foundation.org, minchan@kernel.org, lorenzo.stoakes@oracle.com, 
	david@redhat.com, Liam.Howlett@oracle.com, rppt@kernel.org, pfalcato@suse.de
Cc: kernel-team@android.com, android-mm@google.com, 
	Kalesh Singh <kaleshsingh@google.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Kees Cook <kees@kernel.org>, 
	Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Jann Horn <jannh@google.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Ben Segall <bsegall@google.com>, 
	Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: BF3904000D
X-Rspamd-Server: rspam03
X-Stat-Signature: diokosirsjhcab3gfufoad9ohbfefh5h
X-HE-Tag: 1760399792-851050
X-HE-Meta: U2FsdGVkX19YBQ/J1LJOoyvYHRq8ypUctt3c40bCcC/agK+cBkHGCNRSYauAWELxSv6GfVUk/lh79CTcbK63vpnX0zPrl+QmPVrnsRm58pWsxWuhFH+upWZ65K8ELyMcegn874BqQmR1TPMPZNrW9UR7HjuG2pxTQFCX8eXqI+jrFFxA1pbPG0vmm3SxkvrSBynqZ8b//rXm77jQwIl4u+BrhQ8vPRnLv4DUAW+ZBq0WO6LCgkBmSKt5OgW2ljgIDuwfrzrWTjix9z6VJVi3Q95VQfgMAyCvBbW4bp6084iEU2yBGHospFz5hkUej598cyOolg7juBDtSw6RXdn58b+stt07M0zecKzDsgAxhKW+DuUl7P6O+rsPqTK+ojKderysWf73Lp6Uxu46GwQIdv8vkqvvEvY5Y/j3pjmeVBlPeJBZiFf7kFJlqYJY/rqSKv6VuQYT+qHoSJzAYCtKki3dWeWGe1aphSlNIyUVAH+NkMbt7SuQ5Vxr//3chgvEGNnp3m641S59IsQWaQB3dBTPR6T3maXVx5WMndcmQPUbjviBjpq+75KZlDOINCBH13JBBJ51z+wT08jObmINcdEs7pNOxC+nYa/Iw8kC3EHre376TGKGFGvi5T8Sq/DSsGPXC9GXcGuleO67IXhpzBDMN6Bz+z64hoTai/GEYFPdrBCqLWSt+iSosgbasL7dWseFFtEAcX73CkbV4me8ok/tCCioM/CbsVq5z+uM5p3kPjAQPifCV9haXJPvUnFkK8LBRFJWdwlI8QpAiXcZVe2YqgV/y7Vdvg15dKJBvKn1OXBZ13yMVBU9RDKpBTWvicSU0Egox1wtPBRA+xWwVKbJxf27uOMVh0doch7G/titkR18LrZM7IDRIrKAp7v8vdFdG/S7pIJRzafCX8qWX1FpdjAe5LIu4/WWQfcobJ4nluV3ZAIRR59DL2LO1osEws0jcKiE/NlD/AsHiPx
 ddNugbiR
 /EIlFoE5rBTxqiMoNcZPQeZt7zrisIQJiTpJZQeUttd+GNrWuqqnD2HWbJIWo/se0v+DeQBYgDzbuiG7c6XyboS7DsPghgvGbtJbcegI/m0s6Pxiygc4Yh7+VT2nQODxBqzf8aeD9UYjirA/6Qq/XCh6NiWl7kYR8hK+3pUMragxc+kKBLgRU6nTHKhUueB5JcyOcN7JJjkSZgicnzeQnv6kbIOnMdfx4TTS+h6jQu/s005RRwAskLJnaPvaPWU5/klDcClvRnfyfFsIVOxnXnOt13Gk+Yr1mWWtiDcnZkY/NBTHZ3J1R1tKqQkm0QaWbOYvlVpuwRaZyDChOqdwBw2ldiFW8+Bt9EA3z+PAt8J0EzmAuFLk5mcRM80Qz0OgZa5WJ0Tm0OC1od8xRiAQnSca+q9c07lPhES/OzL+aRvIGLlcRVCUyPdYL3CTEETyPq7wPrMKbe9Dj10Cg4HLg5hMRxnYE2HCx+0Mbpgd9L1bWPtIGlBiwDCSb7OeoCY27C0Pg+ooIoGsWtLsUwKHYCxRixvu/1KJ4C6Ftkf4r4qZ6NeOArJcLlnhrbgiffttjHpXnsbmBgLg0ybpF0Yc1gitjiB7iNS99HbGJqjXx7Y4x3eRz0mClRKtNmtYLt1gXZ4Q9i7WRAm/qxNH30Z8aoQ7bR2+9enYAqKA1b025D6dtTdTueDGysobpG8zItP0Vn/YgNucXMQEA+Qm5RKj4+kU9u750Ovr55zkkLz55eU8jaJprVjrq9BVIhH7KzG4ND+TpXumKsqIuDocXyowmPWazTAi908AlWOms+so7YvpsxGxPZIvR1c00UEpWOnB+ATRhlj1lXCtS2tkoFuL2bocgFgqDcbElY8kQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Needed observability on in field devices can be collected with minimal
overhead and can be toggled on and off. Event driven telemetry can be
done with tracepoint BPF programs.

The process comm is provided for aggregation across devices and tgid is
to enable per-process aggregation per device.

This allows for observing the distribution of such problems in the
field, to deduce if there are legitimate bugs or if a bump to the limit is
warranted.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Signed-off-by: Kalesh Singh <kaleshsingh@google.com>

---

Changes in v3:
- capture the mm pointer as the unique identifier and capture
  the vma_count as well, instead of current task tgid, per Steve
- Add include/trace/events/vma.h to MEMORY MAPPING section in
  MAINTAINERS, per Lorenzo
- rename trace_max_vma_count_exceeded() to
  trace_mm_insufficient_vma_slots(), since this is a preemptive
  check, per Lorenzo
- Fix tools/testing/vma build errors, per Lorenzo

 MAINTAINERS                      |  1 +
 include/trace/events/vma.h       | 32 ++++++++++++++++++++++++++++++++
 mm/mmap.c                        |  5 ++++-
 mm/mremap.c                      | 10 ++++++++--
 mm/vma.c                         |  9 +++++++--
 mm/vma_internal.h                |  2 ++
 tools/testing/vma/vma_internal.h |  5 +++++
 7 files changed, 59 insertions(+), 5 deletions(-)
 create mode 100644 include/trace/events/vma.h

diff --git a/MAINTAINERS b/MAINTAINERS
index aa83e5893e16..d37215a8a829 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16566,6 +16566,7 @@ S:	Maintained
 W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
 F:	include/trace/events/mmap.h
+F:	include/trace/events/vma.h
 F:	mm/interval_tree.c
 F:	mm/mincore.c
 F:	mm/mlock.c
diff --git a/include/trace/events/vma.h b/include/trace/events/vma.h
new file mode 100644
index 000000000000..4540fa607f66
--- /dev/null
+++ b/include/trace/events/vma.h
@@ -0,0 +1,32 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM vma
+
+#if !defined(_TRACE_VMA_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_VMA_H
+
+#include <linux/tracepoint.h>
+
+TRACE_EVENT(mm_insufficient_vma_slots,
+
+	TP_PROTO(struct mm_struct *mm),
+
+	TP_ARGS(mm),
+
+	TP_STRUCT__entry(
+		__field(void *,	mm)
+		__field(int,	vma_count)
+	),
+
+	TP_fast_assign(
+		__entry->mm		= mm;
+		__entry->vma_count	= mm->vma_count;
+	),
+
+	TP_printk("mm=%p vma_count=%d", __entry->mm, __entry->vma_count)
+);
+
+#endif /*  _TRACE_VMA_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/mm/mmap.c b/mm/mmap.c
index b4eda47b88d8..4035f49ac963 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -56,6 +56,7 @@
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/mmap.h>
+#include <trace/events/vma.h>
 
 #include "internal.h"
 
@@ -374,8 +375,10 @@ unsigned long do_mmap(struct file *file, unsigned long addr,
 		return -EOVERFLOW;
 
 	/* Too many mappings? */
-	if (!vma_count_remaining(mm))
+	if (!vma_count_remaining(mm)) {
+		trace_mm_insufficient_vma_slots(mm);
 		return -ENOMEM;
+	}
 
 	/*
 	 * addr is returned from get_unmapped_area,
diff --git a/mm/mremap.c b/mm/mremap.c
index 14d35d87e89b..a7f440a3737f 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -30,6 +30,8 @@
 #include <asm/tlb.h>
 #include <asm/pgalloc.h>
 
+#include <trace/events/vma.h>
+
 #include "internal.h"
 
 /* Classify the kind of remap operation being performed. */
@@ -1040,8 +1042,10 @@ static unsigned long prep_move_vma(struct vma_remap_struct *vrm)
 	 * We'd prefer to avoid failure later on in do_munmap:
 	 * which may split one vma into three before unmapping.
 	 */
-	if (vma_count_remaining(current->mm) < 4)
+	if (vma_count_remaining(current->mm) < 4) {
+		trace_mm_insufficient_vma_slots(current->mm);
 		return -ENOMEM;
+	}
 
 	if (vma->vm_ops && vma->vm_ops->may_split) {
 		if (vma->vm_start != old_addr)
@@ -1817,8 +1821,10 @@ static unsigned long check_mremap_params(struct vma_remap_struct *vrm)
 	 * the threshold. In other words, is the current map count + 6 at or
 	 * below the threshold? Otherwise return -ENOMEM here to be more safe.
 	 */
-	if (vma_count_remaining(current->mm) < 6)
+	if (vma_count_remaining(current->mm) < 6) {
+		trace_mm_insufficient_vma_slots(current->mm);
 		return -ENOMEM;
+	}
 
 	return 0;
 }
diff --git a/mm/vma.c b/mm/vma.c
index b35a4607cde4..6d8cef7f4d5f 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -592,8 +592,10 @@ __split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
 static int split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
 		     unsigned long addr, int new_below)
 {
-	if (!vma_count_remaining(vma->vm_mm))
+	if (!vma_count_remaining(vma->vm_mm)) {
+		trace_mm_insufficient_vma_slots(vma->vm_mm);
 		return -ENOMEM;
+	}
 
 	return __split_vma(vmi, vma, addr, new_below);
 }
@@ -1346,6 +1348,7 @@ static int vms_gather_munmap_vmas(struct vma_munmap_struct *vms,
 		 */
 		if (vms->end < vms->vma->vm_end &&
 		    !vma_count_remaining(vms->vma->vm_mm)) {
+			trace_mm_insufficient_vma_slots(vms->vma->vm_mm);
 			error = -ENOMEM;
 			goto vma_count_exceeded;
 		}
@@ -2797,8 +2800,10 @@ int do_brk_flags(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	if (!may_expand_vm(mm, vm_flags, len >> PAGE_SHIFT))
 		return -ENOMEM;
 
-	if (!vma_count_remaining(mm))
+	if (!vma_count_remaining(mm)) {
+		trace_mm_insufficient_vma_slots(mm);
 		return -ENOMEM;
+	}
 
 	if (security_vm_enough_memory_mm(mm, len >> PAGE_SHIFT))
 		return -ENOMEM;
diff --git a/mm/vma_internal.h b/mm/vma_internal.h
index 2f05735ff190..86823ca6857b 100644
--- a/mm/vma_internal.h
+++ b/mm/vma_internal.h
@@ -52,4 +52,6 @@
 
 #include "internal.h"
 
+#include <trace/events/vma.h>
+
 #endif	/* __MM_VMA_INTERNAL_H */
diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_internal.h
index 84760d901656..57e36d82b4c8 100644
--- a/tools/testing/vma/vma_internal.h
+++ b/tools/testing/vma/vma_internal.h
@@ -1493,4 +1493,9 @@ static int vma_count_remaining(const struct mm_struct *mm)
 	return (max_count > vma_count) ? (max_count - vma_count) : 0;
 }
 
+/* Stub for trace_mm_insufficient_vma_slots */
+static inline void trace_mm_insufficient_vma_slots(struct mm_struct *mm)
+{
+}
+
 #endif	/* __MM_VMA_INTERNAL_H */
-- 
2.51.0.760.g7b8bcc2412-goog


