Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A789EC79FA0
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 17:33:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C2E86B008A; Mon,  7 Sep 2026 13:33:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 674796B008C; Mon,  7 Sep 2026 13:33:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 562226B0093; Mon,  7 Sep 2026 13:33:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2F2F56B008A
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 13:33:26 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C6FAAA41D9
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 17:33:25 +0000 (UTC)
X-FDA: 85187662770.21.2D35117
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0975C14000E
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 17:33:23 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FSB8dMCs;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788802404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=yrolGENT0USe5XNn+JkmDXEFy0r+GXBioZLVApy6mzs=;
	b=3SBoso8PYtxqtWhZtUM1mW/yB3yPxQx/k1IZz9gZGL7axkpzg9L3IKMl1c89MKp6vU3GUT
	4Gv18FrJdnXhPM2hYTFraS6XsIxF5Qc3lZBvUprY2mLc+d665a88nMVVu95rs1k7fquhdt
	wRyxzGx4zmTe8EoJOomGPssWGPmv15s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788802404;
	b=jzK0VOSwsyWB435pBDY49Xy9Ae5v9H9tzLEFpH7QY56J8kYyiHQuFHnvWcw9v39xfuvdNZ
	Y1jAkDwRAIH9nvWTSpzVzJgFNGkvFqx8v0dMpUVWtKCI5ywDzTbfVFyAot+/6tfOIzbYSU
	YkGZ0qTMXuJjQonVTnHbuHTWEH63cCw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FSB8dMCs;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 92EC2601DE;
	Mon,  7 Sep 2026 17:33:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 169781F00A3A;
	Mon,  7 Sep 2026 17:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788802403;
	bh=yrolGENT0USe5XNn+JkmDXEFy0r+GXBioZLVApy6mzs=;
	h=From:Date:Subject:To:Cc;
	b=FSB8dMCsmsGaYWSPpFiysguN/Ap562nxVy2Bo53ltfSz/PX0oLvPdNinem2ITEKaL
	 jBUs4aLDVa+eCCH64gKFzT3+/G3lvjDhQZgTfR+enAZQsN9LIJ0/zr+r3VU6x20Mvh
	 oVpwgk67cKT/3hBiLKWfdqn3M0phYLFBAvc1gO2kCxk8MweKJarGm6ISxO8qpr0e9z
	 9B4hL7Ccy95egipxuda1eDFdD79eAn0eJX/TL6ALyHU7Ac44u0AvNxEIIlrWvVHCa+
	 3UncHhyDGkyWgZicB8FJ3UGXTEv222ss6/lvdvFIH25xJ4ysY0XVOdZ51qc6gsbzcA
	 reCd5naIPLnzQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Mon, 07 Sep 2026 18:33:13 +0100
Subject: [PATCH v2] mm/huge_memory: bypass THP tuneables for huge pfnmap
 mappings
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260907-hugepfn-allowable-orders-v2-1-b89728339148@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/42NQQ6CMBBFr0Jm7RhaRAor72FYYJlCY9OSqaKG9
 O5WTuDyveS/v0EkthShKzZgWm20wWeQhwL0PPiJ0I6ZQZbyXCrZ4PycaDEeB+fCa7g5wsAjcUR
 jKlkZVRtdN5DnC5Ox7z197TPPNj4Cf/anVfzsH9FVoMD2pESrlSobrS53Yk/uGHiCPqX0Be7yW
 mHBAAAA
X-Change-ID: 20260827-hugepfn-allowable-orders-ff323f85fc57
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Peter Xu <peterx@redhat.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Cedric Le Goater <clg@redhat.com>, Saravanan D <saravanand@crusoe.ai>, 
 stable@vger.kernel.org, SJ Park <sj@kernel.org>, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=6275; i=ljs@kernel.org;
 h=from:subject:message-id; bh=EbkfQrduiBo4n56BhART5zdrKo//tuFGC85yYHYENTM=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLmfY3j47gkEcCUGts4/8mlzNPL4s5OcJq5U6/UQ3Gp5
 +Hi3zqcHaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZjI/J2MDI0GE1X1mvW7j7pM
 fM7ImDxzo8bHe+EWRVyrTdYu9p2wn4uR4a6+zyYj66B4oRvd/OfzjwvNOr560dQY77OFKWk6ifp
 83AA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0975C14000E
X-Stat-Signature: bhs1axxksggh6rbcpp6xtmr6aykywkt5
X-HE-Tag: 1788802403-44652
X-HE-Meta: U2FsdGVkX1/CAsxN77+JzBpjSBKAP88/HA82PDRCS0KWeU5lUN514qjdfEJvuZCybPfHsV1Dg+PGoWgh84NoAIWamgySk4psxpn4cRZpcv0QMZpMUIosexDw2BE3cSensWhp79sZZ/uKib6khMXEec6ZnD1jG2d2N/Zu3Ox3ZvHUi6ikJbo9Wec08tLGcFpvoq7SdRPD2ot1XLoM+JEW3cnocYsFTLpCbBS7qxh9J/haNzFYL9Xmex0cOgjm94hVKP0qk7tOJVAzliN18CiPIG4/uX3jsl39LLhOZik6TJhyqhdYCUmnKUwz1CjCQxHS2ry7fNeXmMThVQvQr5fpurgwAzzo0mPmgPHb52/6Li4iKwWYxgvz0FbLsPkLe6ftTWqWnAwAAbkhOle60SjikFTkXcJ2e5ndHjpHwJ9KcmBTZpEcjKePrgVwNlp3Dw4xsZ2PXFY9olJvohW8xTy12TczCC2q8aJKqe88TI88o4Jko7FVfz6T1vs+ZxDcZBM2yB0DatXgXW9JWSwPq34OwRTCeswZK89TUu1u7nIGkX3iZqzA9PFpl9MNCmC048WylqljKsIxHjzPesmM3JPfU3Tlm4peMA3fgcIvKm/8cgXfBbLTY2YMWFQ5/Dsgcn6ZRtfZpPBiGpifrBzRsGOiO8ck7QEhADKUVXT4zW8JMIydYP0gzRlUCVK8op+OBrc9Ek17RGgy/ApUcAE8dji3BvI8Ph4pNSyMwG7G2cOAscab3RXrtpPDpTZbqvKxWS3+b80eN31eDEt6EH9oX+ie3x06bdfAu1hvdgcILMhnEm4TnaX0wTDvjf/Hs8EP23LBF82oefD19eDjcB6/LG34pqCjPghh+KuUAfEoNzHnox6qgvodAVTCKN4lEzjqNnrdQQQaMMn/v2L30GBM+Hip+bjXDBvW5EtWdpMzpM2q1G/7K+rpqzBSVzWpPxJzlJ3d0qCh2nzxAh8jzV07IrE
 cD6j3+yE
 p2RHxIoLm7ApzBh9MoBiWzj3vSpRF+2+fnIoctXRpLI75qQzMQKkXy7YckFw9G128/ooTRQD8G5vtqKvr/LiVXYiahUag7wW0zai/0MxanvZyzvN3JLQpnKutx0aVUgXabAd3+KpG/QNzTZNvB8aUw/V6C3AbkvCh6swGDKjgVIitZxS3DLl8k8SDsd64LkgarW7vXj5FtGVEEIpOidHZD50eYosg+NTEoHNSWmMGL0PqJUHCszCbnz7fsCYODSFCzqjWYahXR+QcVEG9zm3LDkskpVblfd+cVRiWATI9+9vJ628jw+TsCtm1yvY9QH06EHnnmsA/pHljgInYCBX9PzvBcz9lpg7w1G04c4ll8/8QES4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The sysfs THP tuneables at /sys/kernel/mm/transparent_huge_pages/ rather
confusingly only control the behaviour of THP in some instances.

They are not applicable to MADV_COLLAPSE operations, nor to DAX mappings.

Long-term, THP is predicated upon compaction being able to obtain large
folios to populate THP ranges.

However, vm_normal_folio() returns NULL for PFN map mappings, thus their
reference count is maintained by the driver, not core mm.

As a consequence, the folios are not subject to reclaim nor compaction, so
are not truly part of the THP mechanism at all.

However, since commit 5dd40721f147 ("mm: allow THP orders for PFNMAPs")
introduced the ability to establish huge PFN maps, they have been subject
to THP tuneables.

This is incorrect - if a huge PFN map is available (defined by
vma->vm_ops->huge_fault being non-NULL for a VMA_PFNMAP_BIT VMA), then it
should be mapped huge upon fault-in.

Correct this by explicitly checking for this while ensuring that smaps
continues to accurately report THPeligible statistics.

While here, abstract the entire file-backed THP check in
vma_can_map_huge_file(), with sensible separation of logic into helper
functions.

Note that drm_gem_shmem_mmap() and panthor_gem_mmap() establish huge PFN
maps of shmem folios, however they are marked unevictable in
drm_gem_get_pages(), and in any case would fail the reference check in
__remove_mapping() even if they weren't.

Failing to map huge PFN maps has resulted in significant real-world
performance degradation, see links for details.

Reported-by: Cedric Le Goater <clg@redhat.com>
Closes: https://lore.kernel.org/linux-mm/20260805055544.1568534-1-clg@redhat.com/
Reported-by: Saravanan D <saravanand@crusoe.ai>
Closes: https://lore.kernel.org/linux-mm/20260821070520.25759-1-saravanand@crusoe.ai/
Fixes: 5dd40721f147 ("mm: allow THP orders for PFNMAPs")
Cc: stable@vger.kernel.org
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: SJ Park <sj@kernel.org>
Tested-by: Saravanan D <saravanand@crusoe.ai>
Tested-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
v2:
- Added tags thanks everybody!
- Updated to use vma_file_*() naming as per Zi.
- Also updated vma_can_map_huge_file() to vma_file_can_map_huge() as per
  David.

v1:
https://lore.kernel.org/r/20260827-hugepfn-allowable-orders-v1-1-94819c8807c8@kernel.org
---
 mm/huge_memory.c | 86 +++++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 64 insertions(+), 22 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index afbb5974bd22..75c204af40cb 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -92,7 +92,7 @@ unsigned long huge_anon_orders_madvise __read_mostly;
 unsigned long huge_anon_orders_inherit __read_mostly;
 static bool anon_orders_configured __initdata;
 
-static inline bool file_thp_enabled(struct vm_area_struct *vma)
+static inline bool file_thp_enabled(const struct vm_area_struct *vma)
 {
 	struct inode *inode;
 
@@ -118,6 +118,67 @@ static bool vma_is_special_huge(const struct vm_area_struct *vma)
 	return vma_test_any(vma, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT);
 }
 
+static bool vma_file_bypass_thp_tuneables(const struct vm_area_struct *vma,
+		enum tva_type type)
+{
+	const bool has_huge_fault = vma->vm_ops->huge_fault;
+
+	/* MADV_COLLAPSE ignores tuneables. */
+	if (type == TVA_FORCED_COLLAPSE)
+		return true;
+	/* Huge PFN mappings are uncompactable so the policy doesn't apply. */
+	if (vma_test(vma, VMA_PFNMAP_BIT) && has_huge_fault)
+		return true;
+	return false;
+}
+
+static bool vma_file_allow_thp_tuneables(vm_flags_t vm_flags)
+{
+	/* THP=always? */
+	if (hugepage_global_always())
+		return true;
+	/* THP=madvise and marked MADV_HUGEPAGE? */
+	if (hugepage_global_enabled() && (vm_flags & VM_HUGEPAGE))
+		return true;
+	return false;
+}
+
+static bool vma_file_check_thp_tuneables(const struct vm_area_struct *vma,
+		vm_flags_t vm_flags, enum tva_type type)
+{
+	return vma_file_bypass_thp_tuneables(vma, type) ||
+		vma_file_allow_thp_tuneables(vm_flags);
+}
+
+static bool vma_file_can_map_huge(const struct vm_area_struct *vma,
+		vm_flags_t vm_flags, enum tva_type type)
+{
+	const bool has_huge_fault = vma->vm_ops->huge_fault;
+
+	/*
+	 * Enforce THP collapse requirements as necessary. Anonymous vmas
+	 * were already handled in thp_vma_allowable_orders().
+	 */
+	if (!vma_file_check_thp_tuneables(vma, vm_flags, type))
+		return false;
+
+	switch (type) {
+	case TVA_PAGEFAULT:
+		/*
+		 * Trust that ->huge_fault() handlers know what they are doing
+		 * in fault path.
+		 */
+		return has_huge_fault;
+	case TVA_SMAPS:
+		if (has_huge_fault)
+			return true;
+		fallthrough;
+	default:
+		/* Only regular file is valid in collapse path. */
+		return file_thp_enabled(vma);
+	}
+}
+
 unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 					 vm_flags_t vm_flags,
 					 enum tva_type type,
@@ -190,27 +251,8 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 						   vma, vma_start_pgoff(vma), 0,
 						   forced_collapse);
 
-	if (!vma_is_anonymous(vma)) {
-		/*
-		 * Enforce THP collapse requirements as necessary. Anonymous vmas
-		 * were already handled in thp_vma_allowable_orders().
-		 */
-		if (!forced_collapse &&
-		    (!hugepage_global_enabled() || (!(vm_flags & VM_HUGEPAGE) &&
-						    !hugepage_global_always())))
-			return 0;
-
-		/*
-		 * Trust that ->huge_fault() handlers know what they are doing
-		 * in fault path.
-		 */
-		if (((in_pf || smaps)) && vma->vm_ops->huge_fault)
-			return orders;
-		/* Only regular file is valid in collapse path */
-		if (((!in_pf || smaps)) && file_thp_enabled(vma))
-			return orders;
-		return 0;
-	}
+	if (!vma_is_anonymous(vma))
+		return vma_file_can_map_huge(vma, vm_flags, type) ? orders : 0;
 
 	if (vma_is_temporary_stack(vma))
 		return 0;

---
base-commit: 234e77148199ae43b83a0a03a3f481e03460a286
change-id: 20260827-hugepfn-allowable-orders-ff323f85fc57

Best regards,
-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>


