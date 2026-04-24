Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2884FF8850
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 21:13:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF7C16B0095; Fri, 24 Apr 2026 17:13:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECEA16B0096; Fri, 24 Apr 2026 17:13:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE4F16B0098; Fri, 24 Apr 2026 17:13:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CF8DB6B0095
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 17:13:49 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 690F8140119
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 21:13:49 +0000 (UTC)
X-FDA: 84694701378.11.3D0CF26
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf17.hostedemail.com (Postfix) with ESMTP id 62E9340012
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 21:13:47 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hKDd20JN;
	spf=pass (imf17.hostedemail.com: domain of elaidya225@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=elaidya225@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777065227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rZ/6HUw5dElWk7B0xLynBcGoo6YPR5w98Vo1tEio3a4=;
	b=DSsEv0hvoTMCq3+HMCBF1QdAHvMr0mmFxXBZNF3xyvx7uG6LIR5qFJMj/qYcw3cOzurE4P
	6XOZ1wKYuLQBXjSKEqnccVDq/yVvZH9Sjzp37ElUqKNxhxuTC1QKWXEk0WN9ly3irqZWdh
	+N05QX9RrWaQyMQiyvZY91AKnMdz/8E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777065227; a=rsa-sha256;
	cv=none;
	b=Y2DLIdXb4RMOd0ZlQ2lGPqVXW3DqSDnaz50Uv+1xRnO0AmDQJbOQCVO/y9XyHdY9Lfo2F8
	OoWDQ1ZsJ//i9dbDksg1DzMSZWa4zTTaC3r/rVbbqZXIhRBH3mFcpVOPCFJCBPYjU7OXsG
	R8JsiykrNBp3DI8VvR421wwt3lioU9U=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hKDd20JN;
	spf=pass (imf17.hostedemail.com: domain of elaidya225@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=elaidya225@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-43cff5dafc3so6629782f8f.1
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:13:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777065226; x=1777670026; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rZ/6HUw5dElWk7B0xLynBcGoo6YPR5w98Vo1tEio3a4=;
        b=hKDd20JN2djWyO5F3Vs4TeI2u8vwUknUzCN3oCsyKb2LzlHzso64v19+zD9OrlV2Dn
         fzPp5g333obyn/UQD3tgtdldsgBdXJJW9EF5okPCVTNcmSUyr7YafKGHTzfWCoqRFUkH
         kWqMj3ousp7nqKVyo6pGrwd21ZfHktyhaWdE8wJ0Dx2emb1akU1yYBJTq+m9kovurOXf
         h/wSEftjUszgMFBb3h1u3Hj+Cl75EKQTdInNdOg9bLsKF+4BO+LUIyRpa+0Y2af9y3T9
         YWkviHLiD8899Kw/ofReIhAXRm4KMep4kXpg6E5PNzx661inXq7/9Qv1BrDPFp/0XBzD
         VxcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777065226; x=1777670026;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rZ/6HUw5dElWk7B0xLynBcGoo6YPR5w98Vo1tEio3a4=;
        b=Mg7y2nR3iJrgyzTI6VHYF/piIoHSQS7IAM2Dt67iwVdzjaKii1qFSARneJmtlLIhhH
         F/FhyAYeRLE2aFO8+Zn0EQ2mgKy9apXnADoqHKBP9YQYx8ExQuyIK6biahriRanA5GJR
         UN7ZqnO+6NdmCbsQ27FdueSwsLROhOakLyCPTLgFGzQdy4zsDNtygqj8dthrKEc0LOUi
         7q4CljIrG2jcYGuXndHOCpXetyOi0Q4Gtkof/TnRYmOudFhcTmeUziH+SF5ItUDZd98F
         8xXkf0fr/moaDzZVnA7oyw7DcvQeMeN6BH8DvN0YFBPh7q/pqRRGVFK9ZlGDsJQCKazG
         urEw==
X-Gm-Message-State: AOJu0YyayngOwygi8Nuvk0osOfaEJifMLA5HBqRCIFajBzPkMr/sbPng
	AAcJajgN+n86pMCxnNTFJvEtkdPxfr3LCXnFdJr0yZmA0ZuwHJwAqxwN
X-Gm-Gg: AeBDievage21Offq8lP9q+Vzsj5kQnUzqiqyoYiaove3/CTtH01WjZqcAPa4oH04QQS
	ceAhCr/f2KeWRr/t87VMLWbdfkbxPx1TtxniclICcD88fBcCNtZT9eNV6sI6/dcML2mg5eGGYw5
	XzrnPqeKcqXKbsLnhK11m1jniY7EFFuodpVHV6UYSn89cZtxgj1rRsoQIf5Q9xHdf2SzktQd0f7
	f5yCVq3IxDCmIbdPnP8QpnVMogc24jLEltLedYouRk1ZVRQYQHy+ZyT4XBMOn4rwMK7XqZkssn/
	bESMULW+IHDqbTI+rLPBF6yhHHAk1xtebI74IVrkHb60ZNJ7eIzf9Ka5pszH77viecZxW7kvpeo
	3o57Jhqd0N0KTtq4Yk9PWmw+kavgVaHbdEtYR3wiHaQln1U6635mSD3DnBAfaK0mWW42j/RSKNe
	0B7Cm5RHT/wby37SMKjYHgSdGaHX8m9A==
X-Received: by 2002:a5d:5d83:0:b0:441:1e41:19c with SMTP id ffacd0b85a97d-4411e4102d7mr27409657f8f.20.1777065225832;
        Fri, 24 Apr 2026 14:13:45 -0700 (PDT)
Received: from fedora ([156.207.128.125])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4cb1176sm63845677f8f.3.2026.04.24.14.13.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2026 14:13:45 -0700 (PDT)
From: Ahmed Elaidy <elaidya225@gmail.com>
To: stable@vger.kernel.org
Cc: linux-mm@kvack.org,
	akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com,
	avagin@gmail.com,
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
Subject: [PATCH v1 5/9] mm: introduce copy-on-fork VMAs and make VM_MAYBE_GUARD one
Date: Sat, 25 Apr 2026 00:12:39 +0300
Message-ID: <20260424211315.1072123-6-elaidya225@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424211315.1072123-1-elaidya225@gmail.com>
References: <20260424211315.1072123-1-elaidya225@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 62E9340012
X-Stat-Signature: uun14h7b1f3eq7neo1zo4y66trkcsmg3
X-Rspam-User: 
X-HE-Tag: 1777065227-26059
X-HE-Meta: U2FsdGVkX1/ISxOTB1CSiAM81Y2vfPZwqDugoWqbkdCrXfVlM0a7JayjfI7NFVSErzhlJSUBzb6Zwn7J6I8SWBcd76sJ8JzCkPBeNvtnPcpvXbqpFHdADlxtUkjRXPFZKeAm7RMWPO0hegB169um3KmX5uaBef09T7NXtAzvQKiHuiuoO6mOQo2QF0xrq/RZFJSGwQXxMtkYVMH23Vu1i3k+iYmssu7EB1oSBbHxDmTRLNeXgsuAiHDsEB52vU6TXVN3DH8cDkmi7QmvTOJExNdDhH3AfeHwaYY5hKzaK10kow2ZAZBF3B7wtqGtwMPlHD3wJHo/loPxBYbsB1uupjGffufrWeslBsDeTKTO4aX2uXfArGU/NqmEu4K8+Fj1U4MQ24pzGZLsh0ckkmPPRcSJW3wqSEK0GwduuMGm69keCEjirjDiXYjFRm1k080TXw4ZRQ+8XG/8LtMhfgDWJT3DhSKvJOI4yKDn0lFoskrqtDgk96cjycYFxW98nfsW/U+mHsRqe6Fgdiik1xXX2/qpUKDd/oLTbaLYgArxCL9IIMeaOAw9o4cfyGBKHbeoU0tivUvKu8HY04AVNPrBTGNNnPXL+fG/iB0ybyy7LX3sTdx7EfXQcPEDV2taTQ0TGID5SF0sAiN/PJYdDewGaa3qpF7z77gsDlQBUSYQ2RF+4qS5xiAeZXO77FEYoUc2pUo2t4Dl/stsqJBOuoMBFAuv2dcwA9e79i/QkPGcPFknIiIvLwKwUqNjy+rK78Ei1qarKIFLz0Lca0VL/GNapEN+eASPTccFRyH0K3679TlZAsErGFt+0HtNZbWLay40yqOrCHqETlG9osjc0nbWSSHWnqc2GKUfxHgFQIXibHlCjY7suYkN47MfW1EvDSA1vThbksROw/XdlNJLjQf5DBlH9bBKm8rzNsG3HgR1/SIiVU3NPm6WuDV70DCxPRT5f7vTlwHAg61/+tWqjtE
 6rZ99amT
 pFFuLLrR6DpCPHdktCtc/2H45ejeFWSkywAMnZY/+3DEbYPPB67xvXss3rDnrnwGExDLWrTCJWzUQpD/xKAenTQrZU4sw00GeV27/8jLlhfp5T6kdyiYPkYs5IJ/CHYLK5vwvvkUYzJQIo8zeyNHSyoGHuDxtIro1B6efHOwH30ldUZJsmABMk0tgbv7xbqH4ZlXniIZ8ByW5D5ROpdrhQKxTnlLt1r1+J9WbxOmU9Bh8ITVegE9wrcDL0e4ZCEkqbAtVh4VR9PweqBPoih4IpRzbOP+SReVptGbuLOjcmm7uydWLpVdSB2VeChdZHMdIJXOe5xQJAQLwxeYRwSrI5dF990kzoMrE1nr6jHrVMwUChontq2TSgurGbYzmiui9J8tMMBurO/7l3wThVO/4WgVqCiGt9iaLhUTs8SRoTJLZfIj0XXd91C/z9SluE9LRvQGHeUEwrY+5oBtEFb4Uw8eArcZ1SjF9QkrYxUZCizoKBpBjlUqZY3JwVszImDSZC6p10IFIymWbnxKOmdMnYQGkUkgH/WPucgKiuumQViLfoSp/jBUagSrX7c0cKWmN5Y/QAh1Smi+dzvKNWIeIjEwpQWutFVs4dXjLbGa2E5h8RS4QKjZiTd6f5kyGzC36OXjU11RLH2tFOxrFMYPiJ1NOLuEJ1rnwwXKp43fih/ETgiew0oozQMK3X6PXbJqnyB8Y5NwsJiEulixBOhUCCUZSFIuWORocdG8KjVmYxsGDM46/62DhPXcDmofxVE/mBxE/HoIH5E5gH64Vjh50fmjNzOZsU32Ja2KF/TpXkP3Rsy0JiIdcIER9HCrVTN2Rdqnu5wZBXTP83RXHIWRTg87R9pqkQvgG8eSMtJR5ra/H0iee3kGvpIj28Zc7ZMeWPWQFRR/rzneAm4WxEPxQj8TyAXzmFdmhtRWohfZU9D/mCKIKFEYXPBjv7M4WvwTocVj+PK3qNqXyA9k=
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

Link: https://lkml.kernel.org/r/5d41b24e7bc622cda0af92b6d558d7f4c0d1bc8c.1763460113.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
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
2.53.0


