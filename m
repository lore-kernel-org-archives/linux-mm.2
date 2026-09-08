Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C34EDC79FA1
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 11:25:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE7BF6B0098; Tue,  8 Sep 2026 07:25:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBE886B0099; Tue,  8 Sep 2026 07:25:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AADAE6B009B; Tue,  8 Sep 2026 07:25:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7D92D6B0098
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 07:25:01 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 951B9160500
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:24:56 +0000 (UTC)
X-FDA: 85190362992.28.FB811B1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id CF4A720003
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:24:54 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RA6OXMH7;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788866694;
	b=X3Sw0sAljRVi85QHnW1iBgzOYTi71IaPOhuiBF0e0JxE6KRpHzIMlMU85AKxNqBaw/maRu
	Byq9v6NSbGuu+ulHRgN7KGwOpPolJPAIFvez6zA2rSQVXbKz6hd22QZsOuPFKIv6Jy9s/U
	h2QFDZmtLUCLIfj+DNA8+tx2v1xY2M8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RA6OXMH7;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788866694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sr9jsabfi8EcucrWWLeAxRfyM9FSn5Wtyl4+cNbIDm8=;
	b=VZDjqDtznn3tghRf9YjaU0rSZ6zMXwFNgQBiViiLRtzQ2lMtEipqbPqwMTe4xJMwifld1k
	zT+yfp3G+N8ahYrlrFUFqn7kWUqiNmEWuGsFzg0zGdRrMjJrehHxtIjzDr1zD4fJsEs5E3
	fuPD7nmgGuM7PsIQ8O0dcUvxWZ/97k4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5819F60A9D;
	Tue,  8 Sep 2026 11:24:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98E231F00A3F;
	Tue,  8 Sep 2026 11:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788866694;
	bh=Sr9jsabfi8EcucrWWLeAxRfyM9FSn5Wtyl4+cNbIDm8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=RA6OXMH77Zgvaug81fCjs6q8EFJrkbGmeb5ZTjWBjxCYmZgZ8iTsBWQli9NNSLlxI
	 VA9VdFEgvov7JLmT1QlJk6DibaCmUI1gcg6hlnXFqhxznqkJ24BwmuOQ0rVhFXxXnf
	 f510ZISKCnXtVnIpHmiv9lPnAaCpG5I9H+RxQSMb7Dwu949ia2SkyAH/qxp3hbWNy/
	 yRi966BwRmoku4PUIcg+v8K+NkJ1zLsDDdBnM/RFgWbMPcLsXOET7kSO7/1Tlz5GbN
	 9wt8xwfZvE+Y2kRVil6nc5rE4jqeJhy/Ul45Z6GvJwBngeBQeXWyuNoj4SHsvHCsLi
	 bUAhZ8HJegA5w==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 08 Sep 2026 12:23:40 +0100
Subject: [PATCH v2 3/6] mm/vma: only permit MAP_PRIVATE /dev/zero to be
 mapped anonymous
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-map-private-dev-zero-v2-3-acc7b5625305@kernel.org>
References: <20260908-map-private-dev-zero-v2-0-acc7b5625305@kernel.org>
In-Reply-To: <20260908-map-private-dev-zero-v2-0-acc7b5625305@kernel.org>
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
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLmfyhce1aq6l3qAWex1cw/52hrmF+YdSzvbuuxBJ62A
 plnb8NEOkpZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjCRP9sZ/kqxlcwXi/dMeuN4
 6sIhzZs8PNlG/V4bxdusvSPMt6ot/8/IsKXiQvjFou2VZZd/vugSuqSqEtg+d0K0fmTuiYUsgo+
 NmQA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CF4A720003
X-Rspam-User: 
X-Stat-Signature: c8k965daqa51rc7krmy35w67zc1byepg
X-HE-Tag: 1788866694-102904
X-HE-Meta: U2FsdGVkX1+ZSiz2lOyglMPjKsplL2k0MTAHnV5wFH7MZjswZN86+RbwCCeDkofliUjbS0GudmHOTjKMmVlcWgvHvqjxK8h5afIQHoU5Tv1yRbShBVU5tXyvFQxwmELPeX0VqJi0YX6kyn3M0d41IagDgzppxzauu+m9sS6W6057GaXlabRhu7lrK/dPAca9Ns9u4CxZuhSKcI1373bbbjMbpqWzuXleCF+kN8t2kt23rQbaK3dpmvoI4ag7MqmFUzCzkwhB+Ou/ZJsGBgcK7yShVEYs9M5ycNXyAsNFvyMOBu28v2oe/JRDFNdxmU9NQSqmxmpb2dZaZrCdOL2Pg4rir9X+eT65VnQ+rnQbCkcpYc21NGxw8V0P1bX6OGkbqFMUsH7x0DHw71HWU75ZHg+kLqJak5T7pXpdEG9Zn5qGJnvZKqikCbWG3PUz9/K9pTOf6kwsCC3BL5md2oopagh5oPb3HT0CLSL+kM0wemhgqHjyWQTxLCvNBNhy8VY2wfd5fA29SUVeh/mJMM00zbIivwpBXilazqho+J08/k2/hc2labK/eiUOF/aOQ/RR5RFvY8Satw6bSSOrNjYYdQgOpJDkGqVVXFWnkML0+H7+y6JNEWLCfxJ3CERKI9LQiwrmFQn1nKE3+5LtZCzFK5je3cBZk5yMA+gnQj2VJgqpp8KgDFVPjEbbUUbTiALbQdbHrp1w3tXj2jSQuUAnUivUmOJ0L7YU8gdEI99LaWPHpOfzeTrwuh/DRx2XqxlJWvMJr3E6EkLpL9j8hl84ttJc6R84Qhk8VJm9XLDLTkipTp8w0L+JOrrFmPWVPYCo2VOwaIznsE9nLKMKGvUCs51okbswnWmaYVOrJegvwVPj6X/+93VqMODlrlpIFbDSeZz85pYnDldzxZH7trPnE21NUE1ntNfXJhhTz+iejb4hwOX3nyy7yWYZdMj49SN+SIR+cYO7Ayxgli4+8Jj
 qt7CR4be
 3v1oVwmr5AmVPdVj3Ory1R4Od+KRmrBRTYwDEeHWz0crE51QZjfFa8XfbZVmgJ+divMplSRFXAzZK/tqAV3dq/fRL8UuJO7HWVTv/PdgT2FEPFuLb4vRDT6zuYoDHvpAXMGL5F0l7Y0RgXKFXEWy5Lt1YivebJn9lKtKLMy1U6wxiCeID+bWAwpg/6AAJZQxNgWqB+EOTbB0DJUDhQ7fLXqcW0ObSHkRMofJUY8UKL5ZyG7tL9MOsvVziEST60MgAwtTuG8hF6nx4ESJS8Gi/h6ESEhLbxVVTYSoX
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


