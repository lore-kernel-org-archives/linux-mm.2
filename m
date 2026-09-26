Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B674DC98332
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 10:41:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB0206B0093; Sat, 26 Sep 2026 06:41:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D87C76B0095; Sat, 26 Sep 2026 06:41:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC45E6B0096; Sat, 26 Sep 2026 06:41:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AA6016B0093
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 06:41:39 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 334E6C0846
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 10:41:39 +0000 (UTC)
X-FDA: 85255572318.20.C1D7E2A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 65D5340006
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 10:41:37 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YWss9Tur;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790419297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HMfrQRBnrLeg+i++dUHcC4nFQRW2Nco6Um9SNVy3z0c=;
	b=3YaysPDPEePzz/Ii5OVtEQSaoOJhinn0v16OBSvRQzhk2pesOokWJXfc2PYP4f4zv7gjhF
	0yuXlTuWDOipD9T0Y8EGoWweLAydv0BOOJLhOZ+ynyvoTqmi8pkWO7vVPFXBHBnegE9nTI
	+MNiGbExzcE0MTq2ZhNB3C8Q/ZsgbPw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YWss9Tur;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790419297;
	b=6qMghcFeNW9y1WHRaC2Ft56YLJZqQD45ZLppxZ5p34g7AYGp5WlcDgfXGw4OzT/AspDs1Z
	/89HcReOZitAs+dPyoo9V51obp0jmjrOfeW9WIaEHDNv+Aj6xZDpSoOnRXS3KkDcDKubcI
	XFdRFCovIwbFWvcJdxj7gEQMISFYtwk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 65C4A43E36;
	Sat, 26 Sep 2026 10:41:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E09E11F00899;
	Sat, 26 Sep 2026 10:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790419296;
	bh=HMfrQRBnrLeg+i++dUHcC4nFQRW2Nco6Um9SNVy3z0c=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=YWss9TurLVblfmFBXSd9AGmes3IWDon3lgcl2MuRkhPFctXdHvAY/TlIOUzJekG6O
	 pqvqixouOv97YRUycQ2kYvjlTMKu6E8KIMOGCu6kBA0xnHY4gdqpwm8K0szdWqSAYt
	 k71SqyBnLUd7JOx5XeP4bNN7/hl4cfzZes6R2rF1jADJkE4KBnaPVFls10psA5BZ7G
	 zIMx/OSg0UondCCzH6/jyMw2KNR8OMgCfin1wG9ThTf/KbgwpxX++j4XxPqPrIsAAw
	 qVX2nx9LM69Zp6bEMyemnEYqFXOfpq/uMMMLSampQ/o2PWRsVTuJPX8536JP+06CHX
	 XLAasVshLnfuQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Sat, 26 Sep 2026 11:41:08 +0100
Subject: [PATCH v3 3/6] mm/vma: only permit MAP_PRIVATE /dev/zero to be
 mapped anonymous
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260926-map-private-dev-zero-v3-3-d4781e84ccfc@kernel.org>
References: <20260926-map-private-dev-zero-v3-0-d4781e84ccfc@kernel.org>
In-Reply-To: <20260926-map-private-dev-zero-v3-0-d4781e84ccfc@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=6825; i=ljs@kernel.org;
 h=from:subject:message-id; bh=aOsfkFmD7VJF69fCCB5+yUEH7yaQfQ8RDJypeDOlFt0=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLK2L/ThZNv1qmvGupU+HG8OtE6dyBHow9fN0aN+dqeaa
 u/Gc4tCO0pZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjCR2U0M/9POTlf0Nfq8dnbU
 cpuT2RduHeo/6rDjSHR1q2n64llH7GsY/uceWKi6ri3pj8KbKUe/rAm7PX3fAivVp2+WPohj6Ku
 TaOIBAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 65D5340006
X-Stat-Signature: uabtrn518s9ad4mrgdw4w9szb1arn9i9
X-HE-Tag: 1790419297-260238
X-HE-Meta: U2FsdGVkX19QZppl5svJ0l0AqpHSp+C9AU3LSqDPSALB78SL0H/J3yEC7GN0P/ZBhFFXKKgJc5yACVtbsqk6+LVhY2oe6WY5l/x0hBgGlG3pqaJWH2oFXswGHlgjNrhn9EqzaZC29Nap7MMMOA5as00KfOnnDGwzxYlMVrl9CAeWZlJVi3YyhMJfKmABgQjtGfUCDPCQzF3alXF7uZDvl7iny2fTzSdyKjYJGODylG1RvJDBafUbJT+sb7hR/7A3LcfpLUvBLgSViBPXay22rMSW1BZ3YDcBZHnjJ7Oq+NgcQFetYltfd1aP32KMm++/eT9Tld3/yS2uP0DiKI6cC5MLWFLNLTPskF43pYBU3DKwGIOK7w6d4xzL0apppxdeV2oGQ8RSdKMedf7FTN9GHky7xmetIwGfojn1/GU7ecvbeSNh2orU08epaT8LfNz29DuzoAAKSeLVVYtAN57s2C/xLxdG91fnMWbfMLQSn4HEK8++ufFr9dqO1yOQoIfXbZZX7czbqRQURoKCjS6sk2xRTVmMLWvCcHOwPVW4uYJXwjXfKHpuOzqjEjpNpe/ig3bvT4FbjmmjangrXSXUI9aU6otKXWWL1Iv7rrmozoi4IePZz6d7fhp+ts0264VdBw0J1BAGLieP7q2oRNg7/DJ0uF2EPXRC/yUVn2cpUgsEFGZEURc/sBgG/OTza7ouPW4s+wxGcSSNv8FWFdYMNYr1tdmtOztiYxEpfDjziTYtz67haymYZdZpStvzA+tHLhk/IdBCH0O5GYe/uAhUfCLVQUvLfesQt/R5Z8i3vMWGoZ0RV+OgcTcxCaMM2PmgIX2Ia7h52qD/CLxNz3A4Y4aKrvL026UhoZHXcqWVSKL3FfJKrcXgrgoASWJyC2w4RyYxjF0t2YFuT4XS9OjnCSJ8Fj3TPmN7WfcroU6jJQtwFuMKnCBcPNlRWoMaZoTFisBL9Ymrt2KVbc/xuTe
 jlgg+Vqd
 xFeXS10Lrpng1gErJaqR/PRy2IRa3jPDFFsVmOezE052GsJtBvw1vlPsxEmqZnRMbEGEYZJiQrUYyZFgUho6lIrFMo06VGMf3PWsOoFs82PY5pPNlDZ1Su1MtxDb/GwVZnaQtWe53fnHxPLOYhTjWIT4+lrW0rqlnegTSiBk1z5nfkpjhMV+Z3zmTRKn8zkR4SpxZNJgMbXgnjqtL15dUV9ZKT0hCxU/AYkJ1oZVY0kDry6M2HNwsNBciHBVJhYxSf3emOtrcYQZA0TGKf8EUm/4P8TimZDn7prCy0tAuLXifKKM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In order to use mmap_prepare() with MAP_PRIVATE mappings of /dev/zero
without the success_hook hack we explicitly permitted mmap_prepare handlers
to set NULL vm_ops.

However this is dangerous and we really only want to allow this for
MAP_PRIVATE-mapped /dev/zero.

Therefore use the newly introduced file_is_dev_zero() to uniquely identify
MAP_PRIVATE-/dev/zero mappings and only permit this behaviour for them.

Then, remove all ability for mmap_prepare or mmap hooks to set a VMA
anonymous and update mmap_zero_prepare() to leave it to the core mmap code
to do so.

Note that this disallows nested MAP_PRIVATE-mappings of /dev/zero
regions. Doing this would be broken in any case.

We therefore do not need to update the mmap_prepare() compatibility layer
to reflect these changes, as the mmap hook check suffices to disallow this
behaviour.

Now we're setting vma->vm_ops to NULL for an mmap_prepare-initialised
MAP_PRIVATE-/dev/zero mapping, we have to avoid a subtle issue when
updating user-defined fields via set_vma_user_defined_fields().

The default for vma->vm_ops for all mmap_prepare-initialised mappings is
vma_dummy_vm_ops, so map->vm_ops will be set to this and setting
vma->vm_ops to this will render the VMA mistakenly non-anon.

In general, we should never be setting user-defined fields for an anonymous
VMA, so explicitly check for this to avoid doing so for the one case where
a mapping can be both mmap_prepare and anonymous.

In the case of legacy ->mmap hooks some drivers may set vma->vm_ops NULL
believing this is the equivalent of setting no VMA operations. Therefore
update mmap_file() to correct this by setting dummy VMA operations if this
occurs.

An example of this is drm_gem_shmem_mmap() which deliberately clears
vma->vm_ops before handing the VMA to dma-buf. Cases such as this will be
updated when they are converted to mmap_prepare.

Also, in order to avoid a single commit bisection hazard, add a temporary
workaround to set the VMA anonymous only after vma->vm_file is assigned in
__mmap_new_file_vma().

This is because vma_set_range() calls vma_set_pgoff() and
assert_sane_pgoff() in turn, prior to the vma->vm_file being assigned. If
we set the VMA anonymous early then this assert will fail.

This is removed in the subsequent commit.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/char-mem.c |  6 +-----
 mm/internal.h | 17 ++++++++++-------
 mm/vma.c      | 33 +++++++++++++++++++++++++--------
 3 files changed, 36 insertions(+), 20 deletions(-)

diff --git a/mm/char-mem.c b/mm/char-mem.c
index e53e89e6ddd8..c0b5fb019223 100644
--- a/mm/char-mem.c
+++ b/mm/char-mem.c
@@ -508,11 +508,7 @@ static int mmap_zero_prepare(struct vm_area_desc *desc)
 	if (vma_desc_test(desc, VMA_SHARED_BIT))
 		return shmem_zero_setup_desc(desc);
 
-	/*
-	 * This is a highly unique situation where we mark a MAP_PRIVATE mapping
-	 * of /dev/zero anonymous, despite it not being.
-	 */
-	vma_desc_set_anonymous(desc);
+	/* MAP_PRIVATE semantics are taken care of for us by core mm. */
 	return 0;
 }
 
diff --git a/mm/internal.h b/mm/internal.h
index 5d474e5f7709..da14c56fb24e 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -226,15 +226,18 @@ static inline int mmap_file(struct file *file, struct vm_area_struct *vma)
 {
 	int err = vfs_mmap(file, vma);
 
-	if (likely(!err))
-		return 0;
-
 	/*
-	 * OK, we tried to call the file hook for mmap(), but an error
-	 * arose. The mapping is in an inconsistent state and we must not invoke
-	 * any further hooks on it.
+	 * Either we tried to call the file hook for mmap() and an error arose
+	 * or a driver set vma->vm_ops = NULL intending there to be no VMA
+	 * operations.
+	 *
+	 * In the former case the VMA is in an inconsistent state and we mustn't
+	 * invoke any further hooks on it, in the latter case the hook actually
+	 * wanted no further hooks to be invoked, so fix both by setting dummy
+	 * VMA ops.
 	 */
-	vma->vm_ops = &vma_dummy_vm_ops;
+	if (unlikely(err || !vma->vm_ops))
+		vma->vm_ops = &vma_dummy_vm_ops;
 
 	return err;
 }
diff --git a/mm/vma.c b/mm/vma.c
index 35e7a64855fa..a31942c0ad2a 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2621,6 +2621,19 @@ static int __mmap_new_file_vma(struct mmap_state *map,
 	return 0;
 }
 
+static bool map_is_private(const struct mmap_state *map)
+{
+	return !vma_flags_test(&map->vma_flags, VMA_SHARED_BIT);
+}
+
+static bool map_is_anon(const struct mmap_state *map)
+{
+	if (!map_is_private(map))
+		return false;
+
+	return !map->file || file_is_dev_zero(map->file);
+}
+
 /*
  * __mmap_new_vma() - Allocate a new VMA for the region, as merging was not
  * possible.
@@ -2634,8 +2647,7 @@ static int __mmap_new_file_vma(struct mmap_state *map,
 static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap,
 	struct mmap_action *action)
 {
-	const bool is_anon = !map->file &&
-		!vma_flags_test(&map->vma_flags, VMA_SHARED_BIT);
+	const bool is_anon = map_is_anon(map);
 	struct vma_iterator *vmi = map->vmi;
 	int error = 0;
 	struct vm_area_struct *vma;
@@ -2651,7 +2663,7 @@ static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap,
 
 	vma_iter_config(vmi, map->addr, map->end);
 
-	if (is_anon)
+	if (is_anon && !map->file)
 		vma_set_anonymous(vma);
 
 	vma_set_range(vma, map->addr, map->end, map->pgoff, map->anon_pgoff);
@@ -2669,6 +2681,10 @@ static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap,
 	else if (!is_anon)
 		error = shmem_zero_setup(vma);
 
+	/* Temporary MAP_PRIVATE-/dev/zero workaround. */
+	if (is_anon && map->file)
+		vma_set_anonymous(vma);
+
 	if (error)
 		goto free_iter_vma;
 
@@ -2777,6 +2793,10 @@ static int call_mmap_prepare(struct mmap_state *map,
 	if (err)
 		return err;
 
+	/* It's invalid for mmap_prepare hooks to clear vm_ops. */
+	if (!desc->vm_ops)
+		return -EINVAL;
+
 	err = call_action_prepare(map, desc);
 	if (err)
 		return err;
@@ -2799,10 +2819,7 @@ static int call_mmap_prepare(struct mmap_state *map,
 static void set_vma_user_defined_fields(struct vm_area_struct *vma,
 		struct mmap_state *map)
 {
-	if (map->vm_ops)
-		vma->vm_ops = map->vm_ops;
-	else	/* Only /dev/zero should do this. */
-		vma_set_anonymous(vma);
+	vma->vm_ops = map->vm_ops;
 	vma->vm_private_data = map->vm_private_data;
 }
 
@@ -2882,7 +2899,7 @@ static unsigned long __mmap_region(struct file *file, unsigned long addr,
 		allocated_new = true;
 	}
 
-	if (have_mmap_prepare)
+	if (have_mmap_prepare && !map_is_anon(&map))
 		set_vma_user_defined_fields(vma, &map);
 
 	__mmap_complete(&map, vma);

-- 
2.55.0


