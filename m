Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E99C5C44501
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 18:47:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 023936B00A0; Sat, 11 Jul 2026 14:47:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEFD76B009B; Sat, 11 Jul 2026 14:47:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB8146B00A0; Sat, 11 Jul 2026 14:47:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ACF7B6B0096
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 14:47:51 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 57D6F1C4029
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 18:47:51 +0000 (UTC)
X-FDA: 84977379942.13.8F22BB6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0C0DBC0003;
	Sat, 11 Jul 2026 18:47:48 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cWfdCojd;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783795669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mLC9P7bLR/Uoa69VZ1d0HzztKwzCdHVcxkdSF4M05FQ=;
	b=duWBAnjednLk/uZvUjTyFK/K5TGqCo2KqHUJndqRFpjEPiK+2wn2a4W2wD8Ih7fAJHu4o3
	UU3Samvn5xSKLHB4dRZ/TccVSJYE2ICF7qZ2ItjCE2UAnha7EdOSk18nfcUmlrP/UnXB9r
	EdD/0+/mUV2SUi6vjFg2RdjDY6vVZGk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cWfdCojd;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783795669;
	b=NIErYmvzD7Jliov0DPcPJQxIx/KnamIRYdqRo75O4zhezRNzFamIvMHTO/BSW4p5OGcYwy
	SaWZXefN23zo1hvivy7UPbIk+Np3gy5SG8swlv61cl1bEe6tQzy2KT0JGG/wXlIlB0pd9t
	TK7c+duoPEsg4G95b3NtauE57+kd/GI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3AAE7436AC;
	Sat, 11 Jul 2026 18:47:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF4801F000E9;
	Sat, 11 Jul 2026 18:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783795668;
	bh=mLC9P7bLR/Uoa69VZ1d0HzztKwzCdHVcxkdSF4M05FQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=cWfdCojd9BEVdJixJem5fW1yN2WMCBSqX49JBrY8VEVdZfJU2N7N3Nxjti2dd1PAY
	 jHUCK8DxeZrKYnvyB+RT9x7Cp2M5SoYFjZcIsDmFeaH1lqF767UeNHIIBPY+Sng5Fp
	 MK+9v3J7Qa9RSE25T4WS2oSi8fTCtKzWW6Odi2CaiQPPbEjTa8vRRaWJWdUuMUts4O
	 cA9jeJjD4VBwS0DTGUMhgeHN9UmX28wOStoae3Af6e7oQlz0+Dgt1jAYXhFRrvXj3V
	 aDj9iQonQd8MmaaAgMBdzyflHOa0sh1Ocs8CIFYwiYPnS5VCh7VghyS+RJDWLO0kSW
	 ijUTjw6rx6hTw==
From: Lorenzo Stoakes <ljs@kernel.org>
Date: Sat, 11 Jul 2026 19:45:03 +0100
Subject: [PATCH v2 06/13] mm/vma: convert vm_pgprot_modify() to use
 vma_flags_t and rename
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260711-b4-vma-flags-mm-v2-6-0fa2357d5431@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4379; i=ljs@kernel.org;
 h=from:subject:message-id; bh=zyqVv3UzBLKq1hjuUUCPSl3cGoER1z2LvGWjiRKvzK0=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKC+i1XKLHOjEnRP75gpcyaV01nzvXnrX6+LO73lGlC/
 +aJsv8/0VHKwiDGxSArpsjy/Iv4/iCRsHmdF/zdYOawMoEMYeDiFICJBNoyMuzw9q5WXt7gt/vl
 TK3NR7uCs2/mFnmo127Y8Mp28h/pyrmMDPe0ts0S3/2Ix3jO9zPB+xdkc/g3qqdk5hRZZBpk9Qb
 58QMA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0C0DBC0003
X-Stat-Signature: egzdmxwbpurza97fkryehj339wmwj6sr
X-HE-Tag: 1783795668-595363
X-HE-Meta: U2FsdGVkX19ZRVmuaVFw6KalctFnrW9UfWn2Qv6PvkVz6QayWyFVzZk9PuwWasJVEOxO9PZvEHbw/S/yAyEUAZj2NTRWwTFoXwGaKy3IFnwtshD0d9ysIFxd/pg4Z6CepSlHNyK5PEw02K8uEkLpWWY449oZueYpEg/waSA26ITGiHK0fvBkcGvMJADUwFFspt6V8Ce0Ujt0BgyaZ7ACmQME04rahwiilJpOdEU71PlH/RwNAZnmpTvyWSQdPWN2EARJDKI0Vrtf1plX6WI9j3Ficawd8iEj6Vez1TPrPIUw450EnxCjs/ZIyWZ99TtXKlgGNglGnLOTfsftKvuQEbFMg47i3YSlk9Rnk2zqIqT/ygYECyq9t/49jALcMxXA++OihvsS5+j1iSYxWes+zBUMnAl630N+nD3OVFhf71oDntDFuRfuiV8oxcchSjAKfTDwL9EZG7Damb/xvLEgwUPZlGs6FDjmqFh5a1LB2VMvM912/12+O8bTygeixs8jngcBDTACS7INJSH9xxQSBxk42eR63rJRepdk+7ZqbPWwLM23Redx3l3OrNaUe9+XIuyb7ebAJUmwnLm6j/nrvuPROgFn8otVyY72lOu9YZdcQ6HFvTCejjWLoOIvV0lMYzxvMfx2SvGEDB/uGcKGwwPxOaHTbZPkBjH31LE9nVqR6yxf1jJZURy7eaadIShM2IrMuz5IKrt+DBn8RaJufQc3mfs2FtpA3e5FozbyUgmVlt35yAAd70Glbfu7aL5nLCXEiT170WwZp3WmoHmnQyZOojMoUfQF7SMrlJGnxluLYr6dEi7qsPH1qiMRjQUnrPGtsoGPac0UA6FJuwL5sNXWmbKmBSz8ACcN7dtN0iFPdeWHsBk1HdbiCpLE2zoNMt0GR0pnC+MDKRwQnVpn+1pNn7iLuo5JJwKQrbOSJb00ZXIA0FlhPIH1Qs5QYucYp+eR84QCloUGBQZDH8E
 j9dH/vTM
 pLtcDHHkiEZG5uuKsJkeupbpkpT5cLlr/r9O8vK0jdllIxnuQIOUTPuAmWujGMWeucTYg8TMHWHCHXvqEZxDLfz0QktQ5NTE/EDIHbChPFQIMHXQ2KMM4ezEE6E89xPm1th3H0ZylcOkElCind/JrE4F3mSO5MqSk0wGJeAh4RQhEoj2a+uDI3Wi9C6N+uFTq7S8Ljzo3jUnv4AHsrUoj9BscywT6ET7kMeRE8mXI9vzB0PF7PtbR59xbjYq1Y3oHv4gsqIAEJltv/laHzediCMib1ukyU0HAkCgiV1cfhIrPK/Y1HR4aiyj7WlpEno6aPNMkbdPE5bph2NPwUXapIdCZSugypA4/wne6Kz0O/PB31fM+aj3aQgq3C/Xk8+DP5i+JvOPccqaAVZwinVtKWIOoKAwasY8NiXPcL8K41yhVcjs9yqrhroYQag==
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

Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 mm/mmap.c                       |  8 ++++----
 mm/vma.c                        |  2 +-
 mm/vma.h                        |  6 ++++--
 tools/testing/vma/include/dup.h | 12 +++++-------
 4 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index ae9a5018e20e..2076c70e7700 100644
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
index 1f443d979a7d..a74a0e467c63 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2176,7 +2176,7 @@ bool vma_wants_writenotify(struct vm_area_struct *vma, pgprot_t vm_page_prot)
 	/* The open routine did something to the protections that pgprot_modify
 	 * won't preserve? */
 	if (pgprot_val(vm_page_prot) !=
-	    pgprot_val(vm_pgprot_modify(vm_page_prot, vma->vm_flags)))
+	    pgprot_val(vma_pgprot_modify(vm_page_prot, vma->flags)))
 		return false;
 
 	/*
diff --git a/mm/vma.h b/mm/vma.h
index 4eb85b4a6adc..8ca6e7e8ae28 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -541,9 +541,11 @@ static inline bool vma_wants_manual_pte_write_upgrade(struct vm_area_struct *vma
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
index 773e23303e26..24955a1e318a 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -1424,20 +1424,18 @@ struct vm_area_struct *vma_iter_next_range(struct vma_iterator *vmi)
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
2.55.0


