Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FC6EFF8850
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 21:13:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB1256B0093; Fri, 24 Apr 2026 17:13:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A891C6B0095; Fri, 24 Apr 2026 17:13:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 978426B0096; Fri, 24 Apr 2026 17:13:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 84F9B6B0093
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 17:13:46 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2535A86984
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 21:13:46 +0000 (UTC)
X-FDA: 84694701252.22.01A0A70
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf17.hostedemail.com (Postfix) with ESMTP id 25DBA40008
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 21:13:43 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gLUL4s75;
	spf=pass (imf17.hostedemail.com: domain of elaidya225@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=elaidya225@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777065224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1BLQZOnf6TjLPQYnkDewvD/+2jIL5XRBDQmwK8f4mkk=;
	b=r/GbPFMH+xdvsYBsis1zUCCEYP38RfeX/GOASxXeRusLU1nkSo3TV2j4oQOMu/Txs9ygSz
	zRXCy6EHkbu0EoyGewMC47CW1kx+p2a3YYsp4099tgWolWSpbuk9NVlvZuAmp7yxsuxSZs
	D0zqmAObZ9N17i7SVvTFBtc6Upj+Elo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gLUL4s75;
	spf=pass (imf17.hostedemail.com: domain of elaidya225@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=elaidya225@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777065224; a=rsa-sha256;
	cv=none;
	b=szsoZ4ejUmMuCJmMD00BGCbfw6Gw4pB/2tQk4PbPJpFpa1AJc7NkkNbF/aTrJOT3oEK4bm
	YxE038dFSYXeyBhQ0/MF0ZPPbN80+ArZXY4nVkIdYuOigX1XMTdzYV4DDipY8ASBryfPq/
	QTTxh4ka+JHiyAZoyrRJJycNE8nQ3Dc=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4891b0786beso54326165e9.1
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:13:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777065223; x=1777670023; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1BLQZOnf6TjLPQYnkDewvD/+2jIL5XRBDQmwK8f4mkk=;
        b=gLUL4s75Aq7POW8Cc9+H+QJ1jUA2d4YLhBuBSRdYcIjW43DzvWzR1AW5u0ZwY8SDm7
         yuzZIig9+lN1akLJRHg9UN/8ti9AQHfCpIfT7mEMGE0ZX1IHgGJjQzZkyWBwLW/tLZK+
         nQxpVs0uVQvT/BFo39GCeG34jFpmx4tcrxhKbP6WBzemerIYzgvKVBbPKMjwzkobaKm9
         r8QEY52eexZ31FTgRz7+2MO7wl/3gYlKWvXwApZD4w4qhtel8yuXlm7bDC29LxWir8hW
         6ggRDBAoC4V4+AB/EnTaRjKWdmRrBUqLzO5F5fBmvIfxo6jl7rCVbK9s5gnyHVuzEHam
         9UMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777065223; x=1777670023;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1BLQZOnf6TjLPQYnkDewvD/+2jIL5XRBDQmwK8f4mkk=;
        b=gUW86ey749SNDfWbQzdFSb+7Jn/TdWlQFt0XBxKIUa9yWbt1EV9QQSRseR44jYZnyc
         4DqV+UDDGLffKpemU0aBCVVqM67nNao2rOgVzFrxlZjYO/ttV84yVdpEc6z+Ef0TG3Pl
         zU9RF3Noa0CjHBdMEp1zjn0A9j/dVsG7Jn8uwQYl5kg92QucfA8G2GZm6pGo7VDVqlkT
         tOWsb5p3Mum/JkQEEFCH8e0lJ579aNSMHUBSVE6RVxoLo67T3udMOAG17R9xlglAeJjc
         ajDcUTHuSak8XznfJVcdnkuy7BNgl2bl+tUP1YHoQhIhYnmTDPixx/85fEk7xVcp5O09
         CW5w==
X-Gm-Message-State: AOJu0Yx09d0pUmIm7dVMOQschiysEfhp0azfYNu8er8ryQ6JMo7U7Mal
	R56z2dFtzeC2RyEJ2hwdKFISA29E2B4w2SOCOrTlPn96QhZtNFux4A63
X-Gm-Gg: AeBDiesdcrHFwGfT3b/NblNspxesLWTBQ8jW6Sor4PgzFXvBZEYZlB6GAhzUXIDHt4d
	TIEkX7KPkqyfj2DWbID0fnbeKU2f1sC/uZtsjwvDkmWcgH3V2+9pcXK1jBx2UM8HfRjS9E/etnZ
	ZJPbQjqv2EprX2mZmFACFga+ZALVIvsQUd/4aT4PCoY16YMgfLi1eJQL+xrhYpDfQOv2anFd05H
	a5UyfS7pC78FhvdivYblR8ghA7c4vUWhEwaBbaz/YKw9mAiOVfO3g26M1ZNRMpjlprcbtcfKPfB
	Mofw1ccO/jN0w+v6X1za5ThCdC1ayQdRCfF4rar4diP15S5j6ssu+S8pYdUGpUV0Olrmf2cpA+j
	qA03YJ5tAc1g7cKQC7Um8S8SVU92RnftOKferHtBHPbNxgBhVzIqt1PqEKT2vvBu3Mhasq4VGIa
	vvt4RfnRt7YeHDeNmoHAQWbup0awSl4g==
X-Received: by 2002:a05:600d:16:b0:489:19e9:b139 with SMTP id 5b1f17b1804b1-48919e9b29fmr261690915e9.1.1777065222564;
        Fri, 24 Apr 2026 14:13:42 -0700 (PDT)
Received: from fedora ([156.207.128.125])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4cb1176sm63845677f8f.3.2026.04.24.14.13.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2026 14:13:42 -0700 (PDT)
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
Subject: [PATCH v1 4/9] mm: implement sticky VMA flags
Date: Sat, 25 Apr 2026 00:12:38 +0300
Message-ID: <20260424211315.1072123-5-elaidya225@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424211315.1072123-1-elaidya225@gmail.com>
References: <20260424211315.1072123-1-elaidya225@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 25DBA40008
X-Stat-Signature: qkcga8k3odiswgtaibazyj6ia9gwpd4w
X-HE-Tag: 1777065223-87295
X-HE-Meta: U2FsdGVkX18CbboskLIeOTJoQxXTd7OskUfO6rgQJDBkui3GZLsln5FiZfMGsNHkc1B5OkMGIJy1xzJ69LqwALweqcW1BHI3RRbu69tTZrPsvhcdzzR6mxiwLsnwFp+cgZ+Q+H8dxYgQIYSSDsddp/u6pePbC+r3DGdcLSH/LCHqM2aEsEj6MeduoDuxr2yqZcCM6PGfr3GdQyOEcfhsf94fPlcZcO8T4384jsBDJRAtZUj1QYHChM8J2zAkGLZhqFS0VE3N0hLoIyzZpuwduBlt7SpbyA42XmAjLgxARGwkmrPkIC5qMwJx7aI43z5eZjX7ltFOZF3NLeKeL1DVFiRGWvGIKqF+eXkMYdx8x6CCm1lKvojqcBFrTpZ09BV5OkAOeb81e1sU/7kEIAeo7KUvqnjQsQR6iyV5B2btS+RgcpiSnC0KRzX8Qhrb8dFr0lzVvaVxDyqVMcW/7rCWB0Oo5Z1JSg6ZKu+cqyDHdyrUVuMPijo9e1+BymrMVs0+v37VPPMCWymPAY6eewCUqXbxLaMvznfbO/M8VPAA4ZrPA2W4OOnJ7ZXtlx/ttC23PfQNNMYitYlhoVXUtfYeGRtGOet8X/ziIYgFbSSt4x7h5XC6lrT6slIxDVtCFZwHQpHTcq0OyV2+YUI5I5wfvJTN2X6rjLNhE9n/6m/zSKdeevK2FSG4IcB14uSxn1p+VMg4ga+Y13edcvMygIENLUHyTUp3DLpXBsme+gQuEva95ShwXjHYgDm+4L/89rESTFQbCOFCNYKLt+KP+DkqXwYtEfTjUm3ukq+VDhbO8jXwoUPLu5pJoGQQIPqhKd7F/xZacLv9T5UGgEYnDlPnlLhPKVb35CCHOyftsuQOGJzxHF/566lUzgeTimkNOyzQrh4cBRmOP4TVAietZklIAyPjvYtZOP21gbuIkQxQc+G00eKFAJg4nKaXZ13fWt3/Y3GZEHuviZAINbm3Pek
 hGD/fdJ4
 MUDNycpOhXs0vjbZOYCpQlG7/ftm/OVlimYpAiV4tFdoKSpVUHPV/S0dKJHfEbyyHYLRB+UWXYAd4M+nhSOY5Qy+gAWHzOnCwMaD9n/g2tTlUdH0Gg1O0uldEEm33rLBwQ0S2Vewa9RDVbigfv66ihQNCdjYb/ncwFiFJazvzH/FaTMSXIdOG2OOtCd7RF8Vo5/68XTDUpsRkC08MPtgH/qtLObdljOXGRBoxfCzTGUntTdkZkqdw93n/UbTDi7+EA4RKAyYLviUHJv8QqO6PBzEZuvcXQvbALCTjDIjynGxhzNKwo+EzH1c8Jf9a13CgxD6JoXrVywanvlkTcbV5i0EF02QFSOEuJt/VQb02W7eA4pakFDtHv7d91QEUm684bP8B3DgvTBtfKDmuMdL4Fu/6H+8JYDCRtCaZ0E7qWH/t7Gt5kZpINUtHCrEqHYo5wr2/OcBOTbtWU9+32Xntds/F5x2bsiUJf8Itgj0aYPbjCDL8QQymIBzFspC5sdRyCA8YpY2hE/PgDtPn9ybpJXgNhPPQfUyMZB/fG4+Wf8vbp3JKPpYIUAZxHnq7CXZXOePXudc3OYsZrL4IqUihJBaDLCBQ1AM0lWd6VoNOs/w246e018mahcKH2NMOOQ3DS0Ok7LkFoFqeiIDMjVNbvCu9WccvajITQUC4ABZDQI27ya9pl6Dx/cG7Zn0zUIqoyZmcsIVIqle7RYPdDYILgT7JpsEh1srQ52mAsqZjoJgVMDuJ7gedytPbsKAIFZ8ILEazEEr/xOBMQNiGMIdJIvge+/H9OnDMhyij1O2uAvpa8/oMpZfSTQL1yFpbY2txdtD1ue2D70Yd6HdY2AauT/RMNcbXAbvgeWcn//2UaKpGAb5PFCZgy0MBqMozOvjlDMXodYopthH7qgAMmI8HVGma2w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

It is useful to be able to designate that certain flags are 'sticky', that
is, if two VMAs are merged one with a flag of this nature and one without,
the merged VMA sets this flag.

As a result we ignore these flags for the purposes of determining VMA flag
differences between VMAs being considered for merge.

This patch therefore updates the VMA merge logic to perform this action,
with flags possessing this property being described in the VM_STICKY
bitmap.

Those flags which ought to be ignored for the purposes of VMA merge are
described in the VM_IGNORE_MERGE bitmap, which the VMA merge logic is also
updated to use.

As part of this change we place VM_SOFTDIRTY in VM_IGNORE_MERGE as it
already had this behaviour, alongside VM_STICKY as sticky flags by
implication must not disallow merge.

Ultimately it seems that we should make VM_SOFTDIRTY a sticky flag in its
own right, but this change is out of scope for this series.

The only sticky flag designated as such is VM_MAYBE_GUARD, so as a result
of this change, once the VMA flag is set upon guard region installation,
VMAs with guard ranges will now not have their merge behaviour impacted as
a result and can be freely merged with other VMAs without VM_MAYBE_GUARD
set.

Also update the comments for vma_modify_flags() to directly reference
sticky flags now we have established the concept.

We also update the VMA userland tests to account for the changes.

Link: https://lkml.kernel.org/r/22ad5269f7669d62afb42ce0c79bad70b994c58d.1763460113.git.lorenzo.stoakes@oracle.com
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
(cherry picked from commit 64212ba02e66e705cabce188453ba4e61e9d7325)
Signed-off-by: Ahmed Elaidy <elaidya225@gmail.com>
---
 include/linux/mm.h               | 28 ++++++++++++++++++++++++++++
 mm/vma.c                         | 31 +++++++++++++++++--------------
 mm/vma.h                         | 10 ++++------
 tools/testing/vma/vma_internal.h | 28 ++++++++++++++++++++++++++++
 4 files changed, 77 insertions(+), 20 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index a96c99066351..ebc5fb0af5ce 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -510,6 +510,34 @@ extern unsigned int kobjsize(const void *objp);
 #endif
 #define VM_FLAGS_CLEAR	(ARCH_VM_PKEY_FLAGS | VM_ARCH_CLEAR)
 
+/*
+ * Flags which should be 'sticky' on merge - that is, flags which, when one VMA
+ * possesses it but the other does not, the merged VMA should nonetheless have
+ * applied to it:
+ *
+ * VM_MAYBE_GUARD - If a VMA may have guard regions in place it implies that
+ *                  mapped page tables may contain metadata not described by the
+ *                  VMA and thus any merged VMA may also contain this metadata,
+ *                  and thus we must make this flag sticky.
+ */
+#define VM_STICKY VM_MAYBE_GUARD
+
+/*
+ * VMA flags we ignore for the purposes of merge, i.e. one VMA possessing one
+ * of these flags and the other not does not preclude a merge.
+ *
+ * VM_SOFTDIRTY - Should not prevent from VMA merging, if we match the flags but
+ *                dirty bit -- the caller should mark merged VMA as dirty. If
+ *                dirty bit won't be excluded from comparison, we increase
+ *                pressure on the memory system forcing the kernel to generate
+ *                new VMAs when old one could be extended instead.
+ *
+ *    VM_STICKY - When merging VMAs, VMA flags must match, unless they are
+ *                'sticky'. If any sticky flags exist in either VMA, we simply
+ *                set all of them on the merged VMA.
+ */
+#define VM_IGNORE_MERGE (VM_SOFTDIRTY | VM_STICKY)
+
 /*
  * mapping from the currently active vm_flags protection bits (the
  * low four bits) to a page protection mask..
diff --git a/mm/vma.c b/mm/vma.c
index 06609f4116b4..b194ea8cb283 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -82,15 +82,7 @@ static inline bool is_mergeable_vma(struct vma_merge_struct *vmg, bool merge_nex
 
 	if (!mpol_equal(vmg->policy, vma_policy(vma)))
 		return false;
-	/*
-	 * VM_SOFTDIRTY should not prevent from VMA merging, if we
-	 * match the flags but dirty bit -- the caller should mark
-	 * merged VMA as dirty. If dirty bit won't be excluded from
-	 * comparison, we increase pressure on the memory system forcing
-	 * the kernel to generate new VMAs when old one could be
-	 * extended instead.
-	 */
-	if ((vma->vm_flags ^ vmg->vm_flags) & ~VM_SOFTDIRTY)
+	if ((vma->vm_flags ^ vmg->vm_flags) & ~VM_IGNORE_MERGE)
 		return false;
 	if (vma->vm_file != vmg->file)
 		return false;
@@ -810,6 +802,7 @@ static bool can_merge_remove_vma(struct vm_area_struct *vma)
 static __must_check struct vm_area_struct *vma_merge_existing_range(
 		struct vma_merge_struct *vmg)
 {
+	vm_flags_t sticky_flags = vmg->vm_flags & VM_STICKY;
 	struct vm_area_struct *middle = vmg->middle;
 	struct vm_area_struct *prev = vmg->prev;
 	struct vm_area_struct *next;
@@ -904,11 +897,13 @@ static __must_check struct vm_area_struct *vma_merge_existing_range(
 	if (merge_right) {
 		vma_start_write(next);
 		vmg->target = next;
+		sticky_flags |= (next->vm_flags & VM_STICKY);
 	}
 
 	if (merge_left) {
 		vma_start_write(prev);
 		vmg->target = prev;
+		sticky_flags |= (prev->vm_flags & VM_STICKY);
 	}
 
 	if (merge_both) {
@@ -978,6 +973,7 @@ static __must_check struct vm_area_struct *vma_merge_existing_range(
 	if (err || commit_merge(vmg))
 		goto abort;
 
+	vm_flags_set(vmg->target, sticky_flags);
 	khugepaged_enter_vma(vmg->target, vmg->vm_flags);
 	vmg->state = VMA_MERGE_SUCCESS;
 	return vmg->target;
@@ -1156,14 +1152,20 @@ int vma_expand(struct vma_merge_struct *vmg)
 	struct vm_area_struct *target = vmg->target;
 	struct vm_area_struct *next = vmg->next;
 	int ret = 0;
+	vm_flags_t sticky_flags;
+
+	sticky_flags = vmg->vm_flags & VM_STICKY;
+	sticky_flags |= target->vm_flags & VM_STICKY;
 
 	VM_WARN_ON_VMG(!target, vmg);
 
 	mmap_assert_write_locked(vmg->mm);
 	vma_start_write(target);
 
-	if (next && target != next && vmg->end == next->vm_end)
+	if (next && target != next && vmg->end == next->vm_end) {
+		sticky_flags |= next->vm_flags & VM_STICKY;
 		remove_next = true;
+	}
 
 	/* We must have a target. */
 	VM_WARN_ON_VMG(!target, vmg);
@@ -1197,6 +1199,7 @@ int vma_expand(struct vma_merge_struct *vmg)
 	if (commit_merge(vmg))
 		goto nomem;
 
+	vm_flags_set(target, sticky_flags);
 	return 0;
 
 nomem:
@@ -1692,9 +1695,9 @@ struct vm_area_struct *vma_modify_flags(struct vma_iterator *vmi,
 		return ret;
 
 	/*
-	 * For a merge to succeed, the flags must match those requested. For
-	 * flags which do not obey typical merge rules (i.e. do not need to
-	 * match), we must let the caller know about them.
+	 * For a merge to succeed, the flags must match those
+	 * requested. However, sticky flags may have been retained, so propagate
+	 * them to the caller.
 	 */
 	if (vmg.state == VMA_MERGE_SUCCESS)
 		*vm_flags_ptr = ret->vm_flags;
@@ -1959,7 +1962,7 @@ static int anon_vma_compatible(struct vm_area_struct *a, struct vm_area_struct *
 	return a->vm_end == b->vm_start &&
 		mpol_equal(vma_policy(a), vma_policy(b)) &&
 		a->vm_file == b->vm_file &&
-		!((a->vm_flags ^ b->vm_flags) & ~(VM_ACCESS_FLAGS | VM_SOFTDIRTY)) &&
+		!((a->vm_flags ^ b->vm_flags) & ~(VM_ACCESS_FLAGS | VM_IGNORE_MERGE)) &&
 		b->vm_pgoff == a->vm_pgoff + ((b->vm_start - a->vm_start) >> PAGE_SHIFT);
 }
 
diff --git a/mm/vma.h b/mm/vma.h
index 1f2d11bb08b4..4c7ea8b893ab 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -276,17 +276,15 @@ void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
  * @start: The start of the range to update. May be offset within @vma.
  * @end: The exclusive end of the range to update, may be offset within @vma.
  * @vm_flags_ptr: A pointer to the VMA flags that the @start to @end range is
- * about to be set to. On merge, this will be updated to include any additional
- * flags which remain in place.
+ * about to be set to. On merge, this will be updated to include sticky flags.
  *
  * IMPORTANT: The actual modification being requested here is NOT applied,
  * rather the VMA is perhaps split, perhaps merged to accommodate the change,
  * and the caller is expected to perform the actual modification.
  *
- * In order to account for VMA flags which may persist (e.g. soft-dirty), the
- * @vm_flags_ptr parameter points to the requested flags which are then updated
- * so the caller, should they overwrite any existing flags, correctly retains
- * these.
+ * In order to account for sticky VMA flags, the @vm_flags_ptr parameter points
+ * to the requested flags which are then updated so the caller, should they
+ * overwrite any existing flags, correctly retains these.
  *
  * Returns: A VMA which contains the range @start to @end ready to have its
  * flags altered to *@vm_flags.
diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_internal.h
index c87bcc9013f5..19914c28977e 100644
--- a/tools/testing/vma/vma_internal.h
+++ b/tools/testing/vma/vma_internal.h
@@ -117,6 +117,34 @@ extern unsigned long dac_mmap_min_addr;
 #define VM_SEALED	VM_NONE
 #endif
 
+/*
+ * Flags which should be 'sticky' on merge - that is, flags which, when one VMA
+ * possesses it but the other does not, the merged VMA should nonetheless have
+ * applied to it:
+ *
+ * VM_MAYBE_GUARD - If a VMA may have guard regions in place it implies that
+ *                  mapped page tables may contain metadata not described by the
+ *                  VMA and thus any merged VMA may also contain this metadata,
+ *                  and thus we must make this flag sticky.
+ */
+#define VM_STICKY VM_MAYBE_GUARD
+
+/*
+ * VMA flags we ignore for the purposes of merge, i.e. one VMA possessing one
+ * of these flags and the other not does not preclude a merge.
+ *
+ * VM_SOFTDIRTY - Should not prevent from VMA merging, if we match the flags but
+ *                dirty bit -- the caller should mark merged VMA as dirty. If
+ *                dirty bit won't be excluded from comparison, we increase
+ *                pressure on the memory system forcing the kernel to generate
+ *                new VMAs when old one could be extended instead.
+ *
+ *    VM_STICKY - When merging VMAs, VMA flags must match, unless they are
+ *                'sticky'. If any sticky flags exist in either VMA, we simply
+ *                set all of them on the merged VMA.
+ */
+#define VM_IGNORE_MERGE (VM_SOFTDIRTY | VM_STICKY)
+
 #define FIRST_USER_ADDRESS	0UL
 #define USER_PGTABLES_CEILING	0UL
 
-- 
2.53.0


