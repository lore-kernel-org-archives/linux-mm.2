Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A63AFF8851
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 21:13:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 003656B0092; Fri, 24 Apr 2026 17:13:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1D2A6B0093; Fri, 24 Apr 2026 17:13:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E33776B0095; Fri, 24 Apr 2026 17:13:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D09DB6B0092
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 17:13:42 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 940E9A012F
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 21:13:42 +0000 (UTC)
X-FDA: 84694701084.16.D5BD39C
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf02.hostedemail.com (Postfix) with ESMTP id A6DE28000B
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 21:13:40 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mzpTFgkr;
	spf=pass (imf02.hostedemail.com: domain of elaidya225@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=elaidya225@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777065220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0958+TQb7qAfxErMIaSt5ikd6IjAeaeyLXm9i3E0xg8=;
	b=EyUOm/JA1TN+QQqQm3DLMYQZxP7Fao/glpJIE5ep2tJVAcUGx/nj9Td5r2jyZ+HvMEfrSS
	jVBW/Nd9j4X7nI+As4JopYrrS4iYo2bhdwckeZuyGXMi31J0x/fUFSYchaueHt0RMYWtyY
	Qk58lk0GwhYR+Q3Xu4IuR3YeIMoQiPY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mzpTFgkr;
	spf=pass (imf02.hostedemail.com: domain of elaidya225@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=elaidya225@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777065220; a=rsa-sha256;
	cv=none;
	b=f/mGeI7eBATHx+i2MmmjunW2IHmP54M4vSctzA2aPQ2ePc+887UhpVlzETHiVyr3++CtKB
	IuD+uGhElFWnR9EhrzS0ITZDZXTad8jYE/SIKVkpj8NxO/P3rOT1l1mPXMkuXplfToSPBE
	J/vq4uHlORanQLKbz/6a0T8Z5f1oPhs=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-488b3f8fa2bso82869395e9.1
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:13:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777065219; x=1777670019; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0958+TQb7qAfxErMIaSt5ikd6IjAeaeyLXm9i3E0xg8=;
        b=mzpTFgkr5aPW6awzX6cxCMAe7HybmKq+XBDjo9hK9NmpInzLCJH7OiUtt56cCdhVEW
         5ema3KZ+kdEBOZk6KPOSmfBGi5iZ1ZIp2rJ+oMoO657T4QWSYz/MoMIzQVGAQWtpBafb
         DBWw3MiTMhfRr3pNtZ+8xiBOXc0wrtm13N2cpYe5XY7To9WbFPZbb10wv89FCm0jWZtX
         GucMgm/NFnXgTPKLWwp34Qa6oXbIo3dmGgVqoLO8tqGygynmOkFe2o+QXc33vplNWIBQ
         LtcNQCW+OP2Xun6eyCwpuL/tb1w3ptLv1sp7mnCObWVKhQoqgc8XbhP83SNkxTPb8uF8
         AOtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777065219; x=1777670019;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0958+TQb7qAfxErMIaSt5ikd6IjAeaeyLXm9i3E0xg8=;
        b=lG2SXFbwOOH9l3S5tKbvqPDVJXrcRGkfkfrxGkTZdKxtP8hUJK8Nusw71HzefeKFg7
         tRlgeOoL5L2ShOQiiZHtxxHcyTDjklla2kQA6zxfiDrV7wzzs7kWs1rT4LxSVMmuJC60
         jb3k7BxmaNKyWgKBbUxic0kSx1b61Sl/JQKEUHdSjIJjSniI1NJBOainWeaNqXanASW/
         h8TdoNiathcli/pPVn94/1GZebvBTvapYMAkAAAO6IBtXVD0j15OI/cXq8mXNgAoluco
         /4Ozl3wmCKl5EMD1OMTFByiH6O7XX5AjMIs+oe854miub/hVI8nZcHzFlKbrXQDgTILR
         7YcQ==
X-Gm-Message-State: AOJu0YzGRuluDSIwVgwyxpoNLg2SugErfczuqUeHJ+BKKttGRFRJ67xM
	O/TRU2gPYM4ogbSzLZfn9mACQJLFWY1Jff13eCLO8j6PF6iu7Zw8ZWos
X-Gm-Gg: AeBDietJRCVbZsY20Uavoyf90CW6Ul8qANhcNHldKFK81/c7t5ZTgAwaav9JfW4PAOJ
	25RRs8uEhzxhhO0esbUayeeTPb0BveBwTg7NiUEyXiZfzMSsAHIUFAmsxiuNIxEzGsKTJyqeVhR
	r5yoiTwMLsv7bPaz+N+UIqmQD9v7kxhj0vzKvrJblLTypNyNzkC1UIEcTgF8A9TRdYJqdlHOZlO
	+bPsWt/NpMmsAlxlIsgwhqB0tFmKFuvK3eVsmZ8QLR7csM2clekJFHluxNmgpNY6qMatBfarsF2
	GiZ4bMRvwbt0f0Si4wpJoGj4iUhD7Ne+NImyRilHEbhhPbryAbcdm85Bn+BHs4J5SN6IyT6A5PJ
	1Bmne+yRl+N3lOb3IS/eRA8Q2LzdM/yRC/x6/cQtyKSyGIuUjqTGWCjtAeT/xyJVaISrNzy5b0i
	I23tsVn/l3i7Ac+UfQ0e0ikg6TfOl/Kg==
X-Received: by 2002:a05:600c:2256:b0:489:1927:5c0 with SMTP id 5b1f17b1804b1-48919270787mr252333975e9.0.1777065218866;
        Fri, 24 Apr 2026 14:13:38 -0700 (PDT)
Received: from fedora ([156.207.128.125])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4cb1176sm63845677f8f.3.2026.04.24.14.13.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2026 14:13:38 -0700 (PDT)
From: Ahmed Elaidy <elaidya225@gmail.com>
To: stable@vger.kernel.org
Cc: linux-mm@kvack.org,
	akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com,
	avagin@gmail.com,
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
Subject: [PATCH v1 3/9] mm: update vma_modify_flags() to handle residual flags, document
Date: Sat, 25 Apr 2026 00:12:37 +0300
Message-ID: <20260424211315.1072123-4-elaidya225@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424211315.1072123-1-elaidya225@gmail.com>
References: <20260424211315.1072123-1-elaidya225@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A6DE28000B
X-Stat-Signature: dsicrujccmgyeg5hpe4f8gaojy146o46
X-HE-Tag: 1777065220-281200
X-HE-Meta: U2FsdGVkX19RdIKys6JvU4aO703LkeWfTH8P5AmSVWMcbn8EmCXCoimKcwKUb6TfZI6MX+LCG/h6pU8M8EZHKXGIhh3H6IewYpJwddcI8cPFNJPcG+5p+9Qtx/biuXAdix5qCyg4+7a1KHODBVR4D0pD8MlVoz+1tuuIz9g0Gu2X0MPPXD2pqD0r9hQi/SRkLUlnrvvUdWJUur6K5t2fIAL9DfntGhidjxFqhUGbuuzuE/KeMrP20uRNUWPvOFWGczzk7gC9Lm5qnbdNoddVFkMdRHddg+amMKJPKGgF5L6DgYXcdPKRugwvMXwEPvYfDs4jwc9zjyk8tMoLUs2MJD7AKtnXUQmrzR1JVnBD/0k2pvMxUd3uYjPqDyFA77yBex3QRBZaic7nxLQE+oldHesxCVjLjNRRThpYx8eWHwhC67Rushk34i/A+Qqn/I9g6UEfWe3X3sUTDAgdYgdNAs8qJNmcoEB23gjvKl3zLoZkEjRAgbSMD3GcnKWTNR9zRiedQGVjpxDH2Wwt8rdsjVA8NuW3rx4oRY1UB0HAtG2tHi5Y3tpnvRnovd3/FYrZhUT9HlD2xOGJTJFTXCFF+/uXr2krDLhzwATUOU2VguNBOSxYZvtLCm2dm9rP/qPNHHqZDrR3yfEBl4T74uqDtiJWb5jFAAizVjt8Tdf/2s422AmOcsFmwCC4RaXwadYECChKIFmiKwpiKhc0LrZvoViFxoFjQ6aVoeyfAYEklMwoAT8P9OfnAcoCA2+7yHpFCHUm15TvNVB5+qGgZ5RU+W9XBYE/klwP1qhTiy20HPmSHngL099HHNE9SqQbhq61bkOTVzU4eJDClPtthQRyNI44p3YUJmIK1X4VGvFMmXwV4g3l/OjX6DkeOaXy7YEtoYw4mlwMyvMffGiBvo5bLluMFE5ymtBiXt42yY4CMnjU9/n5Hy2lyNIXChuUT1u3wAnWYDorLiNZGb9RJl0
 CdWfw+b9
 H/DAQi6ZffjzqhsnrVSFDamx+0aMWlCyRWETmtI0d2lPMTnvUInTwnAyXD1NnfVh3UR3jcSuiPfIlThqq4NY5WNLwA8exiOpiFT9vlkYvuInBhyPgKO3RSdjCseTrAppq13mmrRARjq7hh/ZqypisRwvWIoXy7L7gKZzDoFpBBL05ch5rg1sr+gAgZSuGapPyZ0gRYUfTw0CyUyzZXkh1RZofltQ2aiYZJLd4O9+cj8HJ39A3dRHTZOVhhSSvHGvrQ6ctQ4H4yB7fHCbzVaXqnQSPfOnKaI0KKWKzNxrwvnmc/xQ8eqD1liLYLm55LWe+SUCRx8hhVyQpVCXdr5PFwHdV/yRi7VN6hahrKu+JK1o5c/XOEF682UuwILqyNLFwEOodoekslaY7MpL9GutC5Rb/ovRwWE8xnNYDgQ0VkLPWHHXUrXgQznsYIdSHbKPot4p1e4iD7pGwlGvYx+seydGr89OheVA0Ez1VcH2q0/o4bi+wEc5lV5BuxQkrNDvg4HR1cZpu3fkxIGOaMK6qlARyp8Hpadv8noAc1nIPE1/YNEEwqKWn7hEfqBdEdR5OkOeH5FJA0q+l4oUx8NhD71dNTTosJvl3DlCeW/yA5fWUHhl99vNjDc/33gUA7+nZD/m25W34XD/JIA+BbTxYeNvpnE1VKdqhVxpustsWG5BmRVE7ZEKbXjRli8P310vHiZQFKBIY7ZTukwHISTIW0DNBiYyUyz3fajcQk+fLLc5y6DdpFnCYvGTpDLjiUf6RDJfrVYZeNW0jQjW4kqpZKs9OK5+bi+rzdwnbp6QIcQgQcaWZe/dvZZ7gEU68iIrqGeRUxLQ4LkViTlFYgw+j+gVg0LRVzrD3xKVZ+8chp+DD9++vXp4tOhwwCK2zHADnIGnh8nEkLAVJoHotUzw1tt/7XEL8EuSoGrIE+Ywa0eQtLuzOAuBuBePUQb49ofls4Nr8+WllN8gQYP10YhjHqr6b5TI2
 CEdy2gL+
 Zo9MP1qhB0Gf3EqSiltCOmO3bCMOOh2z2i8TYA2iRtH7p+4ucMX7AE55ngo224gU
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

Link: https://lkml.kernel.org/r/23b5b549b0eaefb2922625626e58c2a352f3e93c.1763460113.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
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
2.53.0


