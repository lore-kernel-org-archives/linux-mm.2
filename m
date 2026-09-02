Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D633C61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 18:01:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F43D6B00B6; Wed,  2 Sep 2026 14:01:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A5996B00B7; Wed,  2 Sep 2026 14:01:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06D7D6B00B8; Wed,  2 Sep 2026 14:01:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C77E96B00B6
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 14:01:03 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5C57A14033A
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 18:01:03 +0000 (UTC)
X-FDA: 85169588406.20.A976917
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id A7F96C0013
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 18:01:01 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BI06cUiB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788372061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sr9jsabfi8EcucrWWLeAxRfyM9FSn5Wtyl4+cNbIDm8=;
	b=Ykt5AopLS2WuNaG4OD3Id5CWzOSBNo8Zm5GJrW/z05cpnd4ayWdWg7ggZsbxDQKfI97EXF
	smR+sQi/p4ekc6P7/0dOTe9wJxenikOUmtomgdZ7ormqYvf4jPlhDe37pe1bszVBwXMflY
	NRPeknD15V4cr3zNTzvYV6UoOyxeakA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788372061;
	b=TcCNjwI7H173d9xUUAA9KT1xQMnyIMu9K/Pkd9RA9ATt3DRm/zTF+rTpxhBsWsXClF9CYq
	xVoZFzrOswQMK5FhFauyuBsBplNOIvLlFq7MgL5Ds2cmQWcZqyfUyVyFxT/zA0RrUEURhW
	036mvtM87WduffrZ9ZevwbaRS8LVIf8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BI06cUiB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3808060235;
	Wed,  2 Sep 2026 18:01:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCF5B1F00A3E;
	Wed,  2 Sep 2026 18:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788372060;
	bh=Sr9jsabfi8EcucrWWLeAxRfyM9FSn5Wtyl4+cNbIDm8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=BI06cUiBU6NakDoO8pj4a+JG2t9W2WPWRDd1BpnWmGESyZZ2HgyvnwgwrykQqXjrZ
	 Iq7k+kWL+6X+wo6eqlJvvH0XVm75Z49eeKGYhSQW3d9g4YEOG4B1PFfTii4HXahQ5P
	 6YmNjWUVA5gFveaO2Zsihuq6lGIYzplXrtXbtnRXmb3r83i5KeyhtnoEFhenzfzggw
	 6akDC42oSFs4wBkfS4TyP4r/fXo9oKDOKlhO9Jkztp0B5NVi1OBKMpC7TM30LII2wU
	 O1LJbALyBnLnJHAHOrIWBnOfDlvB2C2zyqF/lO6ptPl/NeXmZtiydHoYoW/V4r2/+j
	 rg5IttNA99jhQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Wed, 02 Sep 2026 19:00:20 +0100
Subject: [PATCH 3/6] mm/vma: only permit MAP_PRIVATE /dev/zero to be mapped
 anonymous
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-map-private-dev-zero-v1-3-a578c730cec7@kernel.org>
References: <20260902-map-private-dev-zero-v1-0-a578c730cec7@kernel.org>
In-Reply-To: <20260902-map-private-dev-zero-v1-0-a578c730cec7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=6758; i=ljs@kernel.org;
 h=from:subject:message-id; bh=K4kKSpQaR4XCTcqNOsKhlctxc2n/RJkZ2c1LQ0Kbg9I=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJmpHit+vzz9pnMGNuyPeHcVf374qPMnnxf0LA0KkhSq
 0dJV+ZaRykLgxgXg6yYIsvzL+L7g0TC5nVe8HeDmcPKBDKEgYtTACaSXcfw3/PmzvufuTYHRwoo
 LWF8bRZXc9LB/2ri3ZnqDS4n6ku/zmBkOHN+/9p8T7v8Es1fLmVV7fbLfietbpuQPTnrRuSPmWt
 LWQE=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A7F96C0013
X-Stat-Signature: msqtbjwbzqw6dfsjt74xufu9aduz1odq
X-Rspam-User: 
X-HE-Tag: 1788372061-296604
X-HE-Meta: U2FsdGVkX18aP5TTDFVdpTR3xPyqQLiuVLSndLU87E9RWS3dGnY+g/fRUvMOrffcLth+U+AFppjaWk5/1lMoDQBeakqy2OSncIKA0oUKLfNKV4MlKKiGoxpEvU2UKsTaO793xNst4jEPepHPik9UedR8txeH5rkG4iNwgW1RhUB50LckLvNxWKbKQyk42jXX0zHIfyYeRJoYgwO1yc2MISk/WwztA3QSBd5xHyNS2qx5QoSndcjJwRkOh/F8WbYg7dq6gZ2qdjzJXd9dbixUYKhMGL6HOH0BZ/+mrwU+cfwdDV7iEgoG5Ls1wfbOcWhzJUc4tpn0dm+XG7QSoRs0nCrY2T4jZE90HfoVfhsAdke/I/ESdzMjV6ghoRAqp/SGNB1RWjc45OKvcn7q9mIgfC43eEEQKmydTNdhLRQ9d4iwgWnLniz/zcBAtvCGq5AFsV/vWbMc4q21Nwo+aPtUNbh0NYXRB0WOc5l5sjPWmQ+t+MPe5/m5MCg65EemgY2gnIJA4r3mYx/uSJBhMLiRxV1pNSw7mXfrtVwP5np+3UqNPNdgGrQ+aTRnujo3l6TpsgojIPQqqckskWdwYtl4pr1YJ6e6LFSaqa2oRz7a1pJ72nYSI33CTVfg301gqgzUyKQ1uwVsbrK5V8Q4Ndp2RZvExJs/A8ApeXJ7tLV1uF5+Xc+fbo5Lz+c4ePISEX06WU9frmq9Q5H4Qkapf5LtLa+m5MLNnK98uas+wHtPVXlWxy69wJI6JfmQbjXhe+hli00veqNDM4ZUwDavZJI2hq4V3HxmcES0SfWJpIk7zaFUxSlMkbPGT96rF0h9BkVx0dlxioYWIEqKY+NhkuTY0kirhZQvuyb6BBr66YiOIf8jGN38dyp9/vRvo32DBkB1qPnuiHCFa6+U2C1+QetGFLAc/DlFpnerD7bEI6qeWOYzvIjR8m1h8Of95iX9YuFtBkzqRLwMhG1UF8WQEXy
 3sROKwql
 A3CQ42em5Pe/rHDmhxqTrTFxPXFImJKHFa/PO//M8ybKBTEKa2iLTerdZS/LR6tn0gpHVKtHRQHIYIEmlU5qJ+NhS3XOhT/6MkDkYxwPPIFRFZU/ZATN/6MPIPZ6g+hPPo92wABPDFfE4nxakZcb0IRQX1G1M1S9J1jlOzUTVtqQxB/Whvt9cyEroFPei2mI8RACG/1hAhK9lEBHUS9fvjXAv8e1JHVKedQFd+jXxuvcg5Z4VUg++RYIsmRtHudcJQstEDGT9VbjnDM+OZDaxwYPNnXcIdaaG+UEq
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
index 35e7a64855fa..4b8d430d9619 100644
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
 
+	/* Hooks cannot mark themselves anonymous. */
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


