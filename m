Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78534C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 19:26:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49BE66B0108; Mon, 29 Jun 2026 15:26:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 361C36B0107; Mon, 29 Jun 2026 15:26:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 200166B0102; Mon, 29 Jun 2026 15:26:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D2C386B0105
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 15:26:14 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4C02E1C627D
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 19:26:14 +0000 (UTC)
X-FDA: 84933931068.07.36E64AF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1BA55C0006;
	Mon, 29 Jun 2026 19:26:11 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aLceiJFh;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782761172;
	b=HsSfBScSvRS037zQyzC+4PvpkCbX+vdPm8mz2yzPaT2yIS4NrRCs1AZ7JWPZ+JJgn9vF5l
	RRrm5DnRqozBmu33S2n80iQy+adVbWRGc5Z5Q/2bh1pPCTTasKjpwYgBPYU7JNEkt5elzP
	uOKxFNiW4GSNThLAnra4z0r3QXXcxOQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782761172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UckrPyyaq5eQ3/ESdKIiCBv0nseBWr37AnyJxZAhDyA=;
	b=g9kKN1bVUIHYTnaDkc1EN2Gu53o1BgpDoubyOMrjzh4mzyFJ+3IlgDD9tafROMb9+txC+R
	WBT/Smcdm3WMmCn6CBkajOSxmkDoqLQX+g2UPWJZ01Kb90ivB8Z8NUsyleHTDE5zv0blsF
	Rd8VM5i6QOFYG9r0sLxNZUwDKgV/w7o=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aLceiJFh;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F3B8342AD6;
	Mon, 29 Jun 2026 19:26:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 144CE1F000E9;
	Mon, 29 Jun 2026 19:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782761170;
	bh=UckrPyyaq5eQ3/ESdKIiCBv0nseBWr37AnyJxZAhDyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aLceiJFh+snHgwJGHP/qCXPhR7qJ8YyjaxrTlyR7D0hm5wLyHQY+iiA2uneyDGmJj
	 G1AZncsiLujD5kbc1tsdhnrkJC1E7rMCK1ujoj1v4UNRKHLZ2ORGgy2VUFnNGPcKDg
	 qaMyPLULt4Sx9ASgeeO/9di4CBbN4HFxF8uEtPuukCrlTuIeaGOoXMhYYoTszUhLhD
	 fvTqEJQb4R9AyFWNvK4MljxzMGQy1r1QEaCpWeY0/SsjhR5XfDBHn1Ges8h1q3P8fo
	 GY2yfWatCDrMfqmDF8fuVGk9e/dRAHn2Nv/h2jGdVSYE3pZVge2XsX8pZGvzj03VY4
	 zsNjEpharm7Yw==
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
Subject: [PATCH 05/13] mm: prefer mm->def_vma_flags in mm logic
Date: Mon, 29 Jun 2026 20:25:28 +0100
Message-ID: <3b4ccdc38819b42ddc79ee5a795831208ac7986c.1782760670.git.ljs@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1782760670.git.ljs@kernel.org>
References: <cover.1782760670.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: cetdnaccb4k8f8f8peccj59cxfoyhdqf
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1BA55C0006
X-HE-Tag: 1782761171-690850
X-HE-Meta: U2FsdGVkX185fieRcFWyNJto/05BFBTpbkhDJVUnYkVN3cheMjaDLSLEwuYR5ZSV3sprcNt2sYG3f4FZk/o5CVjIxIqvM3Jt2EoheDItXCP6xmr3KX2HqsFEJ+6ZlheLWoZqwXaAsHlnRXiJykYoKh+v2duDLVHdWmEhkCVXZXNQB7GdZibN98ztRLpP+E/H7wGgq+FQy5TXTg6QzhUkgkXSn+6zUFG1/WaqEw4T76/8ldARpNVZbhrqZfTOyxx/WeEHcLusa3RqDYRTFcHOmaZ97EiWr8CKsXtcdtTXjd8JAanDQ5tRy+NlB0RQGTN02/YgPFYTCGSZcKRtKorHXCTdjJGLHJgDgnjD2I6iAYl7tdrbHBnWW5fVBdhtNnLubzHI4JKospKFkR/vJ/dzpRDo/qNT6NcDlZpBdss7DepXK3nTdXcZBOdm2uET9v7Cy4bdKOzpODowNTnULSF1sDaS7ngZ+3t9K5qs+ETuNy1cIO5jN6csU451VtuFJwS5kZQFmAa7Jcf0bZezOVHl1cxeU0Wis6JvM+uAihRvzAch3XB2bTkcKqTksNIfTai6ZGjWI4LgfvPi7yKk9mZsLYS2u6naFi0EcyML7N/PA2Uu3xVy8btOg+vJKR87Qgne55fbJK6xOZyIw5Xg4AEq/oVNa1TSzQHAGWAmf7X+3Vg2zUXWCwO8/Tgy4AdcRzzEWAOpK2XdlmXYPH3L46ylZLwSQy7EyE0LW/DJTJd4gqJRL9WtRrmpDBzPDrVgZyPf5+VME4gez0Nlwi75VTXsf8ozoE1rsAHY/x5vD0sUw1jJ6xqeP1p0lXavd/6xEIfr/BUStNQ9mXLXBA3PXAbvJE5bzjTjr0bK8iuIfJwi1amO1cpEmDa6dUCKO3rL25fEhxA09w+f9fEUEt+gNXupWml3gBbWBW/CLv8YFynubaC01aJydqeZUdi8cTNV/18cgzu5i75jbAK4RBCYJFO
 m6aX4gp1
 EPACVtwA3M6fxeMYZ4pAghXFbLH48Z/imzb2TADOXqBlXLGCuEgDzx01lR8efVZKHt75fLTxEI/lvg/2E1l7A9CpuhR5ThhGr2UVLLYrU2z2B2lx9GqfKwrGYmXBxEXC6onsJZ7/Cvn42rt9prQqySkZnfKI8vo5EbRZITNlwBu1NrjLu16uxcJWuW0UBh5wte857UgQ7scPRs8dq35sZw9tjp0vEz3TUqiDZPxModGd62FdU0NGORTWxdnUjeUHlAK/AYl9ZTO3thvoiNS35zomu8vU/RVl/dT/V
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently mm->def_flags (of type vm_flags_t) is union'd with
mm->def_vma_flags (of type vma_flags_t).

As part of the effort to convert vm_flags_t usage to vma_flags_t (in order
to no longer be arbitrarily limited to a system word size for VMA flags),
prefer mm->def_vma_flags to mm->def_flags throughout the mm logic.

No functional change intended.

Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 mm/debug.c |  2 +-
 mm/mlock.c | 13 +++++++------
 mm/mmap.c  | 11 ++++++-----
 mm/vma.c   |  4 ++--
 4 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/mm/debug.c b/mm/debug.c
index 497654b36f1a..f0a354a9496a 100644
--- a/mm/debug.c
+++ b/mm/debug.c
@@ -226,7 +226,7 @@ void dump_mm(const struct mm_struct *mm)
 		mm->numa_next_scan, mm->numa_scan_offset, mm->numa_scan_seq,
 #endif
 		atomic_read(&mm->tlb_flush_pending),
-		mm->def_flags, &mm->def_flags
+		vma_flags_to_legacy(mm->def_vma_flags), &mm->def_vma_flags
 	);
 }
 EXPORT_SYMBOL(dump_mm);
diff --git a/mm/mlock.c b/mm/mlock.c
index 8c227fefa2df..9c87b3ced65f 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -699,26 +699,27 @@ SYSCALL_DEFINE2(munlock, unsigned long, start, size_t, len)
 
 /*
  * Take the MCL_* flags passed into mlockall (or 0 if called from munlockall)
- * and translate into the appropriate modifications to mm->def_flags and/or the
- * flags for all current VMAs.
+ * and translate into the appropriate modifications to mm->def_vma_flags and/or
+ * the flags for all current VMAs.
  *
  * There are a couple of subtleties with this.  If mlockall() is called multiple
  * times with different flags, the values do not necessarily stack.  If mlockall
  * is called once including the MCL_FUTURE flag and then a second time without
- * it, VM_LOCKED and VM_LOCKONFAULT will be cleared from mm->def_flags.
+ * it, VM_LOCKED and VM_LOCKONFAULT will be cleared from mm->def_vma_flags.
  */
 static int apply_mlockall_flags(int flags)
 {
 	VMA_ITERATOR(vmi, current->mm, 0);
+	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma, *prev = NULL;
 	vm_flags_t to_add = 0;
 
-	current->mm->def_flags &= ~VM_LOCKED_MASK;
+	vma_flags_clear_mask(&mm->def_vma_flags, VMA_LOCKED_MASK);
 	if (flags & MCL_FUTURE) {
-		current->mm->def_flags |= VM_LOCKED;
+		vma_flags_set(&mm->def_vma_flags, VMA_LOCKED_BIT);
 
 		if (flags & MCL_ONFAULT)
-			current->mm->def_flags |= VM_LOCKONFAULT;
+			vma_flags_set(&mm->def_vma_flags, VMA_LOCKONFAULT_BIT);
 
 		if (!(flags & MCL_CURRENT))
 			goto out;
diff --git a/mm/mmap.c b/mm/mmap.c
index 3ef603d5ff00..477f4a77361a 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -102,15 +102,16 @@ void vma_set_page_prot(struct vm_area_struct *vma)
  */
 static int check_brk_limits(unsigned long addr, unsigned long len)
 {
+	const struct mm_struct *mm = current->mm;
+	const bool is_def_locked =
+		vma_flags_test(&mm->def_vma_flags, VMA_LOCKED_BIT);
 	unsigned long mapped_addr;
 
 	mapped_addr = get_unmapped_area(NULL, addr, len, 0, MAP_FIXED);
 	if (IS_ERR_VALUE(mapped_addr))
 		return mapped_addr;
 
-	return mlock_future_ok(current->mm,
-			      current->mm->def_flags & VM_LOCKED, len)
-		? 0 : -EAGAIN;
+	return mlock_future_ok(mm, is_def_locked, len) ? 0 : -EAGAIN;
 }
 
 SYSCALL_DEFINE1(brk, unsigned long, brk)
@@ -197,7 +198,7 @@ SYSCALL_DEFINE1(brk, unsigned long, brk)
 		goto out;
 
 	mm->brk = brk;
-	if (mm->def_flags & VM_LOCKED)
+	if (vma_flags_test(&mm->def_vma_flags, VMA_LOCKED_BIT))
 		populate = true;
 
 success:
@@ -1247,7 +1248,7 @@ int vm_brk_flags(unsigned long addr, unsigned long request, bool is_exec)
 
 	vma = vma_prev(&vmi);
 	ret = do_brk_flags(&vmi, vma, addr, len, vma_flags);
-	populate = ((mm->def_flags & VM_LOCKED) != 0);
+	populate = vma_flags_test(&mm->def_vma_flags, VMA_LOCKED_BIT);
 	mmap_write_unlock(mm);
 	userfaultfd_unmap_complete(mm, &uf);
 	if (populate && !ret)
diff --git a/mm/vma.c b/mm/vma.c
index 3d1ae3cae45f..fb4341943576 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -3424,7 +3424,8 @@ struct vm_area_struct *__install_special_mapping(
 	if (unlikely(vma == NULL))
 		return ERR_PTR(-ENOMEM);
 
-	vm_flags |= mm->def_flags | VM_DONTEXPAND;
+	vma_set_range(vma, addr, addr + len, 0);
+	vm_flags |= vma_flags_to_legacy(mm->def_vma_flags) | VM_DONTEXPAND;
 	if (pgtable_supports_soft_dirty())
 		vm_flags |= VM_SOFTDIRTY;
 	vm_flags_init(vma, vm_flags & ~VM_LOCKED_MASK);
@@ -3432,7 +3433,6 @@ struct vm_area_struct *__install_special_mapping(
 
 	vma->vm_ops = ops;
 	vma->vm_private_data = priv;
-	vma_set_range(vma, addr, addr + len, 0);
 
 	ret = insert_vm_struct(mm, vma);
 	if (ret)
-- 
2.54.0


