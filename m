Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9A99C88E72
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 17:16:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 710706B009F; Mon, 14 Sep 2026 13:16:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E7A26B009D; Mon, 14 Sep 2026 13:16:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 400F16B009B; Mon, 14 Sep 2026 13:16:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E49346B009B
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:15:59 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 723501401F6
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 17:15:59 +0000 (UTC)
X-FDA: 85213020438.13.63CD82E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6BCAE40005
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 17:15:57 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ed7ob6Bd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789406157;
	b=HzHC3oGymlGfpbg+uUpjTnHq0aH/SA3A/pzCtw0ompaladKhvEremEX9ImuecWvvmWZFli
	wYYMYl3j9s4QoB8rjhZmifbDqti+WUFcMlewii2phnrn4s+u+MRy587zPybgt4qzqRv0n0
	8E8JOaTLWzgH0BCOuET1zWJkB4xNGCc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ed7ob6Bd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789406157;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9yIlVvfuD1/anKBYcEj4x2/TIWU3wRed1Pt2CUfbcKU=;
	b=Ulv98dY4q+pfvAQ93zwS7pjPdjU0r/6dAZ4s9QeMOOaYwxubAH0kORt6tgoCjMBPYd6yd4
	mu2O9XZkkIKeT6g6TimcxVaABgtZ0jVhFbD5XOJQWNkN1VsX7J8nWhZN4RWzB6Fhd+ey2v
	FE1AaP1rZ1c6Zq/5LYKQ6iUdHR4CuYE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6640143EC3;
	Mon, 14 Sep 2026 17:15:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4558FC2BCFA;
	Mon, 14 Sep 2026 17:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789406154;
	bh=DcJOrA+hy4AdWGH1eeNmetKcf0DNfdUW2VhTqnlEoAU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Ed7ob6BdrjtG37mDev4F19RRa2aPP/yEYcOoqVcUtJFXct6gd/F9OgEOA4GtBjruu
	 RTTXyGCSQpmzCPTTyoF3zk58iiA5IgvFq4gJR2MjTjon9nW85Ro8QfSR945EgoVCLr
	 f6koUwzwNabGoj/8uucvuHcV8KqTiuZ+pAbwBZOg6bScPBlltTHkC5dDn7M8vfzDGv
	 /4Ar+DvC4SzzYKnhTIHwmT9gq/mxKMH07ro8udr+CqgmriK9yu1nEiQ1ldtLs+xRbT
	 j8NycgUs9CxHlq744VdLReq4jMvqa/+qC+YKTRiLmIOm3sC8jmaikHDUARj3u6IGlJ
	 cTniMJRPJe9Hg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33B0BC88E79;
	Mon, 14 Sep 2026 17:15:54 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 15 Sep 2026 01:14:50 +0800
Subject: [PATCH v5 09/17] mm/huge_memory: rename remap_page() to
 remap_anon_folio()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-swap-thp-cleanup-v5-9-39878b37dfb0@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789406149; l=3127;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=ExS3iXqpo6EWOs0c9NJj+fgN8aW+sshu/TIwyTi4/5Q=;
 b=Y9+nNMHYhV9nhxAXbvADVASdUNcBZtc1OtdH8YWUKSGPhLNd8GhGs8EA+UdTwNypv2ZjEdP5e
 kG/KWg5Q5svCci6svRnAHXzSF2FUH7jMNCkRnQrjceueAUdlJWjA0yO
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6BCAE40005
X-Stat-Signature: kpzrochwe1fy6y5m9hk13kyjggakgui1
X-HE-Tag: 1789406157-717209
X-HE-Meta: U2FsdGVkX193dPvhwlD6dq/HlRryMgJ8gnT0MSomodQ5216PU4TbxaIsYFzOGDpERn4qvofR20aVqRJMAl7N0sZy0Pc7Mw5nxm18cULNFiZQaloGj85AnhlsoONf1fwG/qd1Y0vJltJ3svOBzN8TbSsDPku1yym+M0q4lb6GWamdrkI5a57QjTZhjB8bglKjPCbapIOQz2nmqZaMLSOwpf8I4/8A5ROagidPau4YaHbJMP3ez2HnuQWe2pSjBBCumKWnotJPTArDv4fO52IQU1BGP1f1+rCQT/HRx0Ins0o5qdwIJ0SA1WnfHI6RZYmbA5bpWRKhFAOVYsWQDPOyJSxpAw4fHN1A+JmxhTuxA2ECcxWEDByvrqE+L4YQu0pH7Mwis4K7HzrI3xbvEBp7hzb5bxLpuaFbkpWm8Ik/mlO2iqaL/PMYW9g46esRUC6p+XyTQN79fC3MUBYIDbp7M+0lKH5Bd+VaWggyTSh8p1mCYg6Jmh4fMVNQAKkDBjMSqlo3+4dBCHYofc9iEr3OA/fhwlgU/tmXUiT8RP4KukWPVxS3ip8Ks2C+RKkVhmr4lOSDXUG3wgjltu2U6NMhsSgulqbSGxDJfXL7tCNgynD55bUxY2ZL5t1DWnkHPC6q/iAO3KjIbTOxU7J1pgzYd6Ssb9o0OSE1XhVdyC1gLsVSeAGTzIYlHUoUKikR+V3LKdKvEEPw89xJXudSlEzj+cqb0teZ9qAmpQmoVg/HhP2zfx/3yYmD+0JIqtExN5/+RLq/uyckiEKo538L2WZzoarimOKKf1cHe9iA+3nB+phVcZUl5v0XNNRAzaM3Zs3Y0TWidDARPTJ7lNrr/rS/AewAAoy+PSG7wV/lYZqXDhv8Ef3lxkAhQDTcls5LlVGgAsPoq+0164Rh0M0E5myrOCd8i2cCtsRkmZTEXUyRg1glNKSVVt+MtW5McHKfh81R6O68iSlBKGRkNITlWTM
 DK/puhET
 LParBCcPBeg2SYdRT9ExeKnuvUwGE/+UqZx02roHc8dUp5g5AfGKSOzMp6HwBdZAeFBoRRtijlOs1kE/g+R0OWd3YHrMChsRy9VRc0PW8FV/pCz2OtuEGo7yOYZM9nkTx76KdWX019EexEFJZVR5xT/o3vBODDYhmRojRkEITIQuCQG+lW/0zFvitak+0Y/J8G+3JaKgcjBirKZp9ZtReDe7qYGP3d8z+inh4UElYL6iCcLdwmkaq0s0T6fTMHjt37sutMJpOIoWC7b6ImfPfHfaXcQrRhVmdDr19KXJSr+1/1q99j2S7jOjhaGfIRS55DCPfyGUF+hlGxCC6vxWGkGksc9loh7whPEuPqWfv1XeenfdRCBvgJVP/6dcotx/sg83gDUsdg/25SRCQwn6GG9Xq0ezsmmhNMXxpYBBD1gp4b+Mwpfrlop3n60u9hQnZveN+Txe9HR3OCho3UX+VWiyiPezP83WA+mxczuBCAobXONjWih8yDhlkz0nNayQxBrA+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

remap_page() now only has one caller, __folio_freeze_split_anon(),
and is only ever called for anon folios: unmap_folio() currently
leaves file folios unmapped after the split, so they need no
remapping.

Rename it to remap_anon_folio() to make that explicit, and add a
VM_WARN_ON_FOLIO() documenting it.

Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 1749905ade6a..77bf68c9b9af 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3552,7 +3552,7 @@ static void unmap_folio(struct folio *folio)
 	/*
 	 * Anon pages need migration entries to preserve them, but file
 	 * pages can simply be left unmapped, then faulted back on demand.
-	 * If that is ever changed (perhaps for mlock), update remap_page().
+	 * If that is ever changed (perhaps for mlock), update remap_anon_folio().
 	 */
 	if (folio_test_anon(folio))
 		try_to_migrate(folio, ttu_flags);
@@ -3637,10 +3637,17 @@ bool unmap_huge_pmd_locked(struct vm_area_struct *vma, unsigned long addr,
 	return __discard_anon_folio_pmd_locked(vma, addr, pmdp, folio);
 }
 
-static void remap_page(struct folio *folio, unsigned long nr, int flags)
+static void remap_anon_folio(struct folio *folio, unsigned long nr, int flags)
 {
 	int i = 0;
 
+	/*
+	 * unmap_folio() installs migration entries only for anon folios,
+	 * so currently only anon folios need to be remapped. File folios
+	 * stay unmapped after the split and are faulted back on demand.
+	 */
+	VM_WARN_ON_FOLIO(!folio_test_anon(folio), folio);
+
 	for (;;) {
 		remove_migration_ptes(folio, folio, TTU_RMAP_LOCKED | flags);
 		i += folio_nr_pages(folio);
@@ -3724,7 +3731,7 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
 		 *
 		 * Note that for mapped sub-pages of an anonymous THP,
 		 * PG_anon_exclusive has been cleared in unmap_folio() and is stored in
-		 * the migration entry instead from where remap_page() will restore it.
+		 * the migration entry instead from where remap_anon_folio() will restore it.
 		 * We can still have PG_anon_exclusive set on effectively unmapped and
 		 * unreferenced sub-pages of an anonymous THP: we can simply drop
 		 * PG_anon_exclusive (-> PG_mappedtodisk) for these here.
@@ -4084,7 +4091,7 @@ static int __folio_freeze_split_anon(struct folio *folio,
 	if (need_remap) {
 		if (!ret && !folio_is_device_private(folio))
 			ttu_flags = TTU_USE_SHARED_ZEROPAGE;
-		remap_page(folio, 1 << old_order, ttu_flags);
+		remap_anon_folio(folio, 1 << old_order, ttu_flags);
 	}
 
 	return ret;
@@ -4206,7 +4213,7 @@ static int __folio_freeze_split_file(struct folio *folio,
 fail:
 	/*
 	 * If we want to use try_to_migrate() on file in unmap_folio,
-	 * remember to add remap_page() and adapt it.
+	 * remember to add remap_anon_folio() and adapt it.
 	 */
 	xas_unlock_irq(xas);
 	if (nr_shmem_dropped)

-- 
2.55.0



