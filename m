Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56D46CD343F
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 12:43:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE1B26B0093; Fri, 15 May 2026 08:43:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8BE06B0095; Fri, 15 May 2026 08:43:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA2166B0096; Fri, 15 May 2026 08:43:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 96E876B0093
	for <linux-mm@kvack.org>; Fri, 15 May 2026 08:43:58 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5E41D120313
	for <linux-mm@kvack.org>; Fri, 15 May 2026 12:43:58 +0000 (UTC)
X-FDA: 84769621356.21.8AAA5A8
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf13.hostedemail.com (Postfix) with ESMTP id 60DE72000A
	for <linux-mm@kvack.org>; Fri, 15 May 2026 12:43:56 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EuqSuivm;
	spf=pass (imf13.hostedemail.com: domain of elaidya225@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=elaidya225@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778849036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x1vQZTKyFsbsk3uN3L7O54Jk8qwhP8Yc1gVAgYEXJHo=;
	b=fM8FhaS7mvZm/YjDDW3kGezYYBWtON+wZFiJQ5o+4j6GirPu4tzn1uoh8dtCzjrwRl2rAw
	BIaRi4rBhpnLD8CB5ql99JVjdbNET95ykOkZNxYMgFBEtlC/HLMif3GzTbSbMNDNSFaF0Y
	CN9IOe2oKg0DiSlHmy3WMrQb62MaMn0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EuqSuivm;
	spf=pass (imf13.hostedemail.com: domain of elaidya225@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=elaidya225@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778849036; a=rsa-sha256;
	cv=none;
	b=khxaQ3MFehI+H31YxP7/DIuHJLVEB/fs6VDDa5BoJo9bvSPhLfEq0V0roQjtpkDdj+1GUa
	iJ6Xiiwev/BFDqLXxWpoZQVNUbEuNhf0enqcnsJGijrakoZZ7FbDjKFjS5KsmxMo2AadAW
	Kwb6uKR5XFTSfv5hla2AlenQUYdlFbQ=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-48d146705b4so107802865e9.3
        for <linux-mm@kvack.org>; Fri, 15 May 2026 05:43:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778849035; x=1779453835; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x1vQZTKyFsbsk3uN3L7O54Jk8qwhP8Yc1gVAgYEXJHo=;
        b=EuqSuivmyCJCQW+fsUvDth7FMXpQ2KK2F4aNvVtZ5KRL56Y2mwVo3MwMiIce6EEZ/t
         Y+QbjjI+Qt3/B2ItIfN02dhF99Qp+RmDZ5EQ1NKoH5t6dfJP+Z2UB4gb4eQ3e7OBWIWh
         aCO3ijChHrQMS5hno0bAAEISOEu0VoEeX9N/+pjLynuIuH3C3Wfkz5tle29kmgKcAAB2
         5xbOvHWhKozjCGwv7zkvr+qrOSptCEOCTA0ol1Dd8BxDWI+bMy3noMc7voKB5PIOo1+E
         x+4rpYg5mcj9REqaTgkDb2I5YiN+1ZAoYHNeoiMDTchitsUuaCQ7sTcZi8iwRbZY9VBv
         c/Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778849035; x=1779453835;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=x1vQZTKyFsbsk3uN3L7O54Jk8qwhP8Yc1gVAgYEXJHo=;
        b=fgaAGSeE6qVRd/HZMv62WpOhT7BVVHSty2M7a/v8EDagPb3y56LJVaLhDOuvGrlubE
         a1LKYQ/8VVnHMlG7T37v7s20uKhr/P8ZBQStVMNSR/P2vL1XdgD9oxYHmo1qYreIIkLY
         fdDEwSbpWf3XpEbVJqch120AjKRAXJimbrUpLaW3kVG3LSzHro1sEtTS1RwB/RAPWJhr
         /KdPNvpgMqiN+vWJi1FAp4G/i4fZzPTPP+PwGx1a4jip7n1r294rWezjFvzA6npqk6GO
         JiWCYM/pcjl9XFgWrp0vNHJT3MG2rcV7TPpcxYPxTAh5jt5IPuDWfeGx523oqOp/VNuy
         oFxw==
X-Gm-Message-State: AOJu0Yx/yWR07tkWyt4Cfa3g3Pv2aXJ6M9ZnWdleix+tAfg2VaUltlwH
	0C3IUVXmw+k2/PhnvSUtK2e0/eMLsImm1Sq7n5MOeTsxgYI4fL9FE6u8jo9Clk+4
X-Gm-Gg: Acq92OGqWW2D+uFuPOn5dM6hH4m6iTckGzs7+m/IHr9qHT8r1GXgMQO0eEtgYs8w15j
	PYcKycBjr3ihDnDZ/h409giDIvvOvUNi4JhiECl1wj3lke6aXkoN4CgfvfiTiCTUpS103nA5Qi2
	k6iHpec5yprelvSaAIesey66d+UomdqWUmiDy2zhaWt8h76Nfcyt8tz1dyIZJCZBEY3NqOodxlM
	dLQ949XLpFiOlHTBpE6I4YiOAthQ7YlyX1Tc540tJ+nG2CA0ADq5imbDrKvWmmMXrMz4cDCjVwN
	rqdYLuYZP8ZeWTCdejGayG/aPl3MBMDQEEkQ3WxrzS8YnKzl0NsJh81NU9DQNE0fO4dGGv8v3j4
	x6PMKUgrksRwm9ukpqYlst8VYeEFMD9SY0vjF7FlhqXAArT6Dgg337qj8QYZkgEzZdwOF8IK4w8
	IGLBCf/mhKjw6aEfHpFwEQPLLkmkxZtw==
X-Received: by 2002:a05:600c:858c:b0:48a:563c:c8e2 with SMTP id 5b1f17b1804b1-48fe60e54d6mr43702715e9.3.1778849034842;
        Fri, 15 May 2026 05:43:54 -0700 (PDT)
Received: from fedora ([156.207.183.142])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fe4c8344asm100188115e9.1.2026.05.15.05.43.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 05:43:54 -0700 (PDT)
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
Subject: [PATCH v4 4/9] mm: implement sticky VMA flags
Date: Fri, 15 May 2026 15:42:14 +0300
Message-ID: <20260515124218.151966-6-elaidya225@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515124218.151966-2-elaidya225@gmail.com>
References: <20260515124218.151966-2-elaidya225@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3m7fptbr33y8hgxnzhrbgexhmsnre9z9
X-Rspamd-Queue-Id: 60DE72000A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778849036-562304
X-HE-Meta: U2FsdGVkX19dJyRyrMYbeDk9a5Vl7CDx18qeJ1Gbpn4f4FrfZJSRHPp68uvHRXgt432/M7sPl+FSEBX1qs5UbWJ5v0Eu/GpWz840mpFrTGlM2d5fr2Q5HL/4+1X5vBu67JzmKxKeYmlfstBAKY/wLWpNTvXmpKJG38r3ZuN2s2RlynqGYA5lb+GoMLECMd51JhtEMPtmIuAnpNoTlSr1kEx1oRPbNcSAyuGrBDpyj09lEqNGzAf7vZIAcSazdKh8VcaLMf5fQTaY0rnY3LVtNbW1iZbbB0fdiuTmY/zbessfCX3wddR1DDGBhA18oM5G/pC4OrdxipC6uCGB8KXUSmMy5i3gs3NX/9ImoNjQvmWZs+2KZDXsPrjCye3FXKMy0AnxPsQrHgGnsDnF0xrhJPTXlYVpiIKEXYwNz4rZOc66Bt64wuoe64w+WJNEfA4nuPWwL3zTJ9oJYOPn8gz+yIZCj7cBl6z1qV7vLFAdpxOL0dHTOadGC05Y9PvSazUomR3wOH7ZN8xe4ZihiT03ol4oVZ3plGFY0OCwVTbCCYgVzaoBvPQB3mEcsWR6GkV646nqxHcDGJJW7VMnvvFNIxKq+etotBJTzpnk+rNGGtg9XfL6FPaGomgKTCbQa2qc0+ZMS0RPXlINuLKJ7bsr2dBAICYJxGX/mLeseVo9NtzOeWJE7HYn3vjgfVVjpx9WVedO4q8jDAlSfng8PzK/EodMaKG27yVQqXYZV9H8CkVapCAaeNLmIEiNyhAZuoaxyosDRh60PrxswMFIWVKQJd7OVPZyI/TVmwow1W5elTqIXSGNrCGlZIHU1PLlvWDvvmnN/ZVZl4JZz+K0AIZcEUwiygYA6I6xVY149KbevTdS07AmxYRxiTMwwtvtgo11dwmQkSuQ7BaGD9jlPqUL42wLbtrt6FTXldGQ5tJWCcq4EEytCpVJKWDBLM3lEY4GTmCKz3wOmORmjbtf1Hy
 nbYYG6h/
 9BCLlrD0Ft7zfvPn61vmKMnU5hKDrrHbISmEQbkfLKUx25zLS7kldXHURlvqyMHgSEY+dG0EOIoJwBkc6D2qhrMP8jaiygocfbAOaR9tE5W4iQWYL14xYO00Thfe3+mufTSBdxYsA+Vgf0uJK2fPZLkQxdrbmjFcsthk8m472zLSWQjUW9liRYqHUorGJUpQq+F0xQ80u1RpUYZE2ryjKa485kgjGVfpl2TE2jJ4qKmw7jD3mkdEPzDJwkWV2Ui2wM9f3P7wqAtDiB0/3YV95MWNJ9JVhELz8E46eCJNp8Wa06DbQmgZjQidgETbxE8TCgNwa8fe+u1akEEVKXvkaObrFNejVGBex6otA2tqPg5cODbwlj+hbsuwzAtfvJAgPXAtW8g6lpXx5+WKw93shtjfGz0H1k30u1DpS5qTuLXeHyWWLEScpgsUDSJ3GsXck0QK3myJvuK/9QkhMOLCKZCoxDNKhXg/Ie0nklZp694mX9DWqpH99VWPI0xPHlwr9J62I2eSQzUxXICLP9Xa8v9WJgcd7GjrQdKTuf4IrnKyRy7DOcurp4Y4r6i/nuzNId4OiWzlK6NfD8nERZ0y0bwljHzOn15IJ9kZ/ueeJ+wO6cu6WbQ20QIHYVFHaDhtLjd78Mt/36TQow4qRAJOC/1whZ3Cv1pd9SQODdWAw4d9n6+y9ay80wXs94YLfXJ2hE0IgZ9giQc1Gqv+FQtDyM8AQXDnEHdnf5GVm88l6WP1tznB1dxC8r5hWNxpXSqrn25d+ILZCwwEQRVZT3yP174sU1VZ2/vyfOaap29Iz+IVlPo01Ze86SkBLI11Vu7Y98tmrJrzXaUTtvsiAeqq8reHT3rXTtDk8JPHErJoHi1EFIG+pDwoS+5Ssh713NJmUNCo1Z1EQ0mgUeXBwUK+hNf6mrg==
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

Link: https://lkml.kernel.org/r/22ad5269f7669d62afb42ce0c79bad70b994c58d.1763460113.git.ljs@kernel.org
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
(cherry picked from commit 64212ba02e66e705cabce188453ba4e61e9d7325)
Signed-off-by: Ahmed Elaidy <elaidya225@gmail.com>

Cc: stable@vger.kernel.org # 6.18.x
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
2.54.0


