Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE414C44506
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 18:49:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DBA86B00AE; Sat, 11 Jul 2026 14:49:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88BE86B00B1; Sat, 11 Jul 2026 14:49:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72C216B00AE; Sat, 11 Jul 2026 14:49:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 318776B00AF
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 14:49:57 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AD13E40785
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 18:49:56 +0000 (UTC)
X-FDA: 84977385192.26.42672EC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7922840007;
	Sat, 11 Jul 2026 18:49:54 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KCh2Wp49;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783795794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fr9+W5ioGfovNH8dryM/kzP+up/ElY+Oy2uwfNl+UZQ=;
	b=YZGZY14/7e+dCYNFTAeaU3+48zC0Lym23D68+CUquz1+fbvYGBAS787ymUWqyCURrSeAgo
	NF9Ki+MhzInDHxJZmamuuKJ5gO0+b5ijp5brBcSBHWQMzhqqIjf6JCL6tXrqqN+gXRMKOp
	l6oqgRGz5/yN62LWDNaITLQv/qZGaq0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KCh2Wp49;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783795794;
	b=ytPK9H9xjeAMmqBJBrPbEaq75qPrrPtkn8o24Kk6+YB90S87PKHiFpAdwxzX5tokUSLFgS
	opPfgRcJ/Xle2TvpbCLcsCQ/vzaxXA7X0VEA0hrddhnOrlTvy9cApVNIF9mBWTigoijBur
	A4LMZxNZ70dsJc9XyCeRW6fdPnzTQOk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EB32D60052;
	Sat, 11 Jul 2026 18:49:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EE8B1F000E9;
	Sat, 11 Jul 2026 18:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783795793;
	bh=Fr9+W5ioGfovNH8dryM/kzP+up/ElY+Oy2uwfNl+UZQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=KCh2Wp49fergCiFPuJT2qu+NLRDa7tcNsKE68tr0X57/gxQeoxFEQALVKzPPGCBCs
	 1S2aNlk++tT/2vIRKjYUsq8gWVO5hc3Pv8Wj7ehGz3ecvbnsQJtpGf+Z3pEmCQ5Zpb
	 0G4kl6AsVgK7NukwvKxLJBKVBgW4cGFGkyDpvnIWMOL+cqs+XQ3maPfs9w3a7IE778
	 VHeldKO9fd0SwC8Wj8f7RSPZ4Jk+y+nxR+cKOZdHbk7BShTL6YF9RcqJ6dbx/Ra7Fm
	 TE7Z2bwnikCj/QtjUnOZ8uMRw3s/GTnG9x5fnIpGmsCUudhHKyJXYAWkomP4MG/RhR
	 DQejuUUlKg3zw==
From: Lorenzo Stoakes <ljs@kernel.org>
Date: Sat, 11 Jul 2026 19:45:09 +0100
Subject: [PATCH v2 12/13] mm/mprotect: convert mprotect code to use
 vma_flags_t
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260711-b4-vma-flags-mm-v2-12-0fa2357d5431@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2996; i=ljs@kernel.org;
 h=from:subject:message-id; bh=srWqnQOI/gzNhpzulQ661PMe2/Xdt3Viy9gVjyuNxVs=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKC+q08lh17/Pn9DO6GppTAjP7Fs7Y758nqdTXNm/9By
 2P20jvmHaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZjIo6cM/6OUTKz3VR0/Kd/z
 9N+FX84lasa5MY7rRCqXPVqaO+Hv4qeMDLfOLP6RuO0wS2eR6YK62aGFcS/ctwjs0Qu2mW4r7s7
 Dww8A
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7922840007
X-Stat-Signature: duzwk1ktnbjm7omyhj9oparduozwfded
X-HE-Tag: 1783795794-919478
X-HE-Meta: U2FsdGVkX1/oV6zN1MGNdrS7fqzD7CHVWAOw3QfuG0fC6NEqQQPEoU4HSeRj2XZsYNVnaw6/EXCLeXQsW4vSR2jQqGJiEVLsxQ1JnXLeG2TH1O9UhQR/jLXM1ZNwwlS9/gGbF5eaUSggCJTX9nFoGL6lKeK9KWrG1SbAONYRmEzaBKrgLPEeBL7TFAcwi77aoeGr2Qc8V2+muk2fDkGHha3xZECJg0YZ1Ym2DqkjtR+6ZK14YHUUVOqr9d7fmcj1FnZD4+CT51beAD4TDzccdAvZEavbubWnzTn6qVr5Vrtdryx10AIJHLgPlKe7Yl+09+cXM76Fq3db3cc5bKuuDVxTNSKBMC/e5rF1Hj57RpJAfKn2p8YTlr49prQh/8Hg1EW110DBMFBd31x02E80wKnlmZMuDpJcH20ucRqkVHSzYjsAW+3ThWO6yNMbT0SR4UPx/LPlR2X9oL5F7p2I7fLHmkqLkWRj5bB2sms0bis+TKT5tHeXEW9H6KvvLHh/y78ppfq/8NgFrfMYK1so9NYlCK/g7MTsXz0FYUt49ZgADlVYcNO3Hy6eD7QFPPpVsXZu9QLAPMXJizI29cgDasX7SjGjdZ2kbZRcrlolFlcTaZSwowT6ScBUQjNZ+NN9C0kGz4e2pPKXnNeAUhK7ohlFJwyyLQnxAr4gUYUkn+Lpr/pmM/DaN0I9zlK0tCT90DGQ6oxIwgEYH2SmerPytJ7+mzyg5+cOzG7gv4FlCSYGNF7PuZFMq94bvuwYxWbsYZUttlFW7lfRHLgcTIa9q+B1RBZqCSiW+CJoYBXswOH3owbajU2TLaPzyfArK6ZBBZ5hOeaoHADBBwCcAACCx4iXW/J0qMHEvAhms4CPEtlYUbE3rlwDp2yYE0Rs5Ca6fgTseX9iMttzHkVNKNQ3QtbjBqOmpAn4+0ZENsTwHmnon/hgFuhk2t8pAQALgyWREDa7L2I05YFZMjDgDip
 b1s7PNv5
 m++h3WCWbx/L6lgOin8+2YLl6TG4A7M1PZrgSJzGlXRFr15o0V2bAcZV6mskOn1OqLUli7gTKF3vpdp3eP6WapFrlIxG85eP1LsCaEjdA0oo71U9CHmeiaj8lECWrcckDDgSjs0xXYjLL7X06pEHK21ipF3Qk7TauZP0dyIfnTF/W4PfrVw79yEjTiiIKcTrrkvGDY3FhOCZDLUanSz4ALyYPgi9WuSMIFgPTK/PibwfAtSY9tNrwd7PkPc41TP/vnLsO1ojZSZdoHYTAlGduKujlzGl0FOOyxat1O1lvTyOTkHMkARR5AaacWZKeX6skeUlTtJTH6HXil7v8c2zqWaZZedn/kOQYhAUGT/eJkPUUdPqGVYIkgT38RxfarU5OILTFRhNLS39EcT0ovIB6sUOmDVHHXF+U//vIJ6Hr8FnhD3AyyGDS6M9fVdFrIJ98nZfNVzxvZU3BQRB9bgI7gHxPFn048H3Nl2nke1xw9+wq5nPUk8A01xg0QNJIJ9+Mcsc7YyuF2min+e8yvzBqg0E1GQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace use of the legacy vm_flags_t flags with vma_flags_t values
throughout the mprotect logic.

Note that we retain the legacy vm_flags_t bit shifting code in
do_mprotect_pkey(), deferring a vma_flags_t approach to this for the time
being.

Additionally update comments to reflect the changes to be consistent.

No functional change intended.

Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 mm/mprotect.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/mm/mprotect.c b/mm/mprotect.c
index dc27bbc1712f..2888ee638d87 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -40,7 +40,7 @@
 
 static bool maybe_change_pte_writable(struct vm_area_struct *vma, pte_t pte)
 {
-	if (WARN_ON_ONCE(!(vma->vm_flags & VM_WRITE)))
+	if (WARN_ON_ONCE(!vma_test(vma, VMA_WRITE_BIT)))
 		return false;
 
 	/* Don't touch entries that are not even readable. */
@@ -97,7 +97,7 @@ static bool can_change_shared_pte_writable(struct vm_area_struct *vma,
 bool can_change_pte_writable(struct vm_area_struct *vma, unsigned long addr,
 			     pte_t pte)
 {
-	if (!(vma->vm_flags & VM_SHARED))
+	if (!vma_test(vma, VMA_SHARED_BIT))
 		return can_change_private_pte_writable(vma, addr, pte);
 
 	return can_change_shared_pte_writable(vma, pte);
@@ -194,7 +194,7 @@ static __always_inline void set_write_prot_commit_flush_ptes(struct vm_area_stru
 {
 	bool set_write;
 
-	if (vma->vm_flags & VM_SHARED) {
+	if (vma_test(vma, VMA_SHARED_BIT)) {
 		set_write = can_change_shared_pte_writable(vma, ptent);
 		prot_commit_flush_ptes(vma, addr, ptep, oldpte, ptent, nr_ptes,
 				       /* idx = */ 0, set_write, tlb);
@@ -846,8 +846,8 @@ mprotect_fixup(struct vma_iterator *vmi, struct mmu_gather *tlb,
 		vm_unacct_memory(nrpages);
 
 	/*
-	 * Private VM_LOCKED VMA becoming writable: trigger COW to avoid major
-	 * fault on access.
+	 * Private VMA_LOCKED_BIT VMA becoming writable: trigger COW to avoid
+	 * major fault on access.
 	 */
 	if (vma_flags_test(&new_vma_flags, VMA_WRITE_BIT) &&
 	    vma_flags_test(&old_vma_flags, VMA_LOCKED_BIT) &&
@@ -921,7 +921,7 @@ static int do_mprotect_pkey(unsigned long start, size_t len,
 			goto out;
 		start = vma->vm_start;
 		error = -EINVAL;
-		if (!(vma->vm_flags & VM_GROWSDOWN))
+		if (!vma_test(vma, VMA_GROWSDOWN_BIT))
 			goto out;
 	} else {
 		if (vma->vm_start > start)
@@ -929,7 +929,7 @@ static int do_mprotect_pkey(unsigned long start, size_t len,
 		if (unlikely(grows & PROT_GROWSUP)) {
 			end = vma->vm_end;
 			error = -EINVAL;
-			if (!(vma->vm_flags & VM_GROWSUP))
+			if (!vma_test_single_mask(vma, VMA_GROWSUP))
 				goto out;
 		}
 	}
@@ -953,7 +953,7 @@ static int do_mprotect_pkey(unsigned long start, size_t len,
 		}
 
 		/* Does the application expect PROT_READ to imply PROT_EXEC */
-		if (rier && (vma->vm_flags & VM_MAYEXEC))
+		if (rier && vma_test(vma, VMA_MAYEXEC_BIT))
 			prot |= PROT_EXEC;
 
 		/*

-- 
2.55.0


