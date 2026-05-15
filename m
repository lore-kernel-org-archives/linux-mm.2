Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0A0DCD343F
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 12:44:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6375C6B0095; Fri, 15 May 2026 08:44:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60D266B0096; Fri, 15 May 2026 08:44:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FC856B0098; Fri, 15 May 2026 08:44:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3EE1D6B0095
	for <linux-mm@kvack.org>; Fri, 15 May 2026 08:44:02 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E9E021C15CD
	for <linux-mm@kvack.org>; Fri, 15 May 2026 12:44:01 +0000 (UTC)
X-FDA: 84769621482.24.2827B92
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf28.hostedemail.com (Postfix) with ESMTP id D2FA6C000B
	for <linux-mm@kvack.org>; Fri, 15 May 2026 12:43:59 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dykxnP4T;
	spf=pass (imf28.hostedemail.com: domain of elaidya225@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=elaidya225@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778849039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XYm+RK+GFSRl+9igtw82HH43GYD2uH0hgYBQXA1Kmt8=;
	b=Yne26z7oGzkeZ6Cxv3cvwrB4c5PiaYOkycBqhRd/iLK8DG1i9JNnSi04rFPamuxqGqaFTS
	uaTAAnbmgOL+iNDCI293REgnw+tgRkLEVzM1+LllQmgWWn5E2p2BB/KUWaKXFA2uKCtf8Q
	iTbsEqNnKc2xsDKpFk8g028VhyWJ6vU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dykxnP4T;
	spf=pass (imf28.hostedemail.com: domain of elaidya225@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=elaidya225@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778849039; a=rsa-sha256;
	cv=none;
	b=VWVrtm2sWBXuXNdqLP2Oy7QquYEq237081A9RdSifyFzpRkAq9B1wCMp09k5A7u6gvqrcJ
	CgV0MLHobGl+NL7jTfZMKsLX5PQhPS3szNJrDmM++reWuijtSm8i5pr9oV41S6E7ZOVQD9
	PrLSp8mygE+2RQ1ZylLylEcwMBIgyeg=
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-43fe62837baso4749426f8f.3
        for <linux-mm@kvack.org>; Fri, 15 May 2026 05:43:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778849038; x=1779453838; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XYm+RK+GFSRl+9igtw82HH43GYD2uH0hgYBQXA1Kmt8=;
        b=dykxnP4TpZx41/3DSXiJKbGL+WuZJq9K2kmvyuqDGJWb3sjMqVB/0rmlZLY9niDWj/
         2TQCdMEXsMarCcFs/Aae8jJ8lyF3nE42lZsFM8HhYb2WyDOrq/+WpyEsk6a+Z9a0uCvp
         JjrXcIjVbjqKYXw8E8GApqpZvWqSiBk0k06Dk27P/EjJsRr0j6yq3TM613dfRiHpEGps
         SPAiKT1VSFDW3e8sosCoKCdHLYhQj+KKhAF25u/b/B/QPqnGa+BZ7FBvjQaHnn3rCh/8
         3z4JtwlNFtEcKg9dBumyVevg843cOnHo5Ox3Z+sN+pgA+aYo0kC+1pOHstzxOTdZu7wW
         OWKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778849038; x=1779453838;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XYm+RK+GFSRl+9igtw82HH43GYD2uH0hgYBQXA1Kmt8=;
        b=b7YWSrEhIyZkILA/BP4glakMvm3XvVK2s2uMkoXCxWvRXATD13GOohi4xz6/ubDyMQ
         rsoM7l86tM5jnk094SKzxxHeuxdnR7yKFv+Cnvp6V3x04GKcu4xSYYKTcvZhlvSIdx8Z
         XPxViyVTPoZnOrHZhUNFfnClFZ4od/4Ric60p6C2vXiUP/jdsxPOP7luOw7sIH5kg90U
         I1ktMU9xytfpEMl5LcubHCZ6jJNC9L9IFWmQnsBUXeQso3gSCj7Ho8Mv4AT7td/HlaRE
         DY83yl6XNXpHI9v7ME/t3EHenMoV9a5bShg8Xiy9MfsMY0/Q+tqUtr55CqApNePnujbs
         oDig==
X-Gm-Message-State: AOJu0Yxw3fimDV52sstGgKxFGw4ruB0IoCOyf3lE4PwAfEGrTtPcfuAQ
	fQvgXwNCeQXVdiKwlH04kiP1keLRCt7eyYTKXl2+dD3H+8GXSS4dx3pd
X-Gm-Gg: Acq92OGeHZ+tHWPldEXR8LvUYWZ48QsEv5TG2WnCmxXik0ozCWcEBDZoF/N1lDnB0Iu
	L4DIPUNXa4efZKSJ39kiUlRqNhbSsRRdtoUSBskFkYsXG6G6BBA+Z8OZDKcrhUFsLhNRTGPy1Td
	bLpKLQDANz6vvBkvKVRGoY+TPUjT+lrFju0soM9sWxQqc5ozQIs4K4U2B2eN67hce2ECG1NtYtf
	4CVcj/ZaRaeeHkNXz2iBUrKyAQck7dlsDsxYcRqfGkTgE3ueai49qX767cv7sctj3EpiNOOxzvW
	LhSJV50PnsqRc226MYDdZ0UI8PUNMJyuhWqaslFut1c3xnrNC7uX38455HUOEWucgGHenGWfpQK
	ck5UbU1AuPb406SkcQF3Rnj94RfbOU1G9Z0wHDyXXPS44dOO85gu6fkPpqDXu75tEac5L6UNp1n
	6iLN7+f23UgaOKU/Pn0kejbR/MsEcpU9yGxzS/nIdJ
X-Received: by 2002:a05:600c:4fc9:b0:485:3abe:ab86 with SMTP id 5b1f17b1804b1-48fe60e3b17mr50567285e9.4.1778849038068;
        Fri, 15 May 2026 05:43:58 -0700 (PDT)
Received: from fedora ([156.207.183.142])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fe4c8344asm100188115e9.1.2026.05.15.05.43.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 05:43:57 -0700 (PDT)
From: Ahmed Elaidy <elaidya225@gmail.com>
To: stable@vger.kernel.org
Cc: linux-mm@kvack.org,
	akpm@linux-foundation.org,
	ljs@kernel.org,
	avagin@gmail.com,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
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
Subject: [PATCH v4 5/9] mm: introduce copy-on-fork VMAs and make VM_MAYBE_GUARD one
Date: Fri, 15 May 2026 15:42:15 +0300
Message-ID: <20260515124218.151966-7-elaidya225@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515124218.151966-2-elaidya225@gmail.com>
References: <20260515124218.151966-2-elaidya225@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: uhyiy53nxx6k3nnuxe7f6nnz1d5icork
X-Rspamd-Queue-Id: D2FA6C000B
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778849039-47050
X-HE-Meta: U2FsdGVkX1/S07qj9cqPFBDslW4/snmEiCpKrbLFx3ap+gwJB//71aMqJwjzP0A5wzLy2j/As4wGvh0sNzBlbjH0JqVKJYAH9iYG6LyR+Jdpvob2KbTWwML+ZALLG8YXF5UzVmhXbXVVf/xt2jn0jWAHtBWMYark260xhJQFEzB3NUpCLOCZ0da+B6Pl4vX/OlgM1yUfRKiFFtSfZOISn/AJZHMHL/xb2kBu74+tDvimrA0mvPmq2q9JZ4pMXVf/yoSs675TLnUM9IddPOsbZl0o6FiiZxKpUXvccDesjIPTJRU39dGHFYQGeJ4AV1TL/0AlpiVj66ip1wakqBodLL4CwMYdro1c6h03HOpLUjzr2xTBE93SCGevRIZIVuItug8Z7S2i7I62HvXEGz6VuifyDDX/CeVcXc2fJfHR9A67ZLXCHHLmlWBuzh1gasn2t5Xz1nK9+g+Kl7eAKRYAuUxKcQ8gvvSeFX4j0PAuT/kqqA9DATTcMwVYPWGQRHzRU1AkRTzkXmLxkyKvNvrAkAoj5g8uU2L0tUzQmbcO+/ExyUUwYl1smgwCBmjSpGeue4ZdrkLGW+0dCZ3O88OPj/j/eaFaUVIzQR2rc9c1fzdXVxQAZqsdxEO9cfEx07OeYBSFjqy2wuIYUJxk98EyN7QePdt9h01jp8ql6KQOW+TcboIOjowvGnvxr3h4N6R8QOcxo17VF4SJVwrY06cWD6TI00KRiNfcTblpLdkbUyw79HvK4hYM3eXJBnd8o2Hb5peK/UfTQlNh7LMzEumQOGPWvZLkra3WBe9OqaegykzeIqP2AbCo/M3jzdHK4A8b/6ZUg+OZeDH4pI5fYTJbKJUIK42qejRyNFgL+Z2FxgXH1QQxqcjysLN4e0P9tj9ezjNV6DiNeGxq+Pysw5alafkRtf4Xz+aE7tmgqqb+jX5+axfd3ocjxNUkmjt9yHpK4Qv7HN0kLJrSYZE3w+X
 gENgDQRG
 fikMxXIDWxbeZvRpadaWBo905RY/SMgCfCY6zCSyDG6D/UyRw97XErMn228pg+QTVCFVE8wGY46DOpOhz3ZJMUscn23FkJd8CpjkzssrBNgD3HfLftviF4RyTZ6Df4H6PwT+LOskgILWqw6yj3VQ84g9fvQihwWEE4DI6ifjZHtSbbwiKzL0BPsD0ELwm1bzSCqIPTm3kHyDuMe3jjbJFrNhEWDBxTcmzHR32FwEFNeO6VXAkbPzYrv+WEDqeDXswaQHlHaYpvh+7jZ7XO/c4bFzrtgQyC3+GRrzc0b3nUNkljR0kJlhh+whPqMtRsYo9VgGSczEb+nyjg2PIrEggtA7Tb86ZIgIxzgA5c9Jz90JXGWaggNqMNoafizcYAfxkcsSsUSuLYYjMHUu933boIM9RDSk6HQDapGsrxeBQNal/I8VawkdZRlykSuYWmwLgrU3AtitSoCGWeToXlm+nksOX9uVJ/5MGpKDRjp6MSeEgdhvCB5Ck87g/41cQRsI0BCnKRwFZwVdvEJd+3hR+SMdi6AWMafBYsH9X+xNHlRJpftU/MiFG9p6M3ICl2cXFzCRy8xa1GA+6floyrUzlXlusGzgquq5j/XAtERIP2v8QfBy++ytMSHVMtFS5dQBdxF/VEas7PcYzuFvO11jkvm0ZJFQ9YjHL08K+Oa2Q+j8TzKN5MXeT5oOkN0E2S1ZOn30//+GGeKYOT5dBeMKdOa87q/lzKmu13t/U09pmy/Fvde1+vFm37zx9vibrK77LkcfCG7m6nijfvjbuB9f2QJ1v0KDhAqRtCiJm8obiOxkY7R4TozbubTUt9dRUWGNdA8UXE4VDAHGYnkQBLmZWBYOyd9Xk8U12ppiK+d4bIQQLOuEoaMaYXqt6PTzoyd7cwT8MA+xpbA1a/+mwp8gJVYfnGiqU80UAldqKRnjsxJcmjZlEcL5XM+xTop3vtnX6WaG2WYJzcN4IH38=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Gather all the VMA flags whose presence implies that page tables must be
copied on fork into a single bitmap - VM_COPY_ON_FORK - and use this
rather than specifying individual flags in vma_needs_copy().

We also add VM_MAYBE_GUARD to this list, as it being set on a VMA implies
that there may be metadata contained in the page tables (that is - guard
markers) which would will not and cannot be propagated upon fork.

This was already being done manually previously in vma_needs_copy(), but
this makes it very explicit, alongside VM_PFNMAP, VM_MIXEDMAP and
VM_UFFD_WP all of which imply the same.

Note that VM_STICKY flags ought generally to be marked VM_COPY_ON_FORK too
- because equally a flag being VM_STICKY indicates that the VMA contains
metadat that is not propagated by being faulted in - i.e.  that the VMA
metadata does not fully describe the VMA alone, and thus we must propagate
whatever metadata there is on a fork.

However, for maximum flexibility, we do not make this necessarily the case
here.

Link: https://lkml.kernel.org/r/5d41b24e7bc622cda0af92b6d558d7f4c0d1bc8c.1763460113.git.ljs@kernel.org
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Andrei Vagin <avagin@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
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
(cherry picked from commit ab04b530e7e8bd5cf9fb0c1ad20e0deee8f569ec)
Signed-off-by: Ahmed Elaidy <elaidya225@gmail.com>

Cc: stable@vger.kernel.org # 6.18.x
---
 include/linux/mm.h               | 26 ++++++++++++++++++++++++++
 mm/memory.c                      | 18 ++++--------------
 tools/testing/vma/vma_internal.h | 26 ++++++++++++++++++++++++++
 3 files changed, 56 insertions(+), 14 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index ebc5fb0af5ce..2bad4bf67d0f 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -538,6 +538,32 @@ extern unsigned int kobjsize(const void *objp);
  */
 #define VM_IGNORE_MERGE (VM_SOFTDIRTY | VM_STICKY)
 
+/*
+ * Flags which should result in page tables being copied on fork. These are
+ * flags which indicate that the VMA maps page tables which cannot be
+ * reconsistuted upon page fault, so necessitate page table copying upon
+ *
+ * VM_PFNMAP / VM_MIXEDMAP - These contain kernel-mapped data which cannot be
+ *                           reasonably reconstructed on page fault.
+ *
+ *              VM_UFFD_WP - Encodes metadata about an installed uffd
+ *                           write protect handler, which cannot be
+ *                           reconstructed on page fault.
+ *
+ *                           We always copy pgtables when dst_vma has uffd-wp
+ *                           enabled even if it's file-backed
+ *                           (e.g. shmem). Because when uffd-wp is enabled,
+ *                           pgtable contains uffd-wp protection information,
+ *                           that's something we can't retrieve from page cache,
+ *                           and skip copying will lose those info.
+ *
+ *          VM_MAYBE_GUARD - Could contain page guard region markers which
+ *                           by design are a property of the page tables
+ *                           only and thus cannot be reconstructed on page
+ *                           fault.
+ */
+#define VM_COPY_ON_FORK (VM_PFNMAP | VM_MIXEDMAP | VM_UFFD_WP | VM_MAYBE_GUARD)
+
 /*
  * mapping from the currently active vm_flags protection bits (the
  * low four bits) to a page protection mask..
diff --git a/mm/memory.c b/mm/memory.c
index dde20cd5fa5b..1dd68a0e2be4 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1463,25 +1463,15 @@ copy_p4d_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
 static bool
 vma_needs_copy(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma)
 {
+	if (src_vma->vm_flags & VM_COPY_ON_FORK)
+		return true;
 	/*
-	 * Always copy pgtables when dst_vma has uffd-wp enabled even if it's
-	 * file-backed (e.g. shmem). Because when uffd-wp is enabled, pgtable
-	 * contains uffd-wp protection information, that's something we can't
-	 * retrieve from page cache, and skip copying will lose those info.
+	 * The presence of an anon_vma indicates an anonymous VMA has page
+	 * tables which naturally cannot be reconstituted on page fault.
 	 */
-	if (userfaultfd_wp(dst_vma))
-		return true;
-
-	if (src_vma->vm_flags & (VM_PFNMAP | VM_MIXEDMAP))
-		return true;
-
 	if (src_vma->anon_vma)
 		return true;
 
-	/* Guard regions have modified page tables that require copying. */
-	if (src_vma->vm_flags & VM_MAYBE_GUARD)
-		return true;
-
 	/*
 	 * Don't copy ptes where a page fault will fill them correctly.  Fork
 	 * becomes much lighter when there are big shared or private readonly
diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_internal.h
index 19914c28977e..6ee803873e00 100644
--- a/tools/testing/vma/vma_internal.h
+++ b/tools/testing/vma/vma_internal.h
@@ -145,6 +145,32 @@ extern unsigned long dac_mmap_min_addr;
  */
 #define VM_IGNORE_MERGE (VM_SOFTDIRTY | VM_STICKY)
 
+/*
+ * Flags which should result in page tables being copied on fork. These are
+ * flags which indicate that the VMA maps page tables which cannot be
+ * reconsistuted upon page fault, so necessitate page table copying upon
+ *
+ * VM_PFNMAP / VM_MIXEDMAP - These contain kernel-mapped data which cannot be
+ *                           reasonably reconstructed on page fault.
+ *
+ *              VM_UFFD_WP - Encodes metadata about an installed uffd
+ *                           write protect handler, which cannot be
+ *                           reconstructed on page fault.
+ *
+ *                           We always copy pgtables when dst_vma has uffd-wp
+ *                           enabled even if it's file-backed
+ *                           (e.g. shmem). Because when uffd-wp is enabled,
+ *                           pgtable contains uffd-wp protection information,
+ *                           that's something we can't retrieve from page cache,
+ *                           and skip copying will lose those info.
+ *
+ *          VM_MAYBE_GUARD - Could contain page guard region markers which
+ *                           by design are a property of the page tables
+ *                           only and thus cannot be reconstructed on page
+ *                           fault.
+ */
+#define VM_COPY_ON_FORK (VM_PFNMAP | VM_MIXEDMAP | VM_UFFD_WP | VM_MAYBE_GUARD)
+
 #define FIRST_USER_ADDRESS	0UL
 #define USER_PGTABLES_CEILING	0UL
 
-- 
2.54.0


