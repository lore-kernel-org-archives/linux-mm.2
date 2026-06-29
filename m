Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 174EDC44500
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 19:26:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 203D16B0100; Mon, 29 Jun 2026 15:26:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18CEA6B00FF; Mon, 29 Jun 2026 15:26:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFA856B0103; Mon, 29 Jun 2026 15:26:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A88B16B00FF
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 15:26:11 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D56AE8AC1F
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 19:26:10 +0000 (UTC)
X-FDA: 84933930900.26.5E5151C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id D3468180004;
	Mon, 29 Jun 2026 19:26:08 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BExgykrx;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782761169;
	b=GbR0amkS+kLVBce8rwrSB0rVNmdQY/Jc/zw1OUp7r+y2bGyCIaP0Ka2q7n7qFFKJDi4Vh5
	zKVWl0ek7xsncDhBnIfcXN2f82TliTUzg62EkKmnV+9A87xktnqZ2U8CBPFGdK9VtWbBsI
	5Oh9umq3J5FxgKf5hQArgGkmmuQo+9E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782761169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hVd6ZuVqENj3zeMR4aL2t+2UMMhczNHM+gJ9snfAafg=;
	b=e48qKEsappq+8pd2D+77sHhSSa2CUgJpq2S++TF9QkF9Fc7bJUbydT9A0B6E0eXaXC3fNC
	myh6ocXTyOc7j3ECuFaqpz2NV19ltK40bbRuqukgBpTA2G7zkjTGVWk/Yx3HlGwB8AEDXg
	9WK5CkjBVaunkzNpj+MGN6tJ9+zyPdM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BExgykrx;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 51A386014B;
	Mon, 29 Jun 2026 19:26:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A2DC1F00A3E;
	Mon, 29 Jun 2026 19:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782761168;
	bh=hVd6ZuVqENj3zeMR4aL2t+2UMMhczNHM+gJ9snfAafg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BExgykrxcgTd5RClbXfmFD5Hp/1Grb/Kjey3DiRaMUeFZgqydXxsDWyRIvpzoISG7
	 /Iilv3IrxTXNlJUqKZNyr5TyZZvKbnpj8BmRYrG9ZFdN0Nb0i0NyJk8Sl7npMKfdti
	 1DTOuDeaNgSBKxd+05qng9++fyrY+sD0P/+0C6uNIMSgwntxptodo0GGuiVJ2fa7Xh
	 tcbnSkYetMr8IMTjqAFSQc8sq/Xc+KvUA6heTO4Lwayd0uEmx/7h0R2T9dkwHlc5h+
	 iCD7J6P0FnSJ3xPPyRVSFdOIImy48N18CmoYp7IbeVR4j1E/heYWHJ8ULXWfCEAyFn
	 uHB+/Pwf3DOzg==
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
Subject: [PATCH 04/13] mm: update generic_get_unmapped_area[_topdown]() to use vma_flags_t
Date: Mon, 29 Jun 2026 20:25:27 +0100
Message-ID: <cef55b19f86c110952f13829aefa4859db3a70ed.1782760670.git.ljs@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1782760670.git.ljs@kernel.org>
References: <cover.1782760670.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: s1xiuscymh6fjeeiap49grafgojsujux
X-Rspam-User: 
X-Rspamd-Queue-Id: D3468180004
X-Rspamd-Server: rspam02
X-HE-Tag: 1782761168-169877
X-HE-Meta: U2FsdGVkX1+V6ipSw5zT12pufyBde0AQkkbcsgkKO3BjIzAahAeuNOXjQe5Ua+UtVGJZ3ovEWBF+QGxkFIpQ1rc/5iiwmxUz1sXlEU3CpEu8lRLfv+NIyWt8P4hiwpzfckbjnMZ+Tq7YsjeVdlhfFJE0hLVjCdtqnVdURbH7KQSdD3EGS4q/pYY0wyQbnZZhEm2XoM9XDVgCETI/2qOcyy+1Wu6lu909Si8q5I0CVUJeeYsl7+PbOujAGnrHjxFPbcBVyL9351srvebHCTAPUOLsiAjvooV6r4Sbm+b9XkaG0BkGO/o0rKSm/M3b8/890UOsWJePNmtynn86mAK6a0thNcrg5OfExmjljWCXTzxZgAJ8DgzJW6t2L8q91rUqMkYdfTDxukC5oavrgBlk6s8+HnrkH5w6VGTXmh+VV2lgYS1tg91255We3cSx0ZfvfuxIGHJhaTyMCwzgsLUp/7ejb6zJWLOJx8lUOmAKE/iI9GI8fCAeiWP1muAXKOCxJTZ0NV26eazdy/lccpWtf/r5lggrn00jvGTOkfXbHo440qYzBkwDKQyo5fO9PlXB6J7NnmNuB7K0QT+Ot//IZnOTyWw/SdbJmGH53XAWIUi4/JEM5W1iMAriEXi7e2qkhNC9UU+QvA8RubUTDvlR9J40KAXNMM/jjoLJ/ioU7H8utKT6L77cT2DIdcUE8fZQOElu0EvdUVEENTihX+XQ9LxJKRcISr1Ys2GH5FSlxT25lsx/o07+x0L3CImdfk6tF7We48nZjnQ8uKtqeBU38wOwlvP+v6phhgNShj9THX4rKZWylpmZkCjKJ1me0SxtVRZC2lCMfEeqBnVV0cz+OiAhWFBojd0MUvJ1Larh+Ng0oRitxDqbJbaVnNDWNQJLpsHOkabDYQVIJGBPUaei4YbRU65Ay+vTMtUmy8tuQ/V6mj+MeLDVSuuvoa+3tHvCNjH0cRdcaBhfTkDpUio
 Zbt+yoTS
 6ZuN47JaANTsMGviZB2HoB3pLPgNzwewK2nWh2u2YtPujdS6y3SEtTNtQKk8W3GKEwwOsF4D/hZu8uZjTx1r91TfZveeDqFAYcYf2c8jUkHtYg3OpazNgbpJBdoTjb2nHHSZIxcGRArGCj3DzjfNyb0qaSTfhTBWINB/R3hX6l2YNkf5PsqNUWB7FgZzHAq9xGcSj/GGWj6mD1XcplxRMsASO8R/w4BZLqH9546gOqNF9/VuwGZCVXS1CCi5fzztXbKjit5BUmp3O5a1A2HNOGzzhSg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As part of the changes converting VMA flags from a system word size to a
bitmap, extend this change to generic_get_unmapped_area() and
generic_get_unmapped_area_topdown(), which also allows us to convert
stack_guard_placement() as well.

We retain arch_get_unmapped_area() and arch_get_unmapped_area_topdown()
as-is for now, using legacy_to_vma_flags() as necessary to do so.

No functional change intended.

Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 arch/powerpc/mm/book3s64/slice.c |  6 ++++--
 include/linux/sched/mm.h         |  4 ++--
 mm/mmap.c                        | 16 ++++++++--------
 3 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/arch/powerpc/mm/book3s64/slice.c b/arch/powerpc/mm/book3s64/slice.c
index 28bec5bc7879..82127e31dca6 100644
--- a/arch/powerpc/mm/book3s64/slice.c
+++ b/arch/powerpc/mm/book3s64/slice.c
@@ -659,7 +659,8 @@ unsigned long arch_get_unmapped_area(struct file *filp,
 	unsigned int psize;
 
 	if (radix_enabled())
-		return generic_get_unmapped_area(filp, addr, len, pgoff, flags, vm_flags);
+		return generic_get_unmapped_area(filp, addr, len, pgoff, flags,
+						 legacy_to_vma_flags(vm_flags));
 
 	if (filp && is_file_hugepages(filp))
 		psize = file_to_psize(filp);
@@ -679,7 +680,8 @@ unsigned long arch_get_unmapped_area_topdown(struct file *filp,
 	unsigned int psize;
 
 	if (radix_enabled())
-		return generic_get_unmapped_area_topdown(filp, addr0, len, pgoff, flags, vm_flags);
+		return generic_get_unmapped_area_topdown(filp, addr0, len,
+				pgoff, flags, legacy_to_vma_flags(vm_flags));
 
 	if (filp && is_file_hugepages(filp))
 		psize = file_to_psize(filp);
diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
index b301ec90740a..c8720d8e2158 100644
--- a/include/linux/sched/mm.h
+++ b/include/linux/sched/mm.h
@@ -203,11 +203,11 @@ unsigned long mm_get_unmapped_area_vmaflags(struct file *filp,
 unsigned long
 generic_get_unmapped_area(struct file *filp, unsigned long addr,
 			  unsigned long len, unsigned long pgoff,
-			  unsigned long flags, vm_flags_t vm_flags);
+			  unsigned long flags, vma_flags_t vma_flags);
 unsigned long
 generic_get_unmapped_area_topdown(struct file *filp, unsigned long addr,
 				  unsigned long len, unsigned long pgoff,
-				  unsigned long flags, vm_flags_t vm_flags);
+				  unsigned long flags, vma_flags_t vma_flags);
 #else
 static inline void arch_pick_mmap_layout(struct mm_struct *mm,
 					 const struct rlimit *rlim_stack) {}
diff --git a/mm/mmap.c b/mm/mmap.c
index 461ce510e12a..3ef603d5ff00 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -657,9 +657,9 @@ SYSCALL_DEFINE1(old_mmap, struct mmap_arg_struct __user *, arg)
  * Determine if the allocation needs to ensure that there is no
  * existing mapping within it's guard gaps, for use as start_gap.
  */
-static inline unsigned long stack_guard_placement(vm_flags_t vm_flags)
+static inline unsigned long stack_guard_placement(vma_flags_t vma_flags)
 {
-	if (vm_flags & VM_SHADOW_STACK)
+	if (vma_flags_test_single_mask(&vma_flags, VMA_SHADOW_STACK))
 		return PAGE_SIZE;
 
 	return 0;
@@ -701,7 +701,7 @@ unsigned long vm_unmapped_area(struct vm_unmapped_area_info *info)
 unsigned long
 generic_get_unmapped_area(struct file *filp, unsigned long addr,
 			  unsigned long len, unsigned long pgoff,
-			  unsigned long flags, vm_flags_t vm_flags)
+			  unsigned long flags, vma_flags_t vma_flags)
 {
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma, *prev;
@@ -726,7 +726,7 @@ generic_get_unmapped_area(struct file *filp, unsigned long addr,
 	info.length = len;
 	info.low_limit = mm->mmap_base;
 	info.high_limit = mmap_end;
-	info.start_gap = stack_guard_placement(vm_flags);
+	info.start_gap = stack_guard_placement(vma_flags);
 	if (filp && is_file_hugepages(filp))
 		info.align_mask = huge_page_mask_align(filp);
 	return vm_unmapped_area(&info);
@@ -739,7 +739,7 @@ arch_get_unmapped_area(struct file *filp, unsigned long addr,
 		       unsigned long flags, vm_flags_t vm_flags)
 {
 	return generic_get_unmapped_area(filp, addr, len, pgoff, flags,
-					 vm_flags);
+					 legacy_to_vma_flags(vm_flags));
 }
 #endif
 
@@ -750,7 +750,7 @@ arch_get_unmapped_area(struct file *filp, unsigned long addr,
 unsigned long
 generic_get_unmapped_area_topdown(struct file *filp, unsigned long addr,
 				  unsigned long len, unsigned long pgoff,
-				  unsigned long flags, vm_flags_t vm_flags)
+				  unsigned long flags, vma_flags_t vma_flags)
 {
 	struct vm_area_struct *vma, *prev;
 	struct mm_struct *mm = current->mm;
@@ -778,7 +778,7 @@ generic_get_unmapped_area_topdown(struct file *filp, unsigned long addr,
 	info.length = len;
 	info.low_limit = PAGE_SIZE;
 	info.high_limit = arch_get_mmap_base(addr, mm->mmap_base);
-	info.start_gap = stack_guard_placement(vm_flags);
+	info.start_gap = stack_guard_placement(vma_flags);
 	if (filp && is_file_hugepages(filp))
 		info.align_mask = huge_page_mask_align(filp);
 	addr = vm_unmapped_area(&info);
@@ -807,7 +807,7 @@ arch_get_unmapped_area_topdown(struct file *filp, unsigned long addr,
 			       unsigned long flags, vm_flags_t vm_flags)
 {
 	return generic_get_unmapped_area_topdown(filp, addr, len, pgoff, flags,
-						 vm_flags);
+						 legacy_to_vma_flags(vm_flags));
 }
 #endif
 
-- 
2.54.0


