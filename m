Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36177C88E6F
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 17:16:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB4D26B009B; Mon, 14 Sep 2026 13:16:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8A346B00A3; Mon, 14 Sep 2026 13:16:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2DF26B00A5; Mon, 14 Sep 2026 13:16:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6E5396B009B
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:16:00 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ADFCC1401FA
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 17:15:59 +0000 (UTC)
X-FDA: 85213020438.30.92B3A12
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id B034214000E
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 17:15:57 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ZzPJ/z0v";
	spf=pass (imf23.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789406157;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vuA1nX0DcktkAAWD9sJhkbSpEmxlLRDs+scV9aZiZJE=;
	b=FcZBFKRFPHJUbEeW9vAkuGD4CFgrcNmYcI2cx6qNNuc1pKyIrgRSztqdAuQrri8duIL8hU
	M3oxYDxTkipgFFmZn3FQN5gGgPN/5bpejPTfvxhoXwX7SgWcIOeXQSd6czSGLu4Flj4RCN
	EM4elhcut8JunYEBIzoh6SmpOsP17nQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789406157;
	b=3VuD7hvsbzKRXmtcs8qa/E5WW/8JEr3czdRkijyVcS22nYlFKHcz0UTNisL1pQ+bKdcBwW
	3k6Nxyuxdqzp+s0JIbksvP8Ch/SfsZqKyjOggiOoSzFJM1D/kk3d17SIVS8S1+d9TR+Ndw
	OHFFr5a2x0wM8Y6BSSWu6dKt6Dlq82E=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ZzPJ/z0v";
	spf=pass (imf23.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8564E43E39;
	Mon, 14 Sep 2026 17:15:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 65DCEC2BCF6;
	Mon, 14 Sep 2026 17:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789406154;
	bh=K/oSF+2agPXDgDxaM2IzKlARsF2Hh00l3yfgiAnAguI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=ZzPJ/z0v8Qaoh+5nn6E0vIqhApfn3qV77JPI1JxIf6Vi3ZNzO7jO/pKRh+t3IIw+d
	 sWLlp8VWopgI+mOHhDoTbuhA1lxFUPZ2rYkX/JFHmXXo4ou5yMPz09jI3BAUz7a5Nm
	 Vkb1h4yIXBzaMvhTVEz3qfqzICZXZLnGJjSrg1x+hBGphtLKdm8ssW4fvbMvnwmnrg
	 hRdHdvcyoyDCSd8JnbPgdP1f/W6ZkNxd1iTdgUhm5za3f8i4lTjQzSpbtI5bumY7mb
	 bg3Ya2luMcvirCqtvim78d7anAkbFehTJI6cNPzJfywbuNx+KbD2qz1Lr3B0DDHbch
	 6xm99bhk02CIg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 528A3C88E73;
	Mon, 14 Sep 2026 17:15:54 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 15 Sep 2026 01:14:51 +0800
Subject: [PATCH v5 10/17] mm/huge_memory: move the racy refcount check into
 unmap_folio()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-swap-thp-cleanup-v5-10-39878b37dfb0@tencent.com>
References: <20260915-swap-thp-cleanup-v5-0-39878b37dfb0@tencent.com>
In-Reply-To: <20260915-swap-thp-cleanup-v5-0-39878b37dfb0@tencent.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
 Yeoreum Yun <yeoreum.yun@arm.com>, 
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>, Kairui Song <kasong@tencent.com>, 
 Kairui Song <ryncsn@gmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789406149; l=3481;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=6TD9CYMGDYoBQJQWdao35dtOQRgVegEwGFMbqhcYaO0=;
 b=lVGM00QcXpp6HveeRp+JBlSlB+2SK6QZpSYox3k/Ndb9lJ/6B6bASgXEZFd2PRyltk2PVjluZ
 Cv5U5EOzV+OB17/C84FB5+qsjW6nu9RlQipZ6PwX+sJzGCuJVmsoRVg
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B034214000E
X-Stat-Signature: a9oapbhufjk9ppzcztz6ub6ge88wg6ei
X-Rspam-User: 
X-HE-Tag: 1789406157-193710
X-HE-Meta: U2FsdGVkX1+Wz7VhOt2eld545dyYlDR++JHDt7bmLr9W2FF1XgbU77qESh5Zf7uCvpvWKq4C7Ro79io8jUG2m/YjH9eWbN8S4rFpqC11tdQZ8Gdop6ti8gz4hF4tsG5WTVzwVVBZ7cEJ4I18Li3LHfRJWSM4iCzkQdee6LBSBFcSH78QGCjMZGEbyZVNFM+CqUuSbg90+TV8pmkmIaH6BGdwdE2P0jxVNjJ/ekO0aK1RgVjpqLcfWg7+del2n+FxTx+4Qroo1ap8qQTfOUJQ9SgLkynLyBJZ0eIp5lTyaCn1KB0/zO8mz9RElZFtR0yIlRAzNRYJcGzvdTdmZS0p3zlzYA+7tWGAfgSJLKu3doZlXkaV+n3BZmoRsuG92/kFi/YMdmz4fEVSaLuQxzkD9BZbeqwBg161Mt5CQo+zV79bqdIYi9o2nyRij9+QOAaNq66phAVtFfsnJMaUwe/rU2vReNOTtZ3QfLFmJ9DeYxKMTpG3sHbWwdxGzYFTdS11tjsGK5imCyqZ7zSUF28FSPhb4uBIEawx7Blc9/ZPO04Ll1BdU3F1iVdczcI9OdSetcdQLokIzYwrF+uEwl0ExtLL4fEx61xHvj7lBJcAGC/KXIF2oG2FsGiMKdjq9flO2gOd9Y+OmRXI86UjIEPRBtJYQjzFhno8QZZMqGM7UFnexYhW0D0l1JXXiONmYS4r5YLhtC2etnpPg8fTU2Bl2qC8xRiEq5tq/GRCbyikGKz8dyQJvGerQZ3QzUeq1CepQ+TLSB+XtLRJyF784+28mpU4pLQp2Q2PsoilLVeODZjWdaFmp7Yn3N4lljKhQfZwhbE8rjaBqnXkavVaqgj9s1/Ze/kqf17hjqshM7xFuzZVarQOVHwQ38Mzyzu5UE3+nvLWcvSQohW7cHwYGiG1+gQFBbjaJsEjnoLX0G0P6m6bNyOI6ADPAhYzQIyTdkzLIj/AO4N9XFu7nCeo+gA
 /haDZtdF
 lF3DstSMNM1TQvaSvrtWAfuWUsYAwiavcdoZJNogtzbJ5rAL/XIxXjAUO3lztt/w9DQqO0i1lG4LsaePUz8gZLWP8PldNhHa9PVnFA25ZLYZMliQs8EaOFx7biCQOzGW9s/afhXzqkse1hfd5VBs5g+3GDTPH/cfk8XLq7T969W99FBqD/iPlUubaKaGn4V1qlufiJVzF7/INwOz4+VWwi+CmjiCP3mpR/8PCTB51WWr/m97z+Ze+aCu2R7uVDxWUQbCPdvtgdETE8F+HDocjKwmIivO4DLrK/PdkvJZGY+s+2EdHxYsFSgLAGtOQQgyePapiylaU5M0rYFW7koH/dORAbGhOAjktYLDnijF24I72a0BIJtiZaujKh/fKN0mN5S/Ispc6DXXk/R76xl6x1rK5/BI9kkst4ovKU8TS+DKLOC5af5QhbNmDgJYJpnuuVY8JSd3jYQTZIUUr2BN2Dxn46YcJkp0I5TJ1lrdc8pl1eLvAVASAFdaRee6kbl/e432A
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

The check only exists to avoid the expensive PMD-splitting unmap of a
folio that cannot be split anyway.  Move it from __folio_split() into
unmap_folio(), right before the PMD split, so both the anon and file
split helpers get the early check without repeating it.

unmap_folio() now returns -EAGAIN if the check fails and the split
helpers propagate the error.  folio_split_unmapped() drops its own
copy of the check: it works on already unmapped folios and the
definitive folio_ref_freeze() in __folio_freeze_split_anon() still
catches unexpected references.

Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 77bf68c9b9af..859aefda7356 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3539,13 +3539,17 @@ void vma_adjust_trans_huge(struct vm_area_struct *vma,
 		split_huge_pmd_if_needed(next, end);
 }
 
-static void unmap_folio(struct folio *folio)
+static int unmap_folio(struct folio *folio)
 {
 	enum ttu_flags ttu_flags = TTU_RMAP_LOCKED | TTU_SYNC |
 		TTU_BATCH_FLUSH;
 
 	VM_BUG_ON_FOLIO(!folio_test_large(folio), folio);
 
+	/* Racy check if we can split the page, before we split PMDs */
+	if (folio_expected_ref_count(folio) != folio_ref_count(folio) - 1)
+		return -EAGAIN;
+
 	if (folio_test_pmd_mappable(folio))
 		ttu_flags |= TTU_SPLIT_HUGE_PMD;
 
@@ -3560,6 +3564,8 @@ static void unmap_folio(struct folio *folio)
 		try_to_unmap(folio, ttu_flags | TTU_IGNORE_MLOCK);
 
 	try_to_unmap_flush();
+
+	return 0;
 }
 
 static bool __discard_anon_folio_pmd_locked(struct vm_area_struct *vma,
@@ -4030,7 +4036,9 @@ static int __folio_freeze_split_anon(struct folio *folio,
 
 	if (folio_mapped(folio)) {
 		need_remap = true;
-		unmap_folio(folio);
+		ret = unmap_folio(folio);
+		if (ret)
+			return ret;
 	}
 
 	local_irq_disable();
@@ -4124,7 +4132,9 @@ static int __folio_freeze_split_file(struct folio *folio,
 	if (shmem_mapping(mapping))
 		end = shmem_fallocend(mapping->host, end);
 
-	unmap_folio(folio);
+	ret = unmap_folio(folio);
+	if (ret)
+		return ret;
 
 	xas_lock_irq(xas);
 
@@ -4332,15 +4342,6 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		i_mmap_lock_read(mapping);
 	}
 
-	/*
-	 * Racy check if we can split the page, before unmap_folio() will
-	 * split PMDs
-	 */
-	if (folio_expected_ref_count(folio) != folio_ref_count(folio) - 1) {
-		ret = -EAGAIN;
-		goto out_unlock;
-	}
-
 	if (is_anon)
 		ret = __folio_freeze_split_anon(folio, new_order, split_at,
 						true, list, split_type);
@@ -4379,7 +4380,6 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		free_folio_and_swap_cache(new_folio);
 	}
 
-out_unlock:
 	if (anon_vma) {
 		anon_vma_unlock_write(anon_vma);
 		put_anon_vma(anon_vma);
@@ -4427,9 +4427,6 @@ int folio_split_unmapped(struct folio *folio, unsigned int new_order)
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_anon(folio), folio);
 
-	if (folio_expected_ref_count(folio) != folio_ref_count(folio) - 1)
-		return -EAGAIN;
-
 	return __folio_freeze_split_anon(folio, new_order, &folio->page,
 					 false, NULL, SPLIT_TYPE_UNIFORM);
 }

-- 
2.55.0



