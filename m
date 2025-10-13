Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB9DCCCD185
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 23:55:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2606C8E003C; Mon, 13 Oct 2025 19:55:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2373F8E0024; Mon, 13 Oct 2025 19:55:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 174988E003C; Mon, 13 Oct 2025 19:55:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 055878E0024
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 19:55:50 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A8CC5881BA
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 23:55:49 +0000 (UTC)
X-FDA: 83994751218.19.A04F7D3
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1268EC0007
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 23:55:47 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=C3PpSWha;
	spf=pass (imf22.hostedemail.com: domain of 3gpHtaAsKCKkTJUNbQbRWPQPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--kaleshsingh.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3gpHtaAsKCKkTJUNbQbRWPQPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--kaleshsingh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760399748; a=rsa-sha256;
	cv=none;
	b=iYn1LPwh0QKAd4iXikjhEYMJx8F8off6XrFMevFj8AF3SjEsCfe08zKgv51Pep0rdRpypP
	83fjAOujyUru8+GDPEDX/ZzX73Pdl/OdGsAkobEIysF2dD/W4ob3mYlZfsG1mUTQpokW2c
	8RvqqO/b7aYzKNWpUqKqZ8q8ocNkUHE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=C3PpSWha;
	spf=pass (imf22.hostedemail.com: domain of 3gpHtaAsKCKkTJUNbQbRWPQPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--kaleshsingh.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3gpHtaAsKCKkTJUNbQbRWPQPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--kaleshsingh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760399748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6rWZlQ2orhu2ToWW4Y9B+YoDEtQfRAkGMApIJKpfngA=;
	b=0RKX1YZQUar8ITLaHegVERIcptz13VKdD3W/P8HL+DAfje35MdHtk/eA1F4Eq54y6dfNKp
	4331tQ58qmZq/7KT+rOEIgYlx2NpZd4P3poPRa78YWH7WNAZx0OcvLPDEgCrMlaRuD7XpO
	Q9Zkbt4s4q9nJ3RYDuHDpeEQ6+7rxSk=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32eb2b284e4so14391401a91.1
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 16:55:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760399747; x=1761004547; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6rWZlQ2orhu2ToWW4Y9B+YoDEtQfRAkGMApIJKpfngA=;
        b=C3PpSWha4GuY3iIrB118wtYUBKA5BaTmmhnDRaaEQvBbHD6A5pKs1N4D//MXMOZBWu
         0UWeJF7UvG+V/Fs5HMgtMpVZ0xkYRPGa6U34wHwMcMEYcgEp8DRK9IstVMQZZPrsDsAW
         kzV+ZsMID1gPtfBdNKR3SDqU1xAboDs6NFbKlSOBVzfqfNWAjOZvCSX6IHh0Au5RDmbE
         nLhwjdiBlK6LEUco5l+SxdX5UFyWRf04AxxfMuhzWQrmT9Yma7lwxRzj1hqe6VUoGtas
         xs4MPXA1QYIn38g7SJT+Xq8XgBsAB3sw1ie4YqhWOdpUC6TAiM3WTSBtqYcMPv4x28zI
         d3OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760399747; x=1761004547;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6rWZlQ2orhu2ToWW4Y9B+YoDEtQfRAkGMApIJKpfngA=;
        b=nrWbSMUFgIAAS33pR7pTvuLqJzo7+A8x/hJt6T/SPVELl7Cmx4B90eWQfYlftATnT0
         QYQlRGCJKTwqHY7+Zn2ufP6E/1J4VNgYLXPY5jmYFWIwHutIUPIxu4z25iHhh/BRhTyJ
         jFPVIaa+o6ydcyT2lIHLXZ/XGULQ9ETjBxu9OYSJVtsv7i3kSXL55vqr4PsrB/HlyqQc
         BB9q9b2axr5tw++5uZSmrgV2k4YHyhm4+mkUTp0bIMKzR6psrRMbMmrKRffMAwShdBL7
         QIRTSXSouOHJdw2LAFdrrg8EXiubXzkCMJe9nnUBNmm5CHnOVnTzY98GUfIsVcLbJL4U
         LoFw==
X-Forwarded-Encrypted: i=1; AJvYcCVulc71q2x1e9Ue2UCMl79NACJKiBOMiO0jn1UlpGuIjxlmE0lEk7XLOK4C2j3apOngV7Mfyp+c9A==@kvack.org
X-Gm-Message-State: AOJu0Ywg95zFjIe43lxteJWtlzYG1ABjcqdiasCw9S+nu6Prbm10pXZb
	b6Ie4bkMUG7vXk2dfKNhlSeJMZZkBU9+oWWpGeZ5HA+ojsevocw1VAYXnHEtAT8UzuPQ5CfOE43
	bj9gRTNbp1IygbNFlodpjaDNrfw==
X-Google-Smtp-Source: AGHT+IGScETQx55bga4w6kvGfG7E35WD9DziDa+ZAZXqWYfQigIxpcLfBDKsXWxtq04osZKOoTiH4wackQ/kqzmTPQ==
X-Received: from pjtf24.prod.google.com ([2002:a17:90a:c298:b0:339:ee20:f620])
 (user=kaleshsingh job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:1b11:b0:32e:38b0:15f4 with SMTP id 98e67ed59e1d1-33b51149231mr34380315a91.7.1760399746893;
 Mon, 13 Oct 2025 16:55:46 -0700 (PDT)
Date: Mon, 13 Oct 2025 16:51:52 -0700
In-Reply-To: <20251013235259.589015-1-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20251013235259.589015-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.51.0.760.g7b8bcc2412-goog
Message-ID: <20251013235259.589015-2-kaleshsingh@google.com>
Subject: [PATCH v3 1/5] mm: fix off-by-one error in VMA count limit checks
From: Kalesh Singh <kaleshsingh@google.com>
To: akpm@linux-foundation.org, minchan@kernel.org, lorenzo.stoakes@oracle.com, 
	david@redhat.com, Liam.Howlett@oracle.com, rppt@kernel.org, pfalcato@suse.de
Cc: kernel-team@android.com, android-mm@google.com, 
	Kalesh Singh <kaleshsingh@google.com>, stable@vger.kernel.org, 
	SeongJae Park <sj@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
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
X-Stat-Signature: zcyr9ywyi86n8nwsy8gxk9ouwi77xn6p
X-Rspamd-Queue-Id: 1268EC0007
X-Rspamd-Server: rspam09
X-HE-Tag: 1760399747-27426
X-HE-Meta: U2FsdGVkX1+1mx27v8lYGQSeKA/wUJmEjm2CpMt8sccIaqwjBGX2rvbbhta24xIGQPYhncrbTqS/RMvKbwqGnblQaunF2uC+X8BK4ipGedSLLfPeu1FzHViIYVd6s6UQ/GB+d8LFsdRIEtEHO1ulvJtlUWGkGppfP7YXhxn2v3PqPURhB4PxypM25Lrorz+jOC6M6mCXmL1S5GR1doR+s/tNmQv+tPdonP3rr+PwXq+VR50oaHmZhP51U9ClrkzszaRBTsFnqx+cVy85snvaxIFNrqrNNsfx4dmtaGZtsxXtvd7Pd6bFkS0K9OKNYhS37mjC8eaI81OZaz8OCZ6lcL28dy+Z85xsoB0ItKa3ZukS2GW78nEL+Yetzu770gELLKygnwUTVQq8iD7q6sqFTuaVVI48PQtXyhfAPTFJn6FdCVPymDYHbG2zhjOnFJUusL34WbmIYW5FoU61Li7hGiXEf/IcaTk2FPXtpiJtVAVHvAkv8Hos1MrOBT3c318AEhz0rW4DW6YAjUZh4NM47bFdSE7onxonWkX4QOd41KD+OdVu9mkqoHVquFiAEpKGGM1fxBaOiWgUYoDpmoFE5pc4lKjgSxaqQAAZBUUYnVoLiTsWBDK1FmC3hxv3cBmtPzTBf6Cer4wNwh6J82cRSfC0tfKeLLWIVJEM0m5/RBFsHt+T06rGMK18NrZgJs/ESthcgMOTnEL6D15Xe3r18G0KVe/HW+kedJUTanxV5RniHldl7qWMC4aE0//Y3oa6hXxeJkRAM/x0u0q/4Na6ZUZGO+v2xEB+N1aR3iLHltTkctUEKtV2F9k86FIJjqC/HQnO2BGSvODrmF+ebHf/pPyAnlRR4DumRwJLJZjpyCudIQ5/nHyhq87yhz+7l345pXbCnNQ4zeK8kIogBlU15GgcZ/fvcqAVqU+eQ/Ec8TRzvDx+8UTO+Xd1ORfiFyWumWYJI3OSpTBv1xLFMpg
 sTwmYZtT
 38qL4KpoyfcGTfCFS9tNWbyv1Cei8ZFtskmcZM/dFmkQj2DDJ+a5CLLlQEan19yQbbSR4ebzFp8MJnKNqB1NzCH1IJAeXQOGccruqUE/NJXNnbyfFGhwpg621Jrpom+OoMgRz9NHYsS64TjRrVlAnUWUx1AX1TQFX61G0KAvQKeQLEh4gJVam6y81e1H9nULLnAHYROqx1WOX7Yj8Nwff6un24SD+FRdiFgIOxcr2GlwNxz+gH2Cqwj/CTjwyTfNQ/GZgeEK2j+f6s6L8nlLVBYJ35bLkUEOjK+o/GOOCpJZg41M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The VMA count limit check in do_mmap() and do_brk_flags() uses a
strict inequality (>), which allows a process's VMA count to exceed
the configured sysctl_max_map_count limit by one.

A process with mm->map_count == sysctl_max_map_count will incorrectly
pass this check and then exceed the limit upon allocation of a new VMA
when its map_count is incremented.

Other VMA allocation paths, such as split_vma(), already use the
correct, inclusive (>=) comparison.

Fix this bug by changing the comparison to be inclusive in do_mmap()
and do_brk_flags(), bringing them in line with the correct behavior
of other allocation paths.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: <stable@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Acked-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
---

Changes in v3:
 - Collect Reviewed-by and Acked-by tags.

Changes in v2:
 - Fix mmap check, per Pedro

 mm/mmap.c | 2 +-
 mm/vma.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 644f02071a41..da2cbdc0f87b 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -374,7 +374,7 @@ unsigned long do_mmap(struct file *file, unsigned long addr,
 		return -EOVERFLOW;
 
 	/* Too many mappings? */
-	if (mm->map_count > sysctl_max_map_count)
+	if (mm->map_count >= sysctl_max_map_count)
 		return -ENOMEM;
 
 	/*
diff --git a/mm/vma.c b/mm/vma.c
index a2e1ae954662..fba68f13e628 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2797,7 +2797,7 @@ int do_brk_flags(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	if (!may_expand_vm(mm, vm_flags, len >> PAGE_SHIFT))
 		return -ENOMEM;
 
-	if (mm->map_count > sysctl_max_map_count)
+	if (mm->map_count >= sysctl_max_map_count)
 		return -ENOMEM;
 
 	if (security_vm_enough_memory_mm(mm, len >> PAGE_SHIFT))
-- 
2.51.0.760.g7b8bcc2412-goog


