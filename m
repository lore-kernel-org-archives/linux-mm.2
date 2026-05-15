Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81F6FCD343F
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 12:43:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA26C6B0092; Fri, 15 May 2026 08:43:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7A4E6B0093; Fri, 15 May 2026 08:43:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 942096B0095; Fri, 15 May 2026 08:43:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7F1CF6B0092
	for <linux-mm@kvack.org>; Fri, 15 May 2026 08:43:54 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 40C128DDB3
	for <linux-mm@kvack.org>; Fri, 15 May 2026 12:43:54 +0000 (UTC)
X-FDA: 84769621188.13.4C7E8E5
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3954E1C000A
	for <linux-mm@kvack.org>; Fri, 15 May 2026 12:43:52 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RcRswQX9;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of elaidya225@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=elaidya225@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778849032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jACQptbddcKyr8LyoWNeMZPH16OhDv8Ilvbqa7E6/Rw=;
	b=Da25jFyccEIO8hx09nbvJTPmdFX0K5w5Y8U2nvFETrdQTIWNjf2FhsiZ288kchNWUesm2V
	ykqOvu3vlH+pKVhawHRGBI11dKBFcISTx88fvTdzY5PCBpZbGMRaoZVk6U1zFOHWpjnn7q
	Tw5XAI/pDKIjzD083DdNXRx0D0jACz0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778849032; a=rsa-sha256;
	cv=none;
	b=g3XlMZ34wpbKbnjAs010zxGJAsBXSZSbdFLiRm0QYp6kubDxdpi4+lXKZIeXaHzWukvgvI
	1OyIbJi1AS19ZeBqE6eoJhzGlpP9a8boQAnzmQ2WouIfQfwcsMhLPA9sxyyavDshvzjly1
	5lPB/CpuRxMwFmVi0uiROL7/eHFvVZY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RcRswQX9;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of elaidya225@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=elaidya225@gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-488af9fdaa7so50330975e9.1
        for <linux-mm@kvack.org>; Fri, 15 May 2026 05:43:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778849031; x=1779453831; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jACQptbddcKyr8LyoWNeMZPH16OhDv8Ilvbqa7E6/Rw=;
        b=RcRswQX9XK3lc4ePy9Cas9Xc+pUCzzgNIXdx9D2vFHiush+GpBcOZG3Q4dAOx1+4O1
         d7QXtm2WTpbY561H6T8xTHS009V9arUKpr+pdYo7tsUl91y7JAzNizrf+1biAsKrpMCL
         NeIM5KgUuz0N5rMiW8qpKhPextxjVGl73GVO/p7dmC1EJF5Eyu7bN55CPDPy9HcGqDjF
         r9do/zT8rb+WxpRZrUNs7Lp20w9xra7Gu0GKpX2raLKw5N/iLueQsjTpIBHPfj9nMd3T
         n7FZx6MoGuWBIScjg3i/RZdynd99SEYYjAn+ZESFQV1fDoA5rjZgXO3e7NtCVBMx1rLI
         tpKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778849031; x=1779453831;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jACQptbddcKyr8LyoWNeMZPH16OhDv8Ilvbqa7E6/Rw=;
        b=em0WbNnXbDopj1dwgFuNTUHR4DH3U9phb4Adqi77Qrw/++RCpVovlD414crSfkdH9T
         Em6Pd3KRmsxPjKsMbIKfZ0vOfHl/pmoboeZM3OAhx9fqJOCPczU9i8w4ANwKgJiJWUNc
         SMyqb6u6Rmfkf3GBJiHhR21ZKWiw0goRt23l/WbJkoEHqnQ98Wphml7b5io3X9j74eW5
         QRsrdXCeryNhNvrTEBy8G0Ct24WP/NxqLPiQq1lyooW6GKOdH+pvOTtzj1djRF3hRbdR
         Uz1xJ1PnSp5y+5lN3xm16OaVQpIwO0uOZvGal9Iuey2IOFJGGWbGf5vdnhUUqqhp2b/E
         39qw==
X-Gm-Message-State: AOJu0Yxx5cFqrh5SHtSMQF22p9+Wx5pRolRW61+c+KPGq5MBRzQlHU+j
	+xvVy0FYSiwtB1lIybRn35Nz51WZ0vPOnU3u1MTM6zF5gidBGCBkYOW6
X-Gm-Gg: Acq92OH1iTelZLhWL5l53Ak2oqCpDCPz4131D1ocH8CIuPsAao8DQcquDLAWY/qmLye
	FXM4WQTPA6b5tUvcYWhYTeKV0QYtRFWjJvOxbiy2nMgWdE1UpeiXxX8QqqN3iWzOhKz5AHGabl2
	lwLjD8/OdiWbzeco5T7CeSe+kjtjtNjbP+YWwXbgXFPqLkOGZYbhDrrKChYQjsGrbkDeY/r3oD5
	IrdsSXmcP6XIwsZfZXV39uqni0KbTTEcWhgzQDaSU8ovhp7sbFgMePR6fQA9I8If8jsAbr/1npR
	vP6Opbq00HtcxbR0UIpL8qAUpIO6cBug49labkFybZPBOBgsRPkVzqd8Qbw336nXLjpOUfqGSiK
	TTUQSHgQSh6mL4r8NXaFY93g93Lz33PebKb8PRDM4khGIHXJFY9l3Sh9quySl0nJmqQjjjraTyr
	1I2KnU77/YmYoUePbAjEc=
X-Received: by 2002:a05:600c:8b6e:b0:485:9a50:3370 with SMTP id 5b1f17b1804b1-48fe60ecc24mr58490905e9.8.1778849030717;
        Fri, 15 May 2026 05:43:50 -0700 (PDT)
Received: from fedora ([156.207.183.142])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fe4c8344asm100188115e9.1.2026.05.15.05.43.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 05:43:50 -0700 (PDT)
From: Ahmed Elaidy <elaidya225@gmail.com>
To: stable@vger.kernel.org
Cc: linux-mm@kvack.org,
	akpm@linux-foundation.org,
	ljs@kernel.org,
	avagin@gmail.com,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Jann Horn <jannh@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Lance Yang <lance.yang@linux.dev>,
	Liam Howlett <liam.howlett@oracle.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Zi Yan <ziy@nvidia.com>,
	Ahmed Elaidy <elaidya225@gmail.com>
Subject: [PATCH v4 3/9] mm: update vma_modify_flags() to handle residual flags, document
Date: Fri, 15 May 2026 15:42:13 +0300
Message-ID: <20260515124218.151966-5-elaidya225@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515124218.151966-2-elaidya225@gmail.com>
References: <20260515124218.151966-2-elaidya225@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3954E1C000A
X-Stat-Signature: tyg4d7aie7h6ijkjfx1xfxz6gaerfgmt
X-Rspam-User: 
X-HE-Tag: 1778849032-790986
X-HE-Meta: U2FsdGVkX1/aU2VhaIdHX69QdKPVsMQBOjFuQ00DwXglbljTsyn/umknJoVUFzRHTght/I+bIF73lUmWrKigsd4g1wFsbEx6gPqXC4jF4DTQzoVeXkfz5gNeSxdMrsLSDkt0HVXCm1fLwpb/QqImT0Xl8+3NI1zZM1Y1GNWV0g6Ie//IJ4rcJmIUBgCiQB1vJy0SL3C7JFBUaP+w0mGoSSUcr3f9V+QGxFMgz8z2wZUCvOjIyMhu9FlAAi0K5pLzq9pITPPX8KiMkd12BhEE61NmQ50qmtNo27p0jKgwnl9yOh62O7c+ykPdh2ECXaTFr/SrMDsEQPBXq42v3LN3PqySSWn7CUjNucpQa7OcdkezvKLr2Wh5ek0tKZtEXRPm0pfc8Fvc8O748XClF4BlYLNtmN7QtKQfGNxrKFFpKbr7iuRhSjIlJdWXrzKMQ2RSxqVlMvb4NoFTC7qy6RzqZyeeSXH96Kvmsn9sGKdpEtScDgEkjCaT0zkxHR8ut+sVUz4aHdsR03aknN7xD6Lkt7kP8YKWnyx4deKoF+2rIxz7mEKi7YBMMlMG/pUdWfv5IpFx+9EL04WeMFdsGzf3zkT+zShdlslmt3dcvAsfEGz9i459vndavjA/SLZdf7yIl5bZjbags9YoAva+BydH70+CSrIYXy87ToF08MEddoV0+EewlXxR8+JqqN9sb7yuhtsnae74NviXS/aOz7IHv5I0Yd4Y/fRWryKAkg4GNHqAZTxHOHQyE+QIy3JISluRQw68U7GhapdxV4C/2DoGPkJQl0LeQtCpuxxh8KLTXPc8i+XXhu8DximS8lGu8XNcG74BGsRfpnCtEuZzek2cpjK4fll+zgsbx/EmwTGGdNgZzDKLu42HKWLpA0qxbubWLyux3aaf/MzYU+efITTUGAmSDIuL3NHPONQx2noXabSlBF7WSmOzYPSY/QCGCfSdiBPhUFvZ9IrFVvX7Y0e
 BPBlmMdI
 r6XySPnynfXAY6Tr5T5mzifg83NnwP3TFekA7ag87ELosmAvwEuMFCxt438B+IpkRRj/82IHb5Bujv2YIoAv6/nyJVII3s0GFdUluJjK9no++o5wA1tDDBWzazMeRuww1nVGjc1REed7bmUxZkiErA/2z4cQWs1k37RhdCHAxsLOgY925LCYkr4DLL3zYOLD33is4+SIUPe3wdTfzFiS7la+jZSzP852XrE5V7ugkvfmrac26iBzUMaMIl2PSZYVU/Vm8bPIoiMHNdS7zWuVzJfOJrbTfwgBxZdWaUm6Bs6ttBZ7dxCjwQF8G0jZeMMfeGi+I9CN/1dWv8oAu5G+rIgdNQB0y8nmyBz0Dv8fbo8pGc7Uq0TU0YapF3IXhram5v29Wlk/1ah4gCrzQZQNxFK/yWk7dgOxjZExOF2avvQ1N38Yo+qiU+z5mKr7zYn5a5MPztytxMICWXCFdFgB/wd1sMijKan4Q/8VMvMaWXt6YQIqEGTAe4MsTh05gb8CHzp3vZGr4ZjdnFaAj2/Ik3aLqSZDNtQoVZ+ytiiwiu7qggCLB3nyRvhqfe6r3XZ8KFia2JIJH6+9WP1i98VIXvmS8DcwpuXNFGD9fXt0zqd4VfwG4qm1KwzPPnYJDHhncaYalKa5TpascgN0E0Vd6TMAmgVmyGT/QdVkepF04ze3AqqRR+bXr/USZ9I2qhukBWfMGHACr5L/FBlwDzBn+67ewC1oAtYT6JNkh3PdRSgLtWEIs3MfvKeibANkMBbhIgfClUsj1898TgEpxdb322ycU7I88CSmZXGkcBD5j14mv/m79raImHoFj1WzM4Y/VNR2DdgkGSGcO8UcSzIrHRI4+gWA0Cn/heexqr7zvQOQkAK8UBbCltddLUGuhfbBsZMeeeTABXOQrzY6NMQIEMLM5dLGfw+HqedEUeSoAQGiuo1doduO5/hFAhj2wq+5J1TaYLq+WIhRnLIE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

The vma_modify_*() family of functions each either perform splits, a merge
or no changes at all in preparation for the requested modification to
occur.

When doing so for a VMA flags change, we currently don't account for any
flags which may remain (for instance, VM_SOFTDIRTY) despite the requested
change in the case that a merge succeeded.

This is made more important by subsequent patches which will introduce the
concept of sticky VMA flags which rely on this behaviour.

This patch fixes this by passing the VMA flags parameter as a pointer and
updating it accordingly on merge and updating callers to accommodate for
this.

Additionally, while we are here, we add kdocs for each of the
vma_modify_*() functions, as the fact that the requested modification is
not performed is confusing so it is useful to make this abundantly clear.

We also update the VMA userland tests to account for this change.

Link: https://lkml.kernel.org/r/23b5b549b0eaefb2922625626e58c2a352f3e93c.1763460113.git.ljs@kernel.org
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrei Vagin <avagin@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
(cherry picked from commit 9119d6c2095bb20292cb9812dd70d37f17e3bd37)
Signed-off-by: Ahmed Elaidy <elaidya225@gmail.com>

Cc: stable@vger.kernel.org # 6.18.x
---
 mm/madvise.c            |   2 +-
 mm/mlock.c              |   2 +-
 mm/mprotect.c           |   2 +-
 mm/mseal.c              |   7 +-
 mm/vma.c                |  56 ++++++++--------
 mm/vma.h                | 140 +++++++++++++++++++++++++++++-----------
 tools/testing/vma/vma.c |   3 +-
 7 files changed, 143 insertions(+), 69 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index fb1c86e630b6..0b3280752bfb 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -167,7 +167,7 @@ static int madvise_update_vma(vm_flags_t new_flags,
 			range->start, range->end, anon_name);
 	else
 		vma = vma_modify_flags(&vmi, madv_behavior->prev, vma,
-			range->start, range->end, new_flags);
+			range->start, range->end, &new_flags);
 
 	if (IS_ERR(vma))
 		return PTR_ERR(vma);
diff --git a/mm/mlock.c b/mm/mlock.c
index bb0776f5ef7c..2f699c3497a5 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -478,7 +478,7 @@ static int mlock_fixup(struct vma_iterator *vmi, struct vm_area_struct *vma,
 		/* don't set VM_LOCKED or VM_LOCKONFAULT and don't count */
 		goto out;
 
-	vma = vma_modify_flags(vmi, *prev, vma, start, end, newflags);
+	vma = vma_modify_flags(vmi, *prev, vma, start, end, &newflags);
 	if (IS_ERR(vma)) {
 		ret = PTR_ERR(vma);
 		goto out;
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 988c366137d5..fa818cd58201 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -813,7 +813,7 @@ mprotect_fixup(struct vma_iterator *vmi, struct mmu_gather *tlb,
 		newflags &= ~VM_ACCOUNT;
 	}
 
-	vma = vma_modify_flags(vmi, *pprev, vma, start, end, newflags);
+	vma = vma_modify_flags(vmi, *pprev, vma, start, end, &newflags);
 	if (IS_ERR(vma)) {
 		error = PTR_ERR(vma);
 		goto fail;
diff --git a/mm/mseal.c b/mm/mseal.c
index c561f0ea93e8..3d2f06046e90 100644
--- a/mm/mseal.c
+++ b/mm/mseal.c
@@ -69,9 +69,10 @@ static int mseal_apply(struct mm_struct *mm,
 		const unsigned long curr_end = MIN(vma->vm_end, end);
 
 		if (!(vma->vm_flags & VM_SEALED)) {
-			vma = vma_modify_flags(&vmi, prev, vma,
-					curr_start, curr_end,
-					vma->vm_flags | VM_SEALED);
+			vm_flags_t vm_flags = vma->vm_flags | VM_SEALED;
+
+			vma = vma_modify_flags(&vmi, prev, vma, curr_start,
+					       curr_end, &vm_flags);
 			if (IS_ERR(vma))
 				return PTR_ERR(vma);
 			vm_flags_set(vma, VM_SEALED);
diff --git a/mm/vma.c b/mm/vma.c
index 5815ae9e5770..06609f4116b4 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -1676,25 +1676,35 @@ static struct vm_area_struct *vma_modify(struct vma_merge_struct *vmg)
 	return vma;
 }
 
-struct vm_area_struct *vma_modify_flags(
-	struct vma_iterator *vmi, struct vm_area_struct *prev,
-	struct vm_area_struct *vma, unsigned long start, unsigned long end,
-	vm_flags_t vm_flags)
+struct vm_area_struct *vma_modify_flags(struct vma_iterator *vmi,
+		struct vm_area_struct *prev, struct vm_area_struct *vma,
+		unsigned long start, unsigned long end,
+		vm_flags_t *vm_flags_ptr)
 {
 	VMG_VMA_STATE(vmg, vmi, prev, vma, start, end);
+	const vm_flags_t vm_flags = *vm_flags_ptr;
+	struct vm_area_struct *ret;
 
 	vmg.vm_flags = vm_flags;
 
-	return vma_modify(&vmg);
+	ret = vma_modify(&vmg);
+	if (IS_ERR(ret))
+		return ret;
+
+	/*
+	 * For a merge to succeed, the flags must match those requested. For
+	 * flags which do not obey typical merge rules (i.e. do not need to
+	 * match), we must let the caller know about them.
+	 */
+	if (vmg.state == VMA_MERGE_SUCCESS)
+		*vm_flags_ptr = ret->vm_flags;
+	return ret;
 }
 
-struct vm_area_struct
-*vma_modify_name(struct vma_iterator *vmi,
-		       struct vm_area_struct *prev,
-		       struct vm_area_struct *vma,
-		       unsigned long start,
-		       unsigned long end,
-		       struct anon_vma_name *new_name)
+struct vm_area_struct *vma_modify_name(struct vma_iterator *vmi,
+		struct vm_area_struct *prev, struct vm_area_struct *vma,
+		unsigned long start, unsigned long end,
+		struct anon_vma_name *new_name)
 {
 	VMG_VMA_STATE(vmg, vmi, prev, vma, start, end);
 
@@ -1703,12 +1713,10 @@ struct vm_area_struct
 	return vma_modify(&vmg);
 }
 
-struct vm_area_struct
-*vma_modify_policy(struct vma_iterator *vmi,
-		   struct vm_area_struct *prev,
-		   struct vm_area_struct *vma,
-		   unsigned long start, unsigned long end,
-		   struct mempolicy *new_pol)
+struct vm_area_struct *vma_modify_policy(struct vma_iterator *vmi,
+		struct vm_area_struct *prev, struct vm_area_struct *vma,
+		unsigned long start, unsigned long end,
+		struct mempolicy *new_pol)
 {
 	VMG_VMA_STATE(vmg, vmi, prev, vma, start, end);
 
@@ -1717,14 +1725,10 @@ struct vm_area_struct
 	return vma_modify(&vmg);
 }
 
-struct vm_area_struct
-*vma_modify_flags_uffd(struct vma_iterator *vmi,
-		       struct vm_area_struct *prev,
-		       struct vm_area_struct *vma,
-		       unsigned long start, unsigned long end,
-		       vm_flags_t vm_flags,
-		       struct vm_userfaultfd_ctx new_ctx,
-		       bool give_up_on_oom)
+struct vm_area_struct *vma_modify_flags_uffd(struct vma_iterator *vmi,
+		struct vm_area_struct *prev, struct vm_area_struct *vma,
+		unsigned long start, unsigned long end, vm_flags_t vm_flags,
+		struct vm_userfaultfd_ctx new_ctx, bool give_up_on_oom)
 {
 	VMG_VMA_STATE(vmg, vmi, prev, vma, start, end);
 
diff --git a/mm/vma.h b/mm/vma.h
index d73e1b324bfd..1f2d11bb08b4 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -266,47 +266,115 @@ void remove_vma(struct vm_area_struct *vma);
 void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
 		struct vm_area_struct *prev, struct vm_area_struct *next);
 
-/* We are about to modify the VMA's flags. */
-__must_check struct vm_area_struct
-*vma_modify_flags(struct vma_iterator *vmi,
+/**
+ * vma_modify_flags() - Peform any necessary split/merge in preparation for
+ * setting VMA flags to *@vm_flags in the range @start to @end contained within
+ * @vma.
+ * @vmi: Valid VMA iterator positioned at @vma.
+ * @prev: The VMA immediately prior to @vma or NULL if @vma is the first.
+ * @vma: The VMA containing the range @start to @end to be updated.
+ * @start: The start of the range to update. May be offset within @vma.
+ * @end: The exclusive end of the range to update, may be offset within @vma.
+ * @vm_flags_ptr: A pointer to the VMA flags that the @start to @end range is
+ * about to be set to. On merge, this will be updated to include any additional
+ * flags which remain in place.
+ *
+ * IMPORTANT: The actual modification being requested here is NOT applied,
+ * rather the VMA is perhaps split, perhaps merged to accommodate the change,
+ * and the caller is expected to perform the actual modification.
+ *
+ * In order to account for VMA flags which may persist (e.g. soft-dirty), the
+ * @vm_flags_ptr parameter points to the requested flags which are then updated
+ * so the caller, should they overwrite any existing flags, correctly retains
+ * these.
+ *
+ * Returns: A VMA which contains the range @start to @end ready to have its
+ * flags altered to *@vm_flags.
+ */
+__must_check struct vm_area_struct *vma_modify_flags(struct vma_iterator *vmi,
+		struct vm_area_struct *prev, struct vm_area_struct *vma,
+		unsigned long start, unsigned long end,
+		vm_flags_t *vm_flags_ptr);
+
+/**
+ * vma_modify_name() - Peform any necessary split/merge in preparation for
+ * setting anonymous VMA name to @new_name in the range @start to @end contained
+ * within @vma.
+ * @vmi: Valid VMA iterator positioned at @vma.
+ * @prev: The VMA immediately prior to @vma or NULL if @vma is the first.
+ * @vma: The VMA containing the range @start to @end to be updated.
+ * @start: The start of the range to update. May be offset within @vma.
+ * @end: The exclusive end of the range to update, may be offset within @vma.
+ * @new_name: The anonymous VMA name that the @start to @end range is about to
+ * be set to.
+ *
+ * IMPORTANT: The actual modification being requested here is NOT applied,
+ * rather the VMA is perhaps split, perhaps merged to accommodate the change,
+ * and the caller is expected to perform the actual modification.
+ *
+ * Returns: A VMA which contains the range @start to @end ready to have its
+ * anonymous VMA name changed to @new_name.
+ */
+__must_check struct vm_area_struct *vma_modify_name(struct vma_iterator *vmi,
 		struct vm_area_struct *prev, struct vm_area_struct *vma,
 		unsigned long start, unsigned long end,
-		vm_flags_t vm_flags);
-
-/* We are about to modify the VMA's anon_name. */
-__must_check struct vm_area_struct
-*vma_modify_name(struct vma_iterator *vmi,
-		 struct vm_area_struct *prev,
-		 struct vm_area_struct *vma,
-		 unsigned long start,
-		 unsigned long end,
-		 struct anon_vma_name *new_name);
-
-/* We are about to modify the VMA's memory policy. */
-__must_check struct vm_area_struct
-*vma_modify_policy(struct vma_iterator *vmi,
-		   struct vm_area_struct *prev,
-		   struct vm_area_struct *vma,
+		struct anon_vma_name *new_name);
+
+/**
+ * vma_modify_policy() - Peform any necessary split/merge in preparation for
+ * setting NUMA policy to @new_pol in the range @start to @end contained
+ * within @vma.
+ * @vmi: Valid VMA iterator positioned at @vma.
+ * @prev: The VMA immediately prior to @vma or NULL if @vma is the first.
+ * @vma: The VMA containing the range @start to @end to be updated.
+ * @start: The start of the range to update. May be offset within @vma.
+ * @end: The exclusive end of the range to update, may be offset within @vma.
+ * @new_pol: The NUMA policy that the @start to @end range is about to be set
+ * to.
+ *
+ * IMPORTANT: The actual modification being requested here is NOT applied,
+ * rather the VMA is perhaps split, perhaps merged to accommodate the change,
+ * and the caller is expected to perform the actual modification.
+ *
+ * Returns: A VMA which contains the range @start to @end ready to have its
+ * NUMA policy changed to @new_pol.
+ */
+__must_check struct vm_area_struct *vma_modify_policy(struct vma_iterator *vmi,
+		   struct vm_area_struct *prev, struct vm_area_struct *vma,
 		   unsigned long start, unsigned long end,
 		   struct mempolicy *new_pol);
 
-/* We are about to modify the VMA's flags and/or uffd context. */
-__must_check struct vm_area_struct
-*vma_modify_flags_uffd(struct vma_iterator *vmi,
-		       struct vm_area_struct *prev,
-		       struct vm_area_struct *vma,
-		       unsigned long start, unsigned long end,
-		       vm_flags_t vm_flags,
-		       struct vm_userfaultfd_ctx new_ctx,
-		       bool give_up_on_oom);
-
-__must_check struct vm_area_struct
-*vma_merge_new_range(struct vma_merge_struct *vmg);
-
-__must_check struct vm_area_struct
-*vma_merge_extend(struct vma_iterator *vmi,
-		  struct vm_area_struct *vma,
-		  unsigned long delta);
+/**
+ * vma_modify_flags_uffd() - Peform any necessary split/merge in preparation for
+ * setting VMA flags to @vm_flags and UFFD context to @new_ctx in the range
+ * @start to @end contained within @vma.
+ * @vmi: Valid VMA iterator positioned at @vma.
+ * @prev: The VMA immediately prior to @vma or NULL if @vma is the first.
+ * @vma: The VMA containing the range @start to @end to be updated.
+ * @start: The start of the range to update. May be offset within @vma.
+ * @end: The exclusive end of the range to update, may be offset within @vma.
+ * @vm_flags: The VMA flags that the @start to @end range is about to be set to.
+ * @new_ctx: The userfaultfd context that the @start to @end range is about to
+ * be set to.
+ * @give_up_on_oom: If an out of memory condition occurs on merge, simply give
+ * up on it and treat the merge as best-effort.
+ *
+ * IMPORTANT: The actual modification being requested here is NOT applied,
+ * rather the VMA is perhaps split, perhaps merged to accommodate the change,
+ * and the caller is expected to perform the actual modification.
+ *
+ * Returns: A VMA which contains the range @start to @end ready to have its VMA
+ * flags changed to @vm_flags and its userfaultfd context changed to @new_ctx.
+ */
+__must_check struct vm_area_struct *vma_modify_flags_uffd(struct vma_iterator *vmi,
+		struct vm_area_struct *prev, struct vm_area_struct *vma,
+		unsigned long start, unsigned long end, vm_flags_t vm_flags,
+		struct vm_userfaultfd_ctx new_ctx, bool give_up_on_oom);
+
+__must_check struct vm_area_struct *vma_merge_new_range(struct vma_merge_struct *vmg);
+
+__must_check struct vm_area_struct *vma_merge_extend(struct vma_iterator *vmi,
+		  struct vm_area_struct *vma, unsigned long delta);
 
 void unlink_file_vma_batch_init(struct unlink_vma_file_batch *vb);
 
diff --git a/tools/testing/vma/vma.c b/tools/testing/vma/vma.c
index 656e1c75b711..fd37ce3b2628 100644
--- a/tools/testing/vma/vma.c
+++ b/tools/testing/vma/vma.c
@@ -339,6 +339,7 @@ static bool test_simple_modify(void)
 	struct mm_struct mm = {};
 	struct vm_area_struct *init_vma = alloc_vma(&mm, 0, 0x3000, 0, vm_flags);
 	VMA_ITERATOR(vmi, &mm, 0x1000);
+	vm_flags_t flags = VM_READ | VM_MAYREAD;
 
 	ASSERT_FALSE(attach_vma(&mm, init_vma));
 
@@ -347,7 +348,7 @@ static bool test_simple_modify(void)
 	 * performs the merge/split only.
 	 */
 	vma = vma_modify_flags(&vmi, init_vma, init_vma,
-			       0x1000, 0x2000, VM_READ | VM_MAYREAD);
+			       0x1000, 0x2000, &flags);
 	ASSERT_NE(vma, NULL);
 	/* We modify the provided VMA, and on split allocate new VMAs. */
 	ASSERT_EQ(vma, init_vma);
-- 
2.54.0


