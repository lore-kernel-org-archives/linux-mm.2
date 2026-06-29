Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 131B3C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 19:26:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D1BA6B0109; Mon, 29 Jun 2026 15:26:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 780536B010D; Mon, 29 Jun 2026 15:26:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D2A06B010A; Mon, 29 Jun 2026 15:26:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 210926B0109
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 15:26:17 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9C747C15AD
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 19:26:16 +0000 (UTC)
X-FDA: 84933931152.27.34391C2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7F8EC40007;
	Mon, 29 Jun 2026 19:26:14 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F+1lY+lC;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782761174;
	b=3qpgJb9Z3enAO9HvCNda31wjw0OA4oNygtbke5Gm6uartNQAUbZ+UEi/DsTvjC6wRRQ66p
	gqQOLLP6PSpwWfRj/vj++Wmhbg53MfQKcPGE/FnCJWYXQ7dCfG2STp1lAGsy/neg7L5VoK
	dMWoWrB/lyl3U5hDhA02detRxmGKbgU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782761174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gKmo4U1gXLGtJnRP+WhnxnFRqzwXuOB5h6v9uTSdV1s=;
	b=uia+bVk9d9ALQ1jm5i5ppNUb/VSc7Vipp2RkNhFh5ta1HbXTISh4ApSXp3qbUcWUxHlNL+
	nJj4q3VvmPIB2jSrQ89FR78Iggloa9DiOVFlAP4D87nxVe0s0mcvRL/B/21JJsa98usURl
	DLNccfxCn5F0dMn19A9fO5Evcj/rYUU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F+1lY+lC;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 081F7600C8;
	Mon, 29 Jun 2026 19:26:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2FCC1F00A3D;
	Mon, 29 Jun 2026 19:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782761173;
	bh=gKmo4U1gXLGtJnRP+WhnxnFRqzwXuOB5h6v9uTSdV1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F+1lY+lCh4/ljg4cAF+WiIYMH69AbV51hkuC1jZywIIRJtnSTTT9Cl417kLqBvIL2
	 8OgnOg+47T8fRg2he/k0Czan1lawmcrV1QOn8ALLq/c2Ln2nuZw+lUVlp9IBNBM7O9
	 ULuAgYhvU87+ozqV7cC/Uv3vF3QGLRPm547HTvpe+ig3eiPKismCLxZqLocHJJSRPE
	 ub2TJPIrtzztEsLj+o6x6PxyaZ56GCtceA3IiAP5fOpSWc8Uo+I5/jmojutM8causc
	 cQ+/HDIGoeC5yU7JzcyMSeGb6xZ0mYXeADHJM+UmSIQ/cxJ8RXeP+AGDV1OS3TxIGG
	 sMbSC7d+ndHmA==
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
Subject: [PATCH 06/13] mm/vma: convert vm_pgprot_modify() to use vma_flags_t and rename
Date: Mon, 29 Jun 2026 20:25:29 +0100
Message-ID: <548ba81b2971734d4d2143237ad1465bd1b2f525.1782760670.git.ljs@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1782760670.git.ljs@kernel.org>
References: <cover.1782760670.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wes1ay19q3r474dea6gk9qnidwn9p8fn
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7F8EC40007
X-HE-Tag: 1782761174-126339
X-HE-Meta: U2FsdGVkX1/SEPrMiaGp0Sa7AQl3kyHZTd2/fEwWdSakRRSSFLJ6DmO0L57qEZke1ACnQrU4IwCYk/McKf5RvSxAD5/b3IrLqPrwCcz6GHqBiMp1NqYMCPo1C2DFyiQrsmUesI8c0288HAlRM8aDkOBHkHYCmn4mgZi3wJOX93gLL/rxRBjOLm1RrsOT1Lud+cHiCGyqCRXqP2a9JHkvfgFD9SC6mk8gz30QhBT40FAWU+HcumVhweXInrAfLquejPAKUDKH38g/5ODpkNzDug3RCxfJYQv4pXZ+Xn/aLH82sMiNn/owTtsE5+17UFA0PMY97B/eDYwD3ZLSQhb/OrNkddUdZIRzdTJ9fyjX06AHurGwDk4a7jIqL9CAW3fpbH25VOLIBsrPdaw+IVmlWdlNsPf/+YLagOu5tUM2GM3QVECAIn9vuA50ejJSqi+39QQJ7lsA7xBXh947QPjPQFIrqypcPi7jIahs4ZaHENVcyMfL5CoGTMrNoEc0AhXMvjvTNE6GHleluSMVV3Z1MdLEOYKPwy9Vg9xAN1etnFu0zuNv+Bz1pI8pmrJKb0OHIgFa3uDV13vgz7jDiiyh7ga7w7Kl2tI9k+QiXuSxWb1ERPpjTrUfJcc0EqTOCmVP8q25AjV6reWEEzQpR0Fn2Vva7C8OibUpKdi409YuMVK9uLK54O/ABF+pLZH0WKIyUyYCj8E3lbk1R8Vn3nH3iUvAlS1HEBmw5RF7Mbg4+wGkMnTcRsZnPLvuFaiV4rhDJJ0p8fWE0Q1Q6s2+2k0Z4CSOezH5hqHsOPI32Ts8crHLnhp+PrBeebC3n+hLy9vPES//4affe3/oS0m3S0xXAmgZNBmet5dgHkMM/ISkScKRWDtPGZybGWIhV+5PkSEwG/D8dKLGpU5K1kyKOajIYdc8cvxWMSei/ihDGoZA9VOY6I7cnrY7dzIm7CfRb2b5CA/adJC0GfNzYWryVbn
 kBj9sQct
 EWAP/XGQZPlqjEh45jG8OoxqmhCqMlqvqSyHZT0wBFNnXgRFJ+yXWguiWWCuhgpLhHm+ddha5YTpycF6mi+igo7o6hi+ic7h/wZD92E/TfCit3h5EDyHDM5jOl/H8/L7OVbS4JipRutBnNChvAHDTSdip9BdgXdtd8+EXfBE0qzPRcHij1x4tpYU3aRx96bTpQawTmYUgtZcyTJ4r9vtC3nGafQND3EOWF3gNrTBclxVJAVRFQdzx+xDYxnIPmLKQHbT98c/AR6QssU2ygBBBiHfvWQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update vm_pgprot_modify() to use the new VMA flags type vma_flags_t, and
rename to vma_pgprot_modify() accordingly.

This is part of the ongoing work to convert vm_flags_t to vma_flags_t, in
order to eliminate the arbitrary limit of the number of bits in a system
word on available VMA flags.

Update VMA userland tests accordingly, updating vma_set_page_prot() to no
longer inline vma_pgprot_modify(), rather we can simply define
vma_pgprot_modify() as a static inline function and the tests will pick it
up from vma.h.

No functional change intended.

Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 mm/mmap.c                       |  8 ++++----
 mm/vma.c                        |  2 +-
 mm/vma.h                        |  6 ++++--
 tools/testing/vma/include/dup.h | 12 +++++-------
 4 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 477f4a77361a..e834ec9273e3 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -80,13 +80,13 @@ core_param(ignore_rlimit_data, ignore_rlimit_data, bool, 0644);
 /* Update vma->vm_page_prot to reflect vma->vm_flags. */
 void vma_set_page_prot(struct vm_area_struct *vma)
 {
-	vm_flags_t vm_flags = vma->vm_flags;
+	vma_flags_t vma_flags = vma->flags;
 	pgprot_t vm_page_prot;
 
-	vm_page_prot = vm_pgprot_modify(vma->vm_page_prot, vm_flags);
+	vm_page_prot = vma_pgprot_modify(vma->vm_page_prot, vma_flags);
 	if (vma_wants_writenotify(vma, vm_page_prot)) {
-		vm_flags &= ~VM_SHARED;
-		vm_page_prot = vm_pgprot_modify(vm_page_prot, vm_flags);
+		vma_flags_clear(&vma_flags, VMA_SHARED_BIT);
+		vm_page_prot = vma_pgprot_modify(vm_page_prot, vma_flags);
 	}
 	/* remove_protection_ptes reads vma->vm_page_prot without mmap_lock */
 	WRITE_ONCE(vma->vm_page_prot, vm_page_prot);
diff --git a/mm/vma.c b/mm/vma.c
index fb4341943576..395b6619ecc1 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2179,7 +2179,7 @@ bool vma_wants_writenotify(struct vm_area_struct *vma, pgprot_t vm_page_prot)
 	/* The open routine did something to the protections that pgprot_modify
 	 * won't preserve? */
 	if (pgprot_val(vm_page_prot) !=
-	    pgprot_val(vm_pgprot_modify(vm_page_prot, vma->vm_flags)))
+	    pgprot_val(vma_pgprot_modify(vm_page_prot, vma->flags)))
 		return false;
 
 	/*
diff --git a/mm/vma.h b/mm/vma.h
index bcf0c2773449..6a8abb8ae937 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -522,9 +522,11 @@ static inline bool vma_wants_manual_pte_write_upgrade(struct vm_area_struct *vma
 }
 
 #ifdef CONFIG_MMU
-static inline pgprot_t vm_pgprot_modify(pgprot_t oldprot, vm_flags_t vm_flags)
+static inline pgprot_t vma_pgprot_modify(pgprot_t oldprot, vma_flags_t vma_flags)
 {
-	return pgprot_modify(oldprot, vm_get_page_prot(vm_flags));
+	const pgprot_t prot = vma_get_page_prot(vma_flags);
+
+	return pgprot_modify(oldprot, prot);
 }
 #endif
 
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 6f5bcd7fbcd8..813044781719 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -1434,20 +1434,18 @@ struct vm_area_struct *vma_iter_next_range(struct vma_iterator *vmi)
 }
 
 bool vma_wants_writenotify(struct vm_area_struct *vma, pgprot_t vm_page_prot);
+static inline pgprot_t vma_pgprot_modify(pgprot_t oldprot, vma_flags_t vma_flags);
 
 /* Update vma->vm_page_prot to reflect vma->vm_flags. */
 static inline void vma_set_page_prot(struct vm_area_struct *vma)
 {
-	vm_flags_t vm_flags = vma->vm_flags;
+	vma_flags_t vma_flags = vma->flags;
 	pgprot_t vm_page_prot;
 
-	/* testing: we inline vm_pgprot_modify() to avoid clash with vma.h. */
-	vm_page_prot = pgprot_modify(vma->vm_page_prot, vm_get_page_prot(vm_flags));
-
+	vm_page_prot = vma_pgprot_modify(vma->vm_page_prot, vma_flags);
 	if (vma_wants_writenotify(vma, vm_page_prot)) {
-		vm_flags &= ~VM_SHARED;
-		/* testing: we inline vm_pgprot_modify() to avoid clash with vma.h. */
-		vm_page_prot = pgprot_modify(vm_page_prot, vm_get_page_prot(vm_flags));
+		vma_flags_clear(&vma_flags, VMA_SHARED_BIT);
+		vm_page_prot = vma_pgprot_modify(vm_page_prot, vma_flags);
 	}
 	/* remove_protection_ptes reads vma->vm_page_prot without mmap_lock */
 	WRITE_ONCE(vma->vm_page_prot, vm_page_prot);
-- 
2.54.0


