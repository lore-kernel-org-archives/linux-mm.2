Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF6DAC44501
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 18:49:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3A966B00AB; Sat, 11 Jul 2026 14:49:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E9A26B0088; Sat, 11 Jul 2026 14:49:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88B2F6B00AC; Sat, 11 Jul 2026 14:49:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 55EAC6B0088
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 14:49:15 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EAB9640778
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 18:49:14 +0000 (UTC)
X-FDA: 84977383428.13.A42C759
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id AB3EC4000C;
	Sat, 11 Jul 2026 18:49:12 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="A3lQ/qzw";
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783795753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PQeVSJrFNGuAKYRqlJkf6JopIzp3qlHM9CyXIq3KHK4=;
	b=4nOmgz62k/5FQMdX7qiq+Wd2yMss5iDkVq+KSQPehfqyDwSAPJnKUFRD2WF2rM3pUAaedk
	lGig1ZsC+Xs4Kxu+oa5p37u/8lKx5acS3Nf6enG+fkgGGUtfyenDfbzjqsBukJl0FSr9c7
	td5An/HMQWIEbqDNIYNI0Kyk/2xqBNA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="A3lQ/qzw";
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783795753;
	b=fdy9KJpovP/Q2q2N/OmvFWTYL3XYvomkNgm8Izz4uEFzecwLplNyw7H41T/ARr+9EY9rwJ
	Kkf2kP6ZdEOkyDSKv2drFX2W9oue7WNyNuzaGZCShVGWLh2es/7MPzBwxEhbAc+4BUlBFG
	sxkBSIFfNFZ4G0IS74ox2OAq9wPHG4g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F3F59418D3;
	Sat, 11 Jul 2026 18:49:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7572D1F000E9;
	Sat, 11 Jul 2026 18:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783795751;
	bh=PQeVSJrFNGuAKYRqlJkf6JopIzp3qlHM9CyXIq3KHK4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=A3lQ/qzw9J0Mef36BzMgXFxCB7dkGxinxIIAW9JQmfMzrEgdVXCZbMvez44EZPEeX
	 gzXNhanDpKBvr0GU1vbuTRlAVgICQASw38QvYjbrawwYLjk41zoY+o6bs5EJQXWA4B
	 N8ZheKvFfC7ObvlfJNb/UgFOGLScihFKvVLmqfFpAtRomluF+G9vwP3+ja7py9qw8f
	 K4SpVyb7Rs9cJFxpYgZkzgj3ThMgqYWZtLE4yV783JlpDDz2j3hz/q139ORq9vViT5
	 +PH6eC4zBsvX0nSUubBGLLM+1N8LdIbC9v3OR05k+HOezHB2d7wpLQkmt7rZqu2Bfi
	 X2DIl7kAZDv+A==
From: Lorenzo Stoakes <ljs@kernel.org>
Date: Sat, 11 Jul 2026 19:45:07 +0100
Subject: [PATCH v2 10/13] mm/vma: convert miscellaneous uses of VMA flags
 in core mm
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260711-b4-vma-flags-mm-v2-10-0fa2357d5431@kernel.org>
References: <20260711-b4-vma-flags-mm-v2-0-0fa2357d5431@kernel.org>
In-Reply-To: <20260711-b4-vma-flags-mm-v2-0-0fa2357d5431@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, 
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
 Benjamin LaHaise <bcrl@kvack.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, Zi Yan <ziy@nvidia.com>, 
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 Lucas Stach <l.stach@pengutronix.de>, 
 Russell King <linux+etnaviv@armlinux.org.uk>, 
 Christian Gmeiner <christian.gmeiner@gmail.com>, 
 Inki Dae <inki.dae@samsung.com>, Seung-Woo Kim <sw0312.kim@samsung.com>, 
 Kyungmin Park <kyungmin.park@samsung.com>, 
 Krzysztof Kozlowski <krzk@kernel.org>, 
 Peter Griffin <peter.griffin@linaro.org>, 
 Alim Akhtar <alim.akhtar@samsung.com>, 
 Jani Nikula <jani.nikula@linux.intel.com>, 
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, 
 Rodrigo Vivi <rodrigo.vivi@intel.com>, 
 Tvrtko Ursulin <tursulin@ursulin.net>, 
 Rob Clark <robin.clark@oss.qualcomm.com>, 
 Dmitry Baryshkov <lumag@kernel.org>, 
 Abhinav Kumar <abhinav.kumar@linux.dev>, 
 Jessica Zhang <jesszhan0024@gmail.com>, Sean Paul <sean@poorly.run>, 
 Marijn Suijten <marijn.suijten@somainline.org>, 
 Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>, 
 Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>, 
 Sandy Huang <hjc@rock-chips.com>, 
 =?utf-8?q?Heiko_St=C3=BCbner?= <heiko@sntech.de>, 
 Andy Yan <andy.yan@rock-chips.com>, 
 Thierry Reding <thierry.reding@kernel.org>, 
 Mikko Perttunen <mperttunen@nvidia.com>, 
 Jonathan Hunter <jonathanh@nvidia.com>, Gerd Hoffmann <kraxel@redhat.com>, 
 Dmitry Osipenko <dmitry.osipenko@collabora.com>, 
 Gurchetan Singh <gurchetansingh@chromium.org>, 
 Chia-I Wu <olvaffe@gmail.com>, Zack Rusin <zack.rusin@broadcom.com>, 
 Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, 
 Matthew Brost <matthew.brost@intel.com>, 
 =?utf-8?q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
 Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>, 
 Helge Deller <deller@gmx.de>, Kees Cook <kees@kernel.org>, 
 Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, 
 Boris Brezillon <boris.brezillon@collabora.com>, 
 Steven Price <steven.price@arm.com>, Liviu Dudau <liviu.dudau@arm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org, 
 linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, dri-devel@lists.freedesktop.org, 
 etnaviv@lists.freedesktop.org, linux-arm-kernel@lists.infradead.org, 
 linux-samsung-soc@vger.kernel.org, intel-gfx@lists.freedesktop.org, 
 linux-arm-msm@vger.kernel.org, freedreno@lists.freedesktop.org, 
 nouveau@lists.freedesktop.org, linux-rockchip@lists.infradead.org, 
 linux-tegra@vger.kernel.org, virtualization@lists.linux.dev, 
 intel-xe@lists.freedesktop.org, xen-devel@lists.xenproject.org, 
 linux-fbdev@vger.kernel.org, linux-sound@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=6231; i=ljs@kernel.org;
 h=from:subject:message-id; bh=2Eukk7/bboJXcRN4Serqm42H9hjt4k2BF/S8ckNM3q8=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKC+q1YA9XOTHweaCw7b1K84KM/l+4VzJwymz/yypnOw
 EgXoUUrO0pZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjARtxOMDJfd9Z1WrGFzkSqR
 k3zENmPW9uv9Jq2mlyfbPCqdYyDftZfhD/8EKYZXMltEpvpf7zFQMVFoW/Ccy10ubMFc/7tFUrK
 OTAA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AB3EC4000C
X-Stat-Signature: bm3xetouh53r4uk1qixcx5gbcgimm1r3
X-HE-Tag: 1783795752-435044
X-HE-Meta: U2FsdGVkX18FRDtzOfhmsXAgNh3TejTVMJqP7g2ocjS/QSE57WAtYZMbgLPvMkDVIQG00rzauskBVl0SvEyTjJTN2lDpWtNDb+cefnJcJan8K3rsBUExTv4gpSsVeZ48r6omhagDxwxdtcfWY5si3V2yHv1KPonG77sDABjrhhkwg/7LXORVVcQC0JdG5IFgILF7Oo1SAruD45uALspXaE8neeyzkM5hgUURFd11UQSTYxuTXfT93n5zHHpBM/rFTXF8VXfrWH2Zuh0TzbqCxHdfYpkZhRkc68xfmjOEnf3x/7LzLFmhQM39DaKIbbMGp0LUkcaAJDKoKUs0Nwz0Tmjoq/6gJuWnjVqfw643FzZBTUEuC72U5apT/dQxsrWogQD9PO3KLnMa5zHTl3iqRwwuuXAg9fzC/zuX7xV4IbULbrSZRNP3nwAJS5i2/F4kdB9dNjKUFt71n66aWp2XN3Hgplw787OxYlYP5fx6NDmeBXnjQBCFQnq05D+5+VB25JT3flPEQRD0Nk1TMFHHzejUPgT+okKk78VLEKUkV+8pzrcivVKWuqJhXJB1IIQ4AqSNWvl2yoS0y2V9aimHJBZDD2yVQGGnhNlsaK/Jypf3SAMkz9/qc86C5CQQgWFl42/yHQt/IyAO3lj88EcHB9ViTIe5urMF4bgFfVXmnGH1+9Jbqn91MvnG8+xJRHc0uEz+VaP7xpFT1zINTYfkZ3PSOmm5IDhHnSFC9OuzFYbR4dBSvr6wyxn8YABq3LlP/llxH+JtCKJV8Jvl6gmmnZVCb1TvuXee/T3/4F9m3CddtqWp7/KbPXVny5Dt8qJkksWrXpzPWw2JkrWukCpEOk7Cb8dUsly0uhFqto0DPJUBy2NOZuHoMfoNW3ScdThAfI8vIkDUqg02CTttwpiX3UxnOcntDRv9Sr4qoZSH/fwxFE00k9W1aUjhB0zFJ0zDHT8Gh2DK5oYu58crUAx
 0EYQ6PZb
 GNoErGevJ8QD1ZMArk1eHjFkOpCbpbFxrtEqUbKHr12BkT5vs4lIULKk78XbctULRyixknP21muoc/+7W6FT3x4572E6t2MdKRvSegJWxvfQPwXjkIHtIWimou/LVhNQanu+m1fJw7xW/E10DJogYh1nyWeauV/WhJjOITUhgxDgXR4T9ugX8rAntx2iYUAsNZx/YY8BqB46HiC9+HirjOnjooL8GWxKgsX7c2C0pNbWTmLVV2x/W+WYsqY0DIkiW/zs/+DsBkG1C+VkPOromc2aouCBaDONsSLXkUn5tmdgsea/R/Kl6C3ST62H8Btu4svkc0ZEhEiM+UE3MI7H7IzpcsoI/q+k2JZcr/VWa4UOMBjqiGAHYG29Bbjyl2OtzAjae
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update various uses of legacy flags in vma.c and mmap.c to the new
vma_flags_t type, updating comments alongside them to be consistent.

No functional change intended.

Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 mm/mmap.c | 39 +++++++++++++++++++++------------------
 mm/vma.c  | 13 ++++++++-----
 2 files changed, 29 insertions(+), 23 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 2076c70e7700..4bf26b0f1e6e 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -557,8 +557,8 @@ unsigned long do_mmap(struct file *file, unsigned long addr,
 	}
 
 	/*
-	 * Set 'VM_NORESERVE' if we should not account for the
-	 * memory use of this mapping.
+	 * Set VMA_NORESERVE_BIT if we should not account for the memory use
+	 * of this mapping.
 	 */
 	if (flags & MAP_NORESERVE) {
 		/* We honor MAP_NORESERVE if allowed to overcommit */
@@ -985,7 +985,7 @@ struct vm_area_struct *find_extend_vma_locked(struct mm_struct *mm, unsigned lon
 		return NULL;
 	if (expand_stack_locked(prev, addr))
 		return NULL;
-	if (prev->vm_flags & VM_LOCKED)
+	if (vma_test(prev, VMA_LOCKED_BIT))
 		populate_vma_page_range(prev, addr, prev->vm_end, NULL);
 	return prev;
 }
@@ -1009,7 +1009,7 @@ struct vm_area_struct *find_extend_vma_locked(struct mm_struct *mm, unsigned lon
 	start = vma->vm_start;
 	if (expand_stack_locked(vma, addr))
 		return NULL;
-	if (vma->vm_flags & VM_LOCKED)
+	if (vma_test(vma, VMA_LOCKED_BIT))
 		populate_vma_page_range(vma, addr, start, NULL);
 	return vma;
 }
@@ -1134,18 +1134,18 @@ SYSCALL_DEFINE5(remap_file_pages, unsigned long, start, unsigned long, size,
 	 */
 	vma = vma_lookup(mm, start);
 
-	if (!vma || !(vma->vm_flags & VM_SHARED)) {
+	if (!vma || !vma_test(vma, VMA_SHARED_BIT)) {
 		mmap_read_unlock(mm);
 		return -EINVAL;
 	}
 
-	prot |= vma->vm_flags & VM_READ ? PROT_READ : 0;
-	prot |= vma->vm_flags & VM_WRITE ? PROT_WRITE : 0;
-	prot |= vma->vm_flags & VM_EXEC ? PROT_EXEC : 0;
+	prot |= vma_test(vma, VMA_READ_BIT) ? PROT_READ : 0;
+	prot |= vma_test(vma, VMA_WRITE_BIT) ? PROT_WRITE : 0;
+	prot |= vma_test(vma, VMA_EXEC_BIT) ? PROT_EXEC : 0;
 
 	flags &= MAP_NONBLOCK;
 	flags |= MAP_SHARED | MAP_FIXED | MAP_POPULATE;
-	if (vma->vm_flags & VM_LOCKED)
+	if (vma_test(vma, VMA_LOCKED_BIT))
 		flags |= MAP_LOCKED;
 
 	/* Save vm_flags used to calculate prot and flags, and recheck later. */
@@ -1271,7 +1271,7 @@ unsigned long tear_down_vmas(struct mm_struct *mm, struct vma_iterator *vmi,
 	mmap_assert_write_locked(mm);
 	vma_iter_set(vmi, vma->vm_end);
 	do {
-		if (vma->vm_flags & VM_ACCOUNT)
+		if (vma_test(vma, VMA_ACCOUNT_BIT))
 			nr_accounted += vma_pages(vma);
 		vma_mark_detached(vma);
 		remove_vma(vma);
@@ -1420,7 +1420,7 @@ static int special_mapping_split(struct vm_area_struct *vma, unsigned long addr)
 {
 	/*
 	 * Forbid splitting special mappings - kernel has expectations over
-	 * the number of pages in mapping. Together with VM_DONTEXPAND
+	 * the number of pages in mapping. Together with VMA_DONTEXPAND_BIT
 	 * the size of vma should stay the same over the special mapping's
 	 * lifetime.
 	 */
@@ -1692,7 +1692,7 @@ bool mmap_read_lock_maybe_expand(struct mm_struct *mm,
 		return true;
 	}
 
-	if (!(new_vma->vm_flags & VM_GROWSDOWN))
+	if (!vma_test(new_vma, VMA_GROWSDOWN_BIT))
 		return false;
 
 	mmap_write_lock(mm);
@@ -1742,7 +1742,7 @@ __latent_entropy int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 		retval = vma_start_write_killable(mpnt);
 		if (retval < 0)
 			goto loop_out;
-		if (mpnt->vm_flags & VM_DONTCOPY) {
+		if (vma_test(mpnt, VMA_DONTCOPY_BIT)) {
 			retval = vma_iter_clear_gfp(&vmi, mpnt->vm_start,
 						    mpnt->vm_end, GFP_KERNEL);
 			if (retval)
@@ -1752,7 +1752,7 @@ __latent_entropy int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 			continue;
 		}
 		charge = 0;
-		if (mpnt->vm_flags & VM_ACCOUNT) {
+		if (vma_test(mpnt, VMA_ACCOUNT_BIT)) {
 			unsigned long len = vma_pages(mpnt);
 
 			if (security_vm_enough_memory_mm(oldmm, len)) /* sic */
@@ -1770,16 +1770,19 @@ __latent_entropy int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 		retval = dup_userfaultfd(tmp, &uf);
 		if (retval)
 			goto fail_nomem_anon_vma_fork;
-		if (tmp->vm_flags & VM_WIPEONFORK) {
+
+		if (vma_test(tmp, VMA_WIPEONFORK_BIT)) {
 			/*
-			 * VM_WIPEONFORK gets a clean slate in the child.
+			 * VMA_WIPEONFORK_BIT gets a clean slate in the child.
 			 * Don't prepare anon_vma until fault since we don't
 			 * copy page for current vma.
 			 */
 			tmp->anon_vma = NULL;
 		} else if (anon_vma_fork(tmp, mpnt))
 			goto fail_nomem_anon_vma_fork;
-		vm_flags_clear(tmp, VM_LOCKED_MASK);
+
+		vma_start_write(tmp);
+		vma_clear_flags_mask(tmp, VMA_LOCKED_MASK);
 		/*
 		 * Copy/update hugetlb private vma information.
 		 */
@@ -1812,7 +1815,7 @@ __latent_entropy int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 			i_mmap_unlock_write(mapping);
 		}
 
-		if (!(tmp->vm_flags & VM_WIPEONFORK))
+		if (!vma_test(tmp, VMA_WIPEONFORK_BIT))
 			retval = copy_page_range(tmp, mpnt);
 
 		if (retval) {
diff --git a/mm/vma.c b/mm/vma.c
index e0ad895098a9..b5bc3eec961c 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -3419,17 +3419,20 @@ struct vm_area_struct *__install_special_mapping(
 	vm_flags_t vm_flags, void *priv,
 	const struct vm_operations_struct *ops)
 {
-	int ret;
+	vma_flags_t vma_flags = legacy_to_vma_flags(vm_flags);
 	struct vm_area_struct *vma;
+	int ret;
 
 	vma = vm_area_alloc(mm);
-	if (unlikely(vma == NULL))
+	if (unlikely(!vma))
 		return ERR_PTR(-ENOMEM);
 
-	vm_flags |= vma_flags_to_legacy(mm->def_vma_flags) | VM_DONTEXPAND;
+	vma_flags_set_mask(&vma_flags, mm->def_vma_flags);
+	vma_flags_set(&vma_flags, VMA_DONTEXPAND_BIT);
 	if (pgtable_supports_soft_dirty())
-		vm_flags |= VM_SOFTDIRTY;
-	vm_flags_init(vma, vm_flags & ~VM_LOCKED_MASK);
+		vma_flags_set(&vma_flags, VMA_SOFTDIRTY_BIT);
+	vma_flags_clear_mask(&vma_flags, VMA_LOCKED_MASK);
+	vma->flags = vma_flags;
 	vma->vm_page_prot = vma_get_page_prot(vma);
 
 	vma->vm_ops = ops;

-- 
2.55.0


