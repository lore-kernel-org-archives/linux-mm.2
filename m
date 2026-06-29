Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE4CEC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 19:26:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D50246B0135; Mon, 29 Jun 2026 15:26:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D00666B0132; Mon, 29 Jun 2026 15:26:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A69AD6B0136; Mon, 29 Jun 2026 15:26:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6BC676B0132
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 15:26:37 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 007228C158
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 19:26:36 +0000 (UTC)
X-FDA: 84933931992.29.91B84E5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id C27F71C0004;
	Mon, 29 Jun 2026 19:26:34 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hLoZuZ6G;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782761195;
	b=M43KJ9HWTDJBMggUhW/Fd7Q1z90w6+wG1J9+fnjuL3yWSJyGFtc4tPQIweaw5MGo6wmlrI
	mOC5tZ7Dq5dWBPsyO+sfnwNAJNbbV9PLZkJzkaTi9dw9gBl/PVh+BdJujH8DvA+IEIzFuP
	3BtdmKtGf7RklmiB+sDYwPOS1Xda+ho=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782761195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sN4LQUgjV69Vve2oXZfCiFNipdsItekVGoTOkdqjKS0=;
	b=h5yNlSWkjr8twO8shamfkv4tWQn88MAWCaKuV4w0AZGJuHZ9EozyaCjhftAMlEA7VGKR9G
	jrbBzmOTzaKS2ViWsTUhGLjODid5fCkS1TUSAa20dZWRqS95+ESHopAHhNjbVY7SvtJH0G
	RawrHDryuc2Lwo7v2NRkf3XG/VkWnro=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hLoZuZ6G;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 17290416B4;
	Mon, 29 Jun 2026 19:26:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FF3D1F00A3A;
	Mon, 29 Jun 2026 19:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782761194;
	bh=sN4LQUgjV69Vve2oXZfCiFNipdsItekVGoTOkdqjKS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hLoZuZ6GBb1R0Z8TwftPIK0sP8C4ADT292o5rS1him458JTroTTIDyZ9+Hy0is8/O
	 XeNWVdGoC2qYu58Mzq91SKZir/PAlhdz5W7/iMSQVsmj5rX5UypKH/YB7F0APXpMjo
	 gXJ3Cof1BcdWqfLA9vJGStqjlBFRuYOd2hD8szeCByTsbP11W1zWXgrMdNJbOmXD83
	 8Ph8tUPYU2URQeyhQuTC5p984HgkU+vfY0J7E1B0VzjOvq6a9QDtpjiRAIvAELmghi
	 LbEz58mWSrmhExQd0IOcLcqDCYco7OLxU40dg/5907AyshxLbOd1WyrGHUd9f/IXP7
	 SzrM+wTul9mMg==
From: Lorenzo Stoakes <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Lucas Stach <l.stach@pengutronix.de>,
	Inki Dae <inki.dae@samsung.com>,
	Seung-Woo Kim <sw0312.kim@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Peter Griffin <peter.griffin@linaro.org>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Dmitry Baryshkov <lumag@kernel.org>,
	Lyude Paul <lyude@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sandy Huang <hjc@rock-chips.com>,
	=?UTF-8?q?Heiko=20St=C3=BCbner?= <heiko@sntech.de>,
	Andy Yan <andy.yan@rock-chips.com>,
	Thierry Reding <thierry.reding@kernel.org>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Zack Rusin <zack.rusin@broadcom.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Thomas Hellstrom <thomas.hellstrom@linux.intel.com>,
	Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>,
	Helge Deller <deller@gmx.de>,
	Benjamin LaHaise <bcrl@kvack.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Hugh Dickins <hughd@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Kees Cook <kees@kernel.org>,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.com>,
	linux-mips@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	dri-devel@lists.freedesktop.org,
	etnaviv@lists.freedesktop.org,
	linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org,
	intel-gfx@lists.freedesktop.org,
	linux-arm-msm@vger.kernel.org,
	freedreno@lists.freedesktop.org,
	nouveau@lists.freedesktop.org,
	linux-rockchip@lists.infradead.org,
	linux-tegra@vger.kernel.org,
	virtualization@lists.linux.dev,
	intel-xe@lists.freedesktop.org,
	xen-devel@lists.xenproject.org,
	linux-fbdev@vger.kernel.org,
	linux-aio@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-sound@vger.kernel.org
Subject: [PATCH 13/13] mm/mremap: convert mremap code to use vma_flags_t
Date: Mon, 29 Jun 2026 20:25:36 +0100
Message-ID: <380f761d35a3faa4370f8b3f92e3d4af3d4c7110.1782760670.git.ljs@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1782760670.git.ljs@kernel.org>
References: <cover.1782760670.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C27F71C0004
X-Rspam-User: 
X-Stat-Signature: quxhracp133399wjxe4df54qo1rshrbu
X-HE-Tag: 1782761194-14577
X-HE-Meta: U2FsdGVkX1+8lRmEeGnkOO17QR+C5Ix/YNpOOGX+eH9CrHUFVp7oZvyyYM+KCwO2CPJ5h9NsEZWSyDM8IZRhxgwKa0VVm9+sv5MmTJB2UJfcFd223AucC572Hj9neWtTTY9fTAUW/4xhcuJLpI2tAc6sdVUJYIM78ScZntvgtKL4x4PcD8DcHhjL7wsEhw723A6+nnCU1rd0AbeqIA40OBHBpPmYCoVrj9ImlOhTxdggsJMb5jLCbS6G4S8rvGmYddYHqaQQEgV91QYQIb7TNKsB3Ommb6YieavQKuBHLbkpOYhSw28V0Yp/DrTSO6XyJYsyqJYxGDBRznJKO8kH9dUkrhRZv9RVAbF/XLjh6kLS76yHxi3zrO9A+hapSZYJKTAeQfyyzbkyS6UL0xMb3DKh1Ywlh8ShQjfNWC9J4/FTHh05RFCUjHgC7AADpPzGQb2POFJ6net2t6qXdHv/rOkRDSFntEnj5cvmVny3T5yDkuPM82hA0e9/J+X2nsimRZWUFPV2h65UMxh8djo1W1GT2WFa73Sck9kCZ+O3nFUqnWWhBFfPx/zSfuSyO7R9HkAOrDt4B8VMN/MNAboX9oSZgJcXzh054Mqj0wBPJUPddkKzZdSS+n5tFcgXWcKBygPLxzxrSgFw5OFNevAz8Cy2zr+Yup+oH4cBwIU25FIK+ym6H8fqLtmOg386shCtKmdy4Er3r85HUl/5tLno8OQWtuDUvqburrxRhkBY+lJPwhQfAjVKGbuO6JcNVNWdYqkb1T2Obv1AjM8tUWnFw3INXHmGvDh4fB0QHU+40NgC1ApTYPNDLA0ai9nkQwOE+TNEaGUre73jmnKibSwF1Y29gp82fNI9zvu5+iPjcapR+mZOGM5HQqZu4Qt9HiGQHoAAmp5rcjZsucPYvaPvIcApLTLtmgPNl1Voax8ak+MrYMp64Q9aB52QNU1Wtvr5xURinhRBUvGZQz2QwWc
 gQOqz0+E
 GMbUkjwssZ6fyiRREuRTcg61ommYNhRK6wiQh0jZEhGmvqF9yuWpvCIVuUrN3RgtuyQiBWL3EYTl428N8w1/KKGfpxstMMyZXs6lVZLNUe9H9KmAGY2HB1wQrzqkUDpZDecAMw5nelgmsYTIHZSx4YqXMnjjynyoUnAwWFQmiId+1JAtKwmhGa5/CJM+YgHDrWrPE21OgBJWyhmTEBvvB4gcBRBtRNqfx22Wecw5hoAeA42qEV92uxgONGEnLsP0dC9AS7c0Q0pHDsVlAWQpBe+P1gThfkAZsH3VurTrd8FbnCdei2OiHJvppNPauEKuyWwLM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace use of the legacy vm_flags_t flags with vma_flags_t values
throughout the mremap logic.

Additionally update comments to reflect the changes to be consistent.

No functional change intended.

Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 mm/mremap.c | 38 ++++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 18 deletions(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index 079a0ba0c4a7..0ea43302b7ed 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -68,7 +68,7 @@ struct vma_remap_struct {
 	bool populate_expand;		/* mlock()'d expanded, must populate. */
 	enum mremap_type remap_type;	/* expand, shrink, etc. */
 	bool mmap_locked;		/* Is mm currently write-locked? */
-	unsigned long charged;		/* If VM_ACCOUNT, # pages to account. */
+	unsigned long charged;		/* If VMA_ACCOUNT_BIT, # pgs to account */
 	bool vmi_needs_invalidate;	/* Is the VMA iterator invalidated? */
 };
 
@@ -954,7 +954,7 @@ static unsigned long vrm_set_new_addr(struct vma_remap_struct *vrm)
 
 	if (vrm->flags & MREMAP_FIXED)
 		map_flags |= MAP_FIXED;
-	if (vma->vm_flags & VM_MAYSHARE)
+	if (vma_test(vma, VMA_MAYSHARE_BIT))
 		map_flags |= MAP_SHARED;
 
 	res = get_unmapped_area(vma->vm_file, new_addr, vrm->new_len, pgoff,
@@ -976,7 +976,7 @@ static bool vrm_calc_charge(struct vma_remap_struct *vrm)
 {
 	unsigned long charged;
 
-	if (!(vrm->vma->vm_flags & VM_ACCOUNT))
+	if (!vma_test(vrm->vma, VMA_ACCOUNT_BIT))
 		return true;
 
 	/*
@@ -1003,7 +1003,7 @@ static bool vrm_calc_charge(struct vma_remap_struct *vrm)
  */
 static void vrm_uncharge(struct vma_remap_struct *vrm)
 {
-	if (!(vrm->vma->vm_flags & VM_ACCOUNT))
+	if (!vma_test(vrm->vma, VMA_ACCOUNT_BIT))
 		return;
 
 	vm_unacct_memory(vrm->charged);
@@ -1023,7 +1023,7 @@ static void vrm_stat_account(struct vma_remap_struct *vrm,
 	struct vm_area_struct *vma = vrm->vma;
 
 	vm_stat_account(mm, vma->vm_flags, pages);
-	if (vma->vm_flags & VM_LOCKED)
+	if (vma_test(vma, VMA_LOCKED_BIT))
 		mm->locked_vm += pages;
 }
 
@@ -1167,7 +1167,7 @@ static void unmap_source_vma(struct vma_remap_struct *vrm)
 	 * arose, in which case we _do_ wish to unmap the _new_ VMA, which means
 	 * we actually _do_ want it be unaccounted.
 	 */
-	bool accountable_move = (vma->vm_flags & VM_ACCOUNT) &&
+	bool accountable_move = vma_test(vma, VMA_ACCOUNT_BIT) &&
 		!(vrm->flags & MREMAP_DONTUNMAP);
 
 	/*
@@ -1186,7 +1186,7 @@ static void unmap_source_vma(struct vma_remap_struct *vrm)
 	 * portions of the original VMA that remain.
 	 */
 	if (accountable_move) {
-		vm_flags_clear(vma, VM_ACCOUNT);
+		vma_clear_flags(vma, VMA_ACCOUNT_BIT);
 		/* We are about to split vma, so store the start/end. */
 		vm_start = vma->vm_start;
 		vm_end = vma->vm_end;
@@ -1211,8 +1211,8 @@ static void unmap_source_vma(struct vma_remap_struct *vrm)
 	 * |             |
 	 * |-------------|
 	 *
-	 * Having cleared VM_ACCOUNT from the whole VMA, after we unmap above
-	 * we'll end up with:
+	 * Having cleared VMA_ACCOUNT_BIT from the whole VMA, after we unmap
+	 * above we'll end up with:
 	 *
 	 *    addr  end
 	 *     |     |
@@ -1232,13 +1232,15 @@ static void unmap_source_vma(struct vma_remap_struct *vrm)
 		if (vm_start < addr) {
 			struct vm_area_struct *prev = vma_prev(&vmi);
 
-			vm_flags_set(prev, VM_ACCOUNT); /* Acquires VMA lock. */
+			vma_start_write(prev);
+			vma_set_flags(prev, VMA_ACCOUNT_BIT);
 		}
 
 		if (vm_end > end) {
 			struct vm_area_struct *next = vma_next(&vmi);
 
-			vm_flags_set(next, VM_ACCOUNT); /* Acquires VMA lock. */
+			vma_start_write(next);
+			vma_set_flags(next, VMA_ACCOUNT_BIT);
 		}
 	}
 }
@@ -1321,8 +1323,8 @@ static void dontunmap_complete(struct vma_remap_struct *vrm,
 	unsigned long old_start = vrm->vma->vm_start;
 	unsigned long old_end = vrm->vma->vm_end;
 
-	/* We always clear VM_LOCKED[ONFAULT] on the old VMA. */
-	vm_flags_clear(vrm->vma, VM_LOCKED_MASK);
+	/* We always clear VMA_LOCKED[ONFAULT]_BIT on the old VMA. */
+	vma_clear_flags_mask(vrm->vma, VMA_LOCKED_MASK);
 
 	/*
 	 * anon_vma links of the old vma is no longer needed after its page
@@ -1758,14 +1760,14 @@ static int check_prep_vma(struct vma_remap_struct *vrm)
 	 * based on the original.  There are no known use cases for this
 	 * behavior.  As a result, fail such attempts.
 	 */
-	if (!old_len && !(vma->vm_flags & (VM_SHARED | VM_MAYSHARE))) {
+	if (!old_len && !vma_test_any(vma, VMA_SHARED_BIT, VMA_MAYSHARE_BIT)) {
 		pr_warn_once("%s (%d): attempted to duplicate a private mapping with mremap.  This is not supported.\n",
 			     current->comm, current->pid);
 		return -EINVAL;
 	}
 
 	if ((vrm->flags & MREMAP_DONTUNMAP) &&
-			(vma->vm_flags & (VM_DONTEXPAND | VM_PFNMAP)))
+	    vma_test_any(vma, VMA_DONTEXPAND_BIT, VMA_PFNMAP_BIT))
 		return -EINVAL;
 
 	/*
@@ -1795,7 +1797,7 @@ static int check_prep_vma(struct vma_remap_struct *vrm)
 		return 0;
 
 	/* We are expanding and the VMA is mlock()'d so we need to populate. */
-	if (vma->vm_flags & VM_LOCKED)
+	if (vma_test(vma, VMA_LOCKED_BIT))
 		vrm->populate_expand = true;
 
 	/* Need to be careful about a growing mapping */
@@ -1803,10 +1805,10 @@ static int check_prep_vma(struct vma_remap_struct *vrm)
 	if (pgoff + (new_len >> PAGE_SHIFT) < pgoff)
 		return -EINVAL;
 
-	if (vma->vm_flags & (VM_DONTEXPAND | VM_PFNMAP))
+	if (vma_test_any(vma, VMA_DONTEXPAND_BIT, VMA_PFNMAP_BIT))
 		return -EFAULT;
 
-	if (!mlock_future_ok(mm, vma->vm_flags & VM_LOCKED, vrm->delta))
+	if (!mlock_future_ok(mm, vma_test(vma, VMA_LOCKED_BIT), vrm->delta))
 		return -EAGAIN;
 
 	if (!may_expand_vm(mm, &vma->flags, vrm->delta >> PAGE_SHIFT))
-- 
2.54.0


