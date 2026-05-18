Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0CC5CD4F3C
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 06:37:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AC4D6B0093; Mon, 18 May 2026 02:37:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25CBC6B0098; Mon, 18 May 2026 02:37:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 172FB6B0099; Mon, 18 May 2026 02:37:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0560F6B0093
	for <linux-mm@kvack.org>; Mon, 18 May 2026 02:37:20 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8FFFB160257
	for <linux-mm@kvack.org>; Mon, 18 May 2026 06:37:19 +0000 (UTC)
X-FDA: 84779583798.15.4782DDA
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 98FE2C0002
	for <linux-mm@kvack.org>; Mon, 18 May 2026 06:37:17 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=t6lho3Um;
	spf=pass (imf10.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779086237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=dyQ3AuN5Xwa9i6BFNOVh2Xjrwf2xXN8y/Ldba9BSZEA=;
	b=7alHq6Hu4YgMDJ0d+vAgbwxjVT0280OS8j1p7uTtI7mRtXuwNO/jtVWlQT+PnlYUPpMjgL
	a+f6FfIpYbiOadJORYyl+2xHTNIHklsYaGmqhEJcPb+9vGQAc8AvsX+HOTqF7blx12umRI
	6LkV3zrui7COQT2wwSFA3bP/kgqwr2A=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=t6lho3Um;
	spf=pass (imf10.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779086237; a=rsa-sha256;
	cv=none;
	b=dKIYCk3u2GtjBT+naAIRMfafeUyGEGemj2BIak2vQNEso+OhmMVKNzmRvgrsKo6Sq2Zhn5
	KJ9cubEdo8oHRUvhRw+/NOKg3T77R+OT/KBNIhqkM/5KyMirFr/vtFiE711MtWrdzq5S44
	ZZ536w3tkjJSLYcQRjymYSpHZk038nI=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 260C745BD;
	Sun, 17 May 2026 23:37:11 -0700 (PDT)
Received: from a080796.blr.arm.com (a080796.arm.com [10.164.21.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id ABCAD3F85F;
	Sun, 17 May 2026 23:37:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779086236; bh=yQIbVnCjhAuXcMBGfVGIHYdxNObzjctBtEnLOIjQBZQ=;
	h=From:To:Cc:Subject:Date:From;
	b=t6lho3UmNLB5Cm7wXq1KfUS25waa1wm1w6iIg3gs5tcZD9vZrCzGj2pGb9GHydwwt
	 UP7Fn+rcxcfuqkFXoTiKefdP5RtlpKm0efarKCueLZfXKF4d83qeyGcfWLfI+8UUeF
	 sy6Jal5jsHiq0IHpP7D8fKztoqyImnje7LS/ewfU=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org
Cc: Dev Jain <dev.jain@arm.com>,
	riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	baohua@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com,
	stable@vger.kernel.org
Subject: [PATCH] mm/rmap: initialize nr_pages to 1 at loop start in try_to_unmap_one
Date: Mon, 18 May 2026 12:06:56 +0530
Message-Id: <20260518063656.3721056-1-dev.jain@arm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 98FE2C0002
X-Stat-Signature: n89h4rp1n7xakrbma696twxzf9a7gjkr
X-HE-Tag: 1779086237-486443
X-HE-Meta: U2FsdGVkX19oaBNiYoR09ILruI7O+0F41HCnJIvfacdDAvStRRTZ8cvrrAk8uUZ1ni3+nlknT1TSMBE6AZIHr6vkuZe7huVqqMsY3yZcHZ0umew+g4UCk4ohD/wV3YWh6BYqzna80yyVUfR87ewAJPYPGJ6MNWTvZcgOISdgBVDTR4EMv2iPav2RVKN2DE8lGaYuI10wDqiRGqedNO82a5beky2S5d45ROKOUT2mmiieKq7SWoWM45ELrWz5Ejzbp0926gkfyPtghN9NEFJDj/LP0UCNwos7E5seyb7S8919LIyh4eIamyCw0UIXLwKeZKValpokiRbSja9DEQf9c1IE8cM/sn73yfYWWU0dTzX+hHt9lgWXN2kqs8MtZ3zzVC0pWMrsJm0tSPSHEHnZKpElWqv6C6MAUBthGPk7XZIxgJxYFQ9Y/nWFT33flIMloxQzclag+0FsfvpSDu3hbHV5xJ2zGotc2FUxim+hdHW5lXHbxjgNcWAOzVCB6+EQvDmsF1Q76QqY6wJ2oOOcfUWHsLaLz/PHAbkkCOhoRWlLeoWJmmP+aNF/m+0czHuMwFGdkYptOSkq7R4BfB/3liTctSdD0/BHaBCJVaXD0NrP0BW67lm0MCVAmV7YsJrWGplcoUcILL6koKyr6EaSZi637jEgaEOrDaZZjaTuGs79LmhOC3TaHC5clP2Qw6QTFy4GwAKyM2HA6mLpEM1oLwSvys8AXhtkRl70my6XyoUZcXD/HotLA3HNqyjY5wniAGsgpxVyuBrhOJviz96NMaJn39feHtJ+wlbQNK87QBiGOn/PkBFGP1qXT08TV73x7JqQgj9m5+oXc/wN0UYp6ihLSkwn40liFEZ7EdIeuqEVTb+Vo6qZUb2XoidvVzqL9PVlwzrPkck2Zh6bDWHIu2J2N4gVfO60PFVeEYaUkiLaup8GMFoVo6TVtSJ579OHlPXCsqto2JOoat1qv9+
 8PtZth+z
 hfWaC/GXQrd/zqBm3KV2RgD5nxWr0ZmxyZdl9258N1rnbuS6N2HgOfo+tW2RPfdglzWhGW65j+wRM1IixbPocpK1887M4meNBuSq2fpH5dkMkRcajMZcxEU7o3fflMu54TlQIiOUUi+RMRkH+wUawd8+WzPEQRRppoyKMy9yzF5Fb9SPyGyB22hGmOKuGHLfwCpQ5Hb6ol+7xP45XimTOIbM5kf9kHFXh3Ez2SeMyRSCBbf6ezgEbUTVIK+y0ipmTldEci1y9Z3/PLlCap5GNfLPjWmgU+b/jN8knlJZDxsGB1+k1oYN6RPaVjQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Initialize nr_pages to 1 at the start of each loop iteration, like
folio_referenced_one() does.

Without this, nr_pages computed by a previous folio_unmap_pte_batch() call
can be reused on a later iteration that does not run
folio_unmap_pte_batch() again.

mmap a 64K large folio with MAP_ANONYMOUS | MAP_DROPPABLE, then call
madvise(MADV_FREE), then make the last page device-exclusive via
HMM_DMIRROR_EXCLUSIVE.

Trigger node reclaim through sysfs. Now, in try_to_unmap_one(), we will
first clear the first 15 out of 16 entries mapping the lazyfree folio.
This will set nr_pages to 15. In the next pvmw walk, this nr_pages gets
reused on a device-exclusive pte, thus potentially corrupting folio
refcount/mapcount.

At the moment, I have a userspace program which can make the kernel spit
out a trace, but the blow up is in folio_referenced_one(), because there
are existing bugs in the interaction between device-private and rmap
(which too I am investigating). I did a one liner kernel change to avoid
going into folio_referenced_one(), and the kernel blows up at
folio_remove_rmap_ptes in try_to_unmap_one which is what I wanted. 

Note that the bug is there not since file folio batching but lazyfree folio
batching, since device-exclusive only works for anonymous folios.

Userspace visible effect is simply kernel crashing somewhere due to
refcount/mapcount corruption.

Fixes: 354dffd29575 ("mm: support batched unmap for lazyfree large folios during reclamation")
Cc: stable@vger.kernel.org
Signed-off-by: Dev Jain <dev.jain@arm.com>
Acked-by: Barry Song <baohua@kernel.org>
---
Applies on mm-unstable. This patch was part of
https://lore.kernel.org/all/20260506094504.2588857-2-dev.jain@arm.com/

 mm/rmap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/rmap.c b/mm/rmap.c
index fb3c351f8c45..1c77d5dc06e9 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2030,6 +2030,8 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 	mmu_notifier_invalidate_range_start(&range);
 
 	while (page_vma_mapped_walk(&pvmw)) {
+		nr_pages = 1;
+
 		/*
 		 * If the folio is in an mlock()d vma, we must not swap it out.
 		 */
-- 
2.43.0


