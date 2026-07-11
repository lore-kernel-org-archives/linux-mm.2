Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49E43C44506
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 18:46:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F5676B0005; Sat, 11 Jul 2026 14:46:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17E426B008C; Sat, 11 Jul 2026 14:46:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 045C86B0093; Sat, 11 Jul 2026 14:46:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B477E6B0005
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 14:46:07 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 402281C8C63
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 18:46:07 +0000 (UTC)
X-FDA: 84977375574.25.C4C162C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 18A74100003;
	Sat, 11 Jul 2026 18:46:04 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b3IJ5UKX;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783795565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4X8Clz3fd1owNiO9Pv6vUhPn41dQXdJma9VDgzp5GpU=;
	b=XHBczRUZBwm7SXwGTPoIw3sfpG3WpBwwnRS3cXhZaBzvP7p34z2wSBxirKny55ovZl1PGy
	TbNMa2dLbg6cM9GIct2kHoXWhbPjXPiNQsAfQuOocEBWx9ha7MSh5ZgSpHjdOf6OZidI39
	8XlYNMLOqySidYde5Z6MFnXisYCjl14=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b3IJ5UKX;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783795565;
	b=G+jlzQn3Ksi6ZE1LDK/kfuNa8rdhNnIsLozkS3Cprc7IEm90e9gx46RQ6/revdS9wUoKGp
	PhQJaxboDyMV+iv/sDvQZkW+3v/beIda5Uk2wke8tbVT4STnkgDjDmgniPSPZXNeGN+wqU
	VlKhe7JuYYw8t6VciPMmxcll96dATLg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EA6AD60052;
	Sat, 11 Jul 2026 18:46:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2428F1F00A3A;
	Sat, 11 Jul 2026 18:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783795563;
	bh=4X8Clz3fd1owNiO9Pv6vUhPn41dQXdJma9VDgzp5GpU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=b3IJ5UKXJWHdstaNE7y5ot+/3k3QKa6AhRc7Wffa4hfZ305PVpEvaJKNGHLJ3wiys
	 kqVIiX25qZVXJaTT+Qgjr5ODbLIA55N49hux0vbRs0et3au9LBQKwrVwghVFXrLl7E
	 817VHGE33QrB50d5C1LscqS/7pNneUD0nYGcnWDai8gQyjsw4TcvH+fgmF1OwsvnN9
	 2pvaWR1/mhz3yp4qVYs3qwET2uh7D30e/8XDBnKYPp1TnRGR39oxh4CFkY52uJlQ/8
	 VseCL2NAhZF2r9D5qvydoKSBQPUnQ2/tkYhPSxvwJKQj0iFEdbJlYmSDUW8OLt0N5o
	 c+59QXF0t/z1Q==
From: Lorenzo Stoakes <ljs@kernel.org>
Date: Sat, 11 Jul 2026 19:44:58 +0100
Subject: [PATCH v2 01/13] mm: introduce vma_flags_can_grow() and
 vma_can_grow()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260711-b4-vma-flags-mm-v2-1-0fa2357d5431@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2177; i=ljs@kernel.org;
 h=from:subject:message-id; bh=oSsuzEZdPIZ+otSvvS1qpHgk2++YqmMZy2jJkjlchbs=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKC+i1DpYuvr35hfGA9T/DrI/smfbvJXDzdl/eEd9+FF
 xnT800OdZSyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAiZhoM/6xY7sV0KDJr3XKY
 uPtiX7X4ZaX5Xemv3hiY8c63tfCt1WL4xXQgV6XZa8a6lMQPuqVRFwM4zMVNbzY+TJao67/8NWA
 vKwA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 18A74100003
X-Stat-Signature: sqqsfm47qmgjrt8ahsmtqzki687n5kh4
X-HE-Tag: 1783795564-679551
X-HE-Meta: U2FsdGVkX18qCD0woxBdiYfpGMlLewvb6z5rF3Juq/+BK7ecVJH27NzdTNFufOCqL71KV9tDIpo5jfdFVb04Towb21bax/OeDFYd0ifXYPe5/roWg2tIY2gY8Ie7TmOnkIxRabprC1J/IlLeW2r3YEMxGwtBUNfaGUZi6O/8Py+pRxI5JPiifvBZnLss8ODxQC0M6TTb/1GgZYrs0YzsPDvHRXPgZw9sWFSI0dWHCdQOEis8zGEaxMxhfZcn4CSumVOQezdH1M0gHm76wmV2mlx4AbrGxdaV8S9ThWvm8OKrWXnft90NDVTo4drvbSfTdqA0s8MGLUmrliZoK+vr+EnN6ucWhLgDglxaJjPqXu8Jrh3iW/zD6J8Zy0NY5//RdNuI0+dAvmosX2kE85+4v5CCgUmluDn6+RYCu05Pgm5sAEJJddcjG7S+I+7YMGSfmz4aF/AGTqGKrC9lo0I4yRcaWrQwinwQwIoZd4T1P0Q/nicj2uBSL1rlfLc7eXdpTi06Ngx89Z8NKuFx9zW2Qmk2eP7xOZtZCTRUOAjwGKMwx9xnzbatcz/AbvXc3lrsrwURbw+OtsaDZrjQa/wL5vnFOioIHSQ+7gGUuzEg1gaEYKXT3XDtRWDTh9daG6rh5SPQWZ+hT70UjO9hGj3D2lsuo/dXrruYdUz9DpFiaiMo3D0pnvtMD6Cjd8lwNArxio5dz+kF7gREIqvA/ThKd8bXRI5bO+jb1ciTU7svjG9tT1d6wXBpUV8OyVCXaRpY4jWBVr0dZCMPNMmbnvrKeV2U9Aw/OIV+YDQjoagprLpSyw2i5sE7SQm5REtMaInujA5l5G3RXPtraXFeLT96aYno8f28CCtTGAiXLe8wvWuxcV4mb5VvH81zWlx5/eGuke/BMFtknic5h4gffixpnvTQouj5/nu7bt1mNbvb1dzHIJ97hqMMoJv/yidEMEoK4i9jlo8CuH7I1QN7kk/
 waXjJ0ji
 hah04NJmu4h+f7W+PHzwwjguIHknB2PITJcicPFIUoIaEeWQiwn+KCkfBrAcDL0O0ZTrUI2FtilENqOGDdKyXtq3y63akF1kc/Nw+GLioARqSd0hyxuIuh7BpOz3DLGAjCr2459iVndBHa+iRgk1+h9EoQ+uF4AcsfHV1YQWTiTeMFp5/Epgb3mtLil/B79DE7j53iRIL/tcqGKkXH/khouokx68dSSpHc/CTUkRcqH8Kdr/FdqNl2ZDAKe5Yu9lOOwR+l84UjXXO/Pn6MZhktNBiPtzZWcQsQ+ZyLkwe4gc5AsrhMpWMl/VFOCsJPNqNFq/e5YCWXMfc4Z1tdR7t503DBKR7MsFINEwjZ4BIOtxXXqH4qq32Dr6pdmPY4e7Ht4/HCud9055HZwKJTb2W4FtkNE/y4vcv3MGOEginuR0P7+dC7n4fXjQaSw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

These test whether the VMA has stack semantics, i.e. is able to grow
upwards or downwards depending on the architecture.

In order to account for arches which do not support upward-growing stacks,
introduce VMA_GROWSUP whose definition depends on the architecture
supporting it, and use vma_flags_test_single_mask() in vma_flags_can_grow()
to account for this.

No functional change intended.

Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 include/linux/mm.h | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 32bb723ffbb9..7a7f559b3df0 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -474,6 +474,7 @@ enum {
 #define VM_SAO		INIT_VM_FLAG(SAO)
 #elif defined(CONFIG_PARISC)
 #define VM_GROWSUP	INIT_VM_FLAG(GROWSUP)
+#define VMA_GROWSUP	mk_vma_flags(VMA_GROWSUP_BIT)
 #elif defined(CONFIG_SPARC64)
 #define VM_SPARC_ADI	INIT_VM_FLAG(SPARC_ADI)
 #define VM_ARCH_CLEAR	INIT_VM_FLAG(ARCH_CLEAR)
@@ -485,6 +486,7 @@ enum {
 #endif
 #ifndef VM_GROWSUP
 #define VM_GROWSUP	VM_NONE
+#define VMA_GROWSUP	EMPTY_VMA_FLAGS
 #endif
 #ifdef CONFIG_ARM64_MTE
 #define VM_MTE		INIT_VM_FLAG(MTE)
@@ -1578,11 +1580,24 @@ static inline bool vma_is_initial_stack(const struct vm_area_struct *vma)
 		vma->vm_end >= vma->vm_mm->start_stack;
 }
 
-static inline bool vma_is_temporary_stack(const struct vm_area_struct *vma)
+static inline bool vma_flags_can_grow(const vma_flags_t *flags)
 {
-	int maybe_stack = vma->vm_flags & (VM_GROWSDOWN | VM_GROWSUP);
+	if (vma_flags_test_single_mask(flags, VMA_GROWSUP))
+		return true;
+	if (vma_flags_test(flags, VMA_GROWSDOWN_BIT))
+		return true;
+
+	return false;
+}
 
-	if (!maybe_stack)
+static inline bool vma_can_grow(const struct vm_area_struct *vma)
+{
+	return vma_flags_can_grow(&vma->flags);
+}
+
+static inline bool vma_is_temporary_stack(const struct vm_area_struct *vma)
+{
+	if (!vma_can_grow(vma))
 		return false;
 
 	if ((vma->vm_flags & VM_STACK_INCOMPLETE_SETUP) ==

-- 
2.55.0


