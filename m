Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 935C6C44506
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 19:26:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49D7C6B010F; Mon, 29 Jun 2026 15:26:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3630C6B010C; Mon, 29 Jun 2026 15:26:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 117946B010D; Mon, 29 Jun 2026 15:26:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CB4886B010D
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 15:26:19 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 475D31A0234
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 19:26:19 +0000 (UTC)
X-FDA: 84933931278.07.3AA3AF0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 42AD5180004;
	Mon, 29 Jun 2026 19:26:17 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=klEBAvxA;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782761177;
	b=yFHy9GwUnQmGfj0jq6CUOvIEo7+SCxr2NS3gjDg+vnTZHTbAKxVBUDuC5wQzP8cZUudMBM
	itBvI7McZ1bkdTefgln5O4AQUfuvjy/Fe7f04q0uRDoQjFuV3H2fJAfcsCi5Czd1gUCUN+
	czjsVdMWJ86IFnDHyt5PKd5Dp0ix4kI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782761177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kVNcj1n0t63iEIMvCjdqZpMGs73q5Ko9ggshfmmLkXE=;
	b=IGlfzTQZDMNwSzK3Ll2j03rd0bNARYnz/yxMe7zQ38vgKTHGE1q0vlMJuEWXsclZbgaTjA
	3HwWq/Uok8GrG5qJIwaSgmkgqr+ky+vy0I49rvoYp93yYoMjQBpLotGyLFMqQfKKXreLlW
	YL01p5lTIFRw8YCStjAqDdmYrmXss70=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=klEBAvxA;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D2D50601BE;
	Mon, 29 Jun 2026 19:26:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC1611F00A3A;
	Mon, 29 Jun 2026 19:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782761176;
	bh=kVNcj1n0t63iEIMvCjdqZpMGs73q5Ko9ggshfmmLkXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=klEBAvxAFllrYroNuPJLJ6gpkhIWH2gTVoT+/xDpJL5trOYXohBGpPUklmeyy3M8s
	 V8yPCwMkEt0hiRNtDQFKpdz3l1uU7duIasGbSIztboWDM2ZAqiJD0rorDwfoqGlBAa
	 LG7rxtse+7tEtmE7jUNFo/a5he8kyou91LnB1mOd3C/3gEPhWsxleGxfu6UNzRLKT4
	 q/kle54fQbZ80BilK1fYXEKilUW+HJlbq+uSEtkk9SKLXzWuUuYgjrQUH6aBSmWp7O
	 s8EEU2+Bt7ipQc2WUzag4pdln2sWzLqlewf7/vmu4r9kXvNYawRuP/0vdC2aunN5Wg
	 EWS79jrl2lb4w==
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
Subject: [PATCH 07/13] mm/vma: rename vma_get_page_prot to vma_flags_to_page_prot
Date: Mon, 29 Jun 2026 20:25:30 +0100
Message-ID: <fc8ac30d03d29d236e76542b36432bba315aca60.1782760670.git.ljs@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1782760670.git.ljs@kernel.org>
References: <cover.1782760670.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zb45swu7czyh9dpzpios41xwr7omcpgm
X-Rspam-User: 
X-Rspamd-Queue-Id: 42AD5180004
X-Rspamd-Server: rspam02
X-HE-Tag: 1782761177-847823
X-HE-Meta: U2FsdGVkX1+4YfRa6vFS3KW/T5EnI8ENwzQWoaj08z5EdZrlhpEBGia4YUljygZ0j2fDDRyYmF+IJfsuK9L+e1Ura0xqkcEkJVfqKzI7FsSEdzhsktjUKrU41nQRCzt3/b71288vgsB4nxVAdEILbseEXGpjzL0aVB1CvopJ8bEktlPYTXLJOq1aU76kQCPMkG40Jf5VFzzEwfGRMdaLNwQIfvIYp3u3WY4of36nCNA1aVEOYTqwI97N+iujbk957CirEWzMJYXXK9GJFawa2f0dPdysP8OO0Mx5RQqKB8w0sBSu8N/+eM9erVlldrdvE3HvlTcTd5gGSM1lDCrHWyykyQRpSBNCVhEL1ftjuoo1pWrTH2TLd/Y1knm3L4UnTvqLmTW32zMMgIzLGeUa2x3vI3RDBDJtgy2raIob/DwnVDb7w1yzkLYR1jJQtbDxFMSJBW+V+W+a/iR5ii1nBNEh1tlnzL/SMJZpwTuknOrLhbxtFwvHO8iUQgvWyqfDLdSMOn2Xrxm74xf10e2I6ZZmO/6TK/F+xccVqgFspbMyV97TivgETTk0dZZNBIJpEk1RHg4Bf1M7lkBHo/tzCN2M2qPUtiLg0szjXjgx7gR9TiMLI8Qrn3tm1LKN+PAaFnWFtJHMtI3AgyuC55pXPQpoHddLduZ8H266zerHqBWIIArt+lf9seLkSb5u7mpxax95x6VcuMhoZ9PvpCfP7n0oODiqgtihks1JvIfEv8peAukEr7mOA6iIYDQCFHrVsrdjMhRR1R4s09L+z78vdDOO8k4xIXZ97yEia2GWvLLizhACQHEeOY1u+LYsORR4WXM33hAS5KWD7wAXyTlcvRB3sYPqZQKdHO+vdVN6QVWg0TeVEgC5i/5VmGVEEK0Mo3QeYXY2nlxeG6ri2VwjL280UQRh3pc8TJcXmSwiq1qorAXXPuFqKxJ1jKngI1Klj3yl+mCwIy4q7K3GlyW
 LxHFzbEq
 jsnQ/TIsQlXe6FLJvE1YSGenT9j+LpUxdv5+vyRwHUyLgfx8mJRn+R5nMxCVTOP1KGPpWf/E2pohJx0Qxi9EEtmpyHSMqgugzVgCilJQTS18omSZN1zkvQdOEfN/d2y6GMvjedFcrkUPfGQQhjPirZWkwm+470fYpL9u1dGjgMazsox6c5+g83zyVVDrxaXwZLRoH2FBImKrtJduLPS/BVdHtc213b4YGFZgJ/fHoEAYxmixiHBCnSnZpYlF1K2AtYqiqKXPC7o7JSqbn/m0MsO7vBQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Having vma_get_page_prot() refer to VMA flags and vma_set_page_prot() refer
to a VMA is confusing.

Rename vma_get_page_prot() to vma_flags_to_page_prot() to resolve this
confusion.

No functional change intended.

Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 include/linux/mm.h              | 4 ++--
 mm/vma.c                        | 2 +-
 mm/vma.h                        | 2 +-
 tools/testing/vma/include/dup.h | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 474b3698f565..c8336f68d7bb 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4568,7 +4568,7 @@ static inline bool range_in_vma_desc(const struct vm_area_desc *desc,
 #ifdef CONFIG_MMU
 pgprot_t vm_get_page_prot(vm_flags_t vm_flags);
 
-static inline pgprot_t vma_get_page_prot(vma_flags_t vma_flags)
+static inline pgprot_t vma_flags_to_page_prot(vma_flags_t vma_flags)
 {
 	const vm_flags_t vm_flags = vma_flags_to_legacy(vma_flags);
 
@@ -4581,7 +4581,7 @@ static inline pgprot_t vm_get_page_prot(vm_flags_t vm_flags)
 {
 	return __pgprot(0);
 }
-static inline pgprot_t vma_get_page_prot(vma_flags_t vma_flags)
+static inline pgprot_t vma_flags_to_page_prot(vma_flags_t vma_flags)
 {
 	return __pgprot(0);
 }
diff --git a/mm/vma.c b/mm/vma.c
index 395b6619ecc1..fcdd2ac3ac68 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -56,7 +56,7 @@ struct mmap_state {
 		.pglen = PHYS_PFN(len_),				\
 		.vma_flags = vma_flags_,				\
 		.file = file_,						\
-		.page_prot = vma_get_page_prot(vma_flags_),		\
+		.page_prot = vma_flags_to_page_prot(vma_flags_),	\
 	}
 
 #define VMG_MMAP_STATE(name, map_, vma_)				\
diff --git a/mm/vma.h b/mm/vma.h
index 6a8abb8ae937..d6b48d596f44 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -524,7 +524,7 @@ static inline bool vma_wants_manual_pte_write_upgrade(struct vm_area_struct *vma
 #ifdef CONFIG_MMU
 static inline pgprot_t vma_pgprot_modify(pgprot_t oldprot, vma_flags_t vma_flags)
 {
-	const pgprot_t prot = vma_get_page_prot(vma_flags);
+	const pgprot_t prot = vma_flags_to_page_prot(vma_flags);
 
 	return pgprot_modify(oldprot, prot);
 }
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 813044781719..1ffac38a5377 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -1555,7 +1555,7 @@ static inline int get_sysctl_max_map_count(void)
 #define pgtable_supports_soft_dirty()	IS_ENABLED(CONFIG_MEM_SOFT_DIRTY)
 #endif
 
-static inline pgprot_t vma_get_page_prot(vma_flags_t vma_flags)
+static inline pgprot_t vma_flags_to_page_prot(vma_flags_t vma_flags)
 {
 	const vm_flags_t vm_flags = vma_flags_to_legacy(vma_flags);
 
-- 
2.54.0


