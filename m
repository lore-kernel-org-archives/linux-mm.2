Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D4BAC43458
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 18:47:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EFAD6B0095; Sat, 11 Jul 2026 14:47:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06E9B6B008C; Sat, 11 Jul 2026 14:47:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E516E6B0095; Sat, 11 Jul 2026 14:47:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B061B6B0096
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 14:47:09 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 49F42169B30
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 18:47:09 +0000 (UTC)
X-FDA: 84977378178.24.9E3D9EF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0B23B18000A;
	Sat, 11 Jul 2026 18:47:06 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BGbT3efQ;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783795627;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cys+jf7FSJvkCpfIdDug3cdlx8ypGdMjngNui8wSibo=;
	b=a16e0FBNQ4X2qUV/RMXX0Wf/SVfNPeNRsBnoMMUC6EGuzIohneHlVS4wOVHOTB6yEAbirx
	2wehp472mQsR06ZAetmFIyVYQI0rbZsKFYoAmxvx+RTXbQA+lcjI6QAwGiGvoLqHnobVrB
	X6/9py7aZotxn+aqFNcT/bVDwmxEug8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BGbT3efQ;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783795627;
	b=e+P1H37gDeupnhh9SdcNldDZ+SXEPuhX3TOsnqsipNfcVvX8ecg4tWdmCiodkHHCNeDZAx
	EN/7Y58k/OiX272WcHTvAWqokYlqHXF8Ah5ZD75y0lxbThYtx7hMEgWCsWs8TnCsmvcOEM
	rEYRmwsMY6OwpW3mgqalwvmcMdYZWZ8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9970660052;
	Sat, 11 Jul 2026 18:47:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E38421F000E9;
	Sat, 11 Jul 2026 18:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783795626;
	bh=Cys+jf7FSJvkCpfIdDug3cdlx8ypGdMjngNui8wSibo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=BGbT3efQd05kEEjTh+aO4RIluI/3vbRGG07jZPAzbysVlgzwXnZVd8f3t8E8Vuhd6
	 /dACfscdhH9yKm6ORV9MIHznN0QDaIGK+Xd+Y+t8MqLriFyX1OaduZQhi7cZQzgZLA
	 zhkYGSy3lsS2NYCL1bWL202tjTmTDVV+eSqCV7wUyQZndnvpprLtQNMS5nm7owHWNj
	 KGyx5ds0GcgnPAShXFUlRpaavVRV26dnZg4wZ7A21dt9cXYXyOCSf0zPZMetrqJNJW
	 /KsazvPLmIyGMbdJPeU7/Pu006j9N9JCilWvEgMUxQFss7qH26Jx8s/ZkArz+vG1bl
	 K1uChQpzKnO0g==
From: Lorenzo Stoakes <ljs@kernel.org>
Date: Sat, 11 Jul 2026 19:45:01 +0100
Subject: [PATCH v2 04/13] mm: update generic_get_unmapped_area[_topdown]()
 to use vma_flags_t
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260711-b4-vma-flags-mm-v2-4-0fa2357d5431@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5495; i=ljs@kernel.org;
 h=from:subject:message-id; bh=q7YWuxvCY0LSuxzxUdXFVMeI8S+gRJqyF3+arUou2v8=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKC+i2NEp1+fZh+q6WCyTJbY35wdc6HWZPCOjy54oQmS
 8fxCv3pKGVhEONikBVTZHn+RXx/kEjYvM4L/m4wc1iZQIYwcHEKwET0vBgZzm+rtfp9UtOlYFNd
 VUrv+3hJr49ru99VTjn8XNVY8UQJG8N/t7zLlVMXTLjaPmvbSZkQrfo9K1r/7GqZnb+h7uyNZ7a
 OvAA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0B23B18000A
X-Stat-Signature: jf9zgjpu3jwagsq3f947twxcz8fd4atm
X-HE-Tag: 1783795626-305107
X-HE-Meta: U2FsdGVkX19JwG6LIHJlaNrpej84b60ZM48A/c3kdnlU81W4hvJcICkugcF/NG3C/MgbM6DdWkW6fEozI+q8Pw3R2S3tzxSqMxFtX3HokC89J8F8fQT6KhxrC9VBpCgtuSlqCmce7DdANqe5Yhhz1T9BBudHYEGbTW7qGaLzKn6H7lTbiyqI2xA0nbznZX9HJ6ygZXrg2uCKyuxYUsv1bCRHu+scXTGrcsIMN3koqEIY8iEqwpYEv8mIgMydw2KHoIdh7HIzGzIeJalLtz+FiK4yM2TouFtK4AwJoZagQTPgvloi+Vdmevp70YP8+ALhDNkQm7QmJMN3oGLRMUeMnfFopb5gA3YgCXrIxHvWsogx1bQaK8dJEfynNxwhLz2lgfWFS0oA4MwqVobYdT/OsqGfs97K/HHPrG+MhdXAZWKdEW9T2AYMpqKpIeQyjW6X+PEBwARSHN9hNrUaSxFLI5nsSxPUpEFwl6Buwj+MXhSa4HKpEd4nCA7NrCQ35BVypfobptbiEXLu1Nh6q4TemLzhOLcJrCY5Lf1iBJXVlLIIbdOynsu5smxqhlktuL/lQL3nO8J4z9EQvyBQDP6xNA8OiGDyLai+t2BMAlx3isXljKwjFcYfiBZfYqwPTMZcPcUKZMlaNkKXEVbo/twVmt6K89EVbfdm4u+pRI1DFu/oZkaSLqc88s3vhaA1KurZn18C0DONu8naqfI6MR+JuOl+E3FpK20Rgv26RqQXcw2o3MY9KHcdI3iAFuv48nPZBSEKgFcZnKDJTnOs7Kv5o0Xq0IxkMp1ortRjbG4SiOU4ueyfvJMc1+NA5aI8BsaNY67ejXA3zyCwdapavqT7LtEqDbwS/Uo+l9us+ass2RsDEfEISF9VkhOAJ2ROhbV3l0aurJLRA5BI8bDyj8+SCis6YvmAHG71I9P62eXGiNi5AxaZFTvbOPyeym0KPDekiXduA5XLG/6F95kqqgv
 6XD1qOCz
 O2wEPTCeE+KnXTQE47xyA3I8zamZsxVXM7qyFiJ/CGltE2ZZGLsa0rICW65G4HV1IOpYNUYNqtxNoF6ahebbmah3X/JRQSdTg5bQTbPwzQv2wsrAYm9Wn5qly0IocYRcQnF6F79I+0dxvSE0BsQN32Z63f2gjdiQagn3om0paAjcwkg+hnRYY8PpmlvGfEpSEXp3RBbPM56ggQNDytERgy1pI0gIkHyfVgfonZMm1Lxg3aKZnSOpCECNV5zzjEey/pkuNIiKbnKKxPi7KoO39wSTQEhyXTzYfCbXCsvSZgDQsQHgoXtFEXCQddr14hlLWnxERFtEd8OxbDWTeBQiQJy4mOT7WbwCMm574NhSiGF3muo1XLdlVaxT9YtYj3zbMDf9MxQ1cp/Q47iYHzIkk376yRZBjtY0N0XFQbLHSZEgQA3nqBbJX7aHxNg==
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

Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
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
index 10d723bee95c..10be8a54b416 100644
--- a/include/linux/sched/mm.h
+++ b/include/linux/sched/mm.h
@@ -200,11 +200,11 @@ unsigned long mm_get_unmapped_area_vmaflags(struct file *filp,
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
index 4a88b2a233f7..39d33f3a55c2 100644
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
2.55.0


