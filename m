Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81F0FC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 19:26:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D82D6B00F1; Mon, 29 Jun 2026 15:26:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3618A6B00EB; Mon, 29 Jun 2026 15:26:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DB216B00F0; Mon, 29 Jun 2026 15:26:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CAD956B00EB
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 15:26:02 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3F48414026A
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 19:26:02 +0000 (UTC)
X-FDA: 84933930564.13.6F76CE6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0F5BE4000B;
	Mon, 29 Jun 2026 19:25:59 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a5KeyFTe;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782761160;
	b=z1sWfaN7i2pqFEywGx/7Drx0RLubTjh7jMajhvGfu2HZVLlJFsTtTLpLGlM4o4G7G9L+SB
	jwOFUcgrDyHGk9Gkd9VZcpqC07i5PGNkb8vQ1DaKhMgLzWVwyh5uSQpz04QjQ03BDnPSho
	5LXm1NMezNikzH+dGN76TI9ovInfKIE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782761160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RyicGxsSOzJTaoBcRQGH27oUytYBKCYLUF6jDOpzH7I=;
	b=3fXCEWvUsNqOYEOkpuOWE7158WUt5mDvZ9ke6Jh4Mc0P4N3jAeJ9A++2J4k9SbS4gOeLnC
	Xvs7ZTuYg4ymLTz3dNAbkpjgtVnFsMUnNLgNDtEvy+4AjTDFhqBZ73Wh3K5eSOYNmx5aBs
	tOaDgQAVowOHNPjGuiUF+z82R6neOLo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a5KeyFTe;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7F8DE600AA;
	Mon, 29 Jun 2026 19:25:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 564721F000E9;
	Mon, 29 Jun 2026 19:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782761159;
	bh=RyicGxsSOzJTaoBcRQGH27oUytYBKCYLUF6jDOpzH7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a5KeyFTeJjh7TJORUpSdmde4WrAK8BTgTPTho1LlZNtgrXh/Yqn9mD6/L1E9zfs8r
	 e8za/mcjsoGeYfC+55PxZM0hLi0ZRJB+0Gbcm0U2F6Fn97SZIJM1N8XKGpsR2xQKrI
	 yYMjTnXxd/YQ9zzdgYLIPjHCFJPa2KKvIAraY8mhyi19FlYp5ghqePfdzpdkTUseC1
	 had3a1qZv4Z9B8qbb5LsCMcPsRJ2m5HWJRYLpaEMWR5rYHXsAk6QucmLYIa0UzO6lQ
	 Pqa24H5c5iEEZidrzYUke9zV+idmE8KbclhOGbVFF/6WTC2VNdnFmcT1ViYuCVE/mn
	 cARBGEsTONhTA==
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
Subject: [PATCH 01/13] mm: introduce vma_flags_can_grow() and vma_can_grow()
Date: Mon, 29 Jun 2026 20:25:24 +0100
Message-ID: <f2e8c32515d328db62279cc8bab8398ea278d74f.1782760670.git.ljs@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1782760670.git.ljs@kernel.org>
References: <cover.1782760670.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bqegzoisfxamb7uk8mrw78hszthjfebz
X-Rspam-User: 
X-Rspamd-Queue-Id: 0F5BE4000B
X-Rspamd-Server: rspam02
X-HE-Tag: 1782761159-854391
X-HE-Meta: U2FsdGVkX1+0hwh2AwnpnAoteTBT8T9+LKmh10wBdWXpdS+yl6ERivD2kRKrhl7dootxOGhdGZbqUjdd+ewxqwqlzL4Mxo5z4OKr6YRs8MaCCHprteSs0yl//bUjxF6uCk1uV2PqBnhtEn1n+FxCEixsb/PxvDiawMq+szcObXm5GbQoOKma8FqKAZixUkpJ0Ioa0sMoQJ/VGSrZ01rXFd+icYFkH2ql5BJWZGwAd4u7WrsN6wF/43z7MVbuvAIncxe4ALs82gGG7d03ckboVdHV9mx1U29QCeeXuM5jPCZuIYRZKQNC0oeEnBAZpv4z4YeR82FRu+i6LlWzKWEv29xQwpPOCCFoK0T3gcvvX5/V+mSmEa4kST0cnvDfwNK4VOpISNM+nkDXXGsk6QYTM/PvDTZ2zlE6mIqOVTg+ROuX+zpzIR/1L8APyIhFTBsjyFe3w0zv6iJgYLX61t+pTdq2wAmd7Lmk/J/g7KsL0JC/wFdp9qUxktgIGlkcNeL2zwsloFC13I0bHtyOZLIdsfZJCUQMFtnj1R6suP/N0RSB9RiTxA1fLLDKHDg7vvwpuljDZcBzradoVEQa+7JGS11ku/iFxAW/y3RRvzvDJQQrcqclHUhXIcBklqfPr81gXPOHmbi9vt0TKvSZCCZ5OrUSEtfbrgbIjXVmrvrIKxX8CpdX+Q+UYqvSCco8F/M3oc+o6iEeRgw/yP4aTS14cA5LHWEBGx3K9kpANcoH+5ejiiDXznANS95TCKblJT6VUFaP6X+z+7+mQ5KwInW2Z9mGA0ckxt2KQ1Li4/u55Yeq2v0bU2LJvWaak+dTGVDH1ts68OiedU+qYbQFtk+qbmIr+3Br/c3rddM/SagbPx02oPhMnv/GYt0TGetqATtpryvR6V+G8kTJRe7WnKf6R8UlaHg6+R4DXiuVy8WS+U9M9++aVrk6Ajg5GInIc45k1iCoMI+j6CG9Wo/RccZ
 pv5kCVsP
 N3uS+FkTz1EQF9ciSEV9ldWHyNYJh3plQ4tn9Hr4KmiD90W97QIrSKEMlRblG09htXYEprJfH7887KyeMojvSEQgpQw9SoOtm8sT9wg9BHLU1RFkzaU1iuLivSliKD8SZ7K+fl2z8BpTgzi/Lhln4Vu+AGHvR8qA8gMUT1+On7dKkmlqcoaPNiHSa5+b9RSY1ImxlRNp1WdfeleDUpZu/IAm+FvevZaErlAgFOV7uFhYWaK7kio6VDFG+QwPQlkGALqMiUYnsBSKdWz2i8PK0QqyoMA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

These test whether the VMA has stack sematics, i.e. is able to grow upwards
or downwards depending on the architecture.

In order to account for arches which do not support upward-growing stacks,
introduce VMA_GROWSUP whose definition depends on the architecture
supporting it, and use vma_flags_test_single_mask() in vma_flags_can_grow()
to account for this.

Update the VMA userland tests to reflect the changes

No functional change intended.

Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 include/linux/mm.h              | 21 ++++++++++++++++++---
 tools/testing/vma/include/dup.h |  4 ++++
 2 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 868b2334bff3..cf7df1569052 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -472,6 +472,7 @@ enum {
 #define VM_SAO		INIT_VM_FLAG(SAO)
 #elif defined(CONFIG_PARISC)
 #define VM_GROWSUP	INIT_VM_FLAG(GROWSUP)
+#define VMA_GROWSUP	mk_vma_flags(VMA_GROWSUP_BIT)
 #elif defined(CONFIG_SPARC64)
 #define VM_SPARC_ADI	INIT_VM_FLAG(SPARC_ADI)
 #define VM_ARCH_CLEAR	INIT_VM_FLAG(ARCH_CLEAR)
@@ -483,6 +484,7 @@ enum {
 #endif
 #ifndef VM_GROWSUP
 #define VM_GROWSUP	VM_NONE
+#define VMA_GROWSUP	EMPTY_VMA_FLAGS
 #endif
 #ifdef CONFIG_ARM64_MTE
 #define VM_MTE		INIT_VM_FLAG(MTE)
@@ -1563,11 +1565,24 @@ static inline bool vma_is_initial_stack(const struct vm_area_struct *vma)
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
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 5d7d0afd7765..6f5bcd7fbcd8 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -245,8 +245,10 @@ enum {
 #define VM_STACK	INIT_VM_FLAG(STACK)
 #ifdef CONFIG_STACK_GROWS_UP
 #define VM_STACK_EARLY	INIT_VM_FLAG(STACK_EARLY)
+#define VMA_STACK_EARLY mk_vma_flags(VMA_STACK_EARLY_BIT)
 #else
 #define VM_STACK_EARLY	VM_NONE
+#define VMA_STACK_EARLY EMPTY_VMA_FLAGS
 #endif
 #ifdef CONFIG_ARCH_HAS_PKEYS
 #define VM_PKEY_SHIFT ((__force int)VMA_HIGH_ARCH_0_BIT)
@@ -315,6 +317,8 @@ enum {
 
 /* Bits set in the VMA until the stack is in its final location */
 #define VM_STACK_INCOMPLETE_SETUP (VM_RAND_READ | VM_SEQ_READ | VM_STACK_EARLY)
+#define VMA_STACK_INCOMPLETE_SETUP append_vma_flags(		\
+	VMA_STACK_EARLY, VMA_RAND_READ_BIT, VMA_SEQ_READ_BIT)
 
 #define TASK_EXEC_BIT ((current->personality & READ_IMPLIES_EXEC) ? \
 		       VM_EXEC_BIT : VM_READ_BIT)
-- 
2.54.0


