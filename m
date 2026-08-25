Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06201C5DF94
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 07:55:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 051316B0095; Tue, 25 Aug 2026 03:55:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0287D6B0096; Tue, 25 Aug 2026 03:55:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA8436B0099; Tue, 25 Aug 2026 03:55:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CB2416B0095
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 03:55:39 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3B9A68028B
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 07:55:39 +0000 (UTC)
X-FDA: 85139032398.21.95BC4A2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 709BB140006
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 07:55:37 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HhUM9DpS;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787644537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=yhrTrxCBc00NwW0qUXfxz5rqpATbkL+cccg5ndk3DOA=;
	b=4hqZjrfrTAhLdDOi9wLMgSgcxR67s6g06uiCMjwza3FMO/YU1BVCF84UUbNEgN3vE82DdN
	tL9K43hBAGfZyoF08y19JQRghDeV4sHZ5SdvBQttAJRryNu2D51RoRHbnB+8M/EuGwBAU3
	A6IrqQ6H/u9BCABQm7b+u/iX0LruuMA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787644537;
	b=2SCxUs/x1ZKN82vK/KLXcJa5umWcLMoreLNkspzGkL9Tdq9DoWgbM6tE/e27H+mkfoHVW3
	neuxripGaFHFizYhIyYvWrurIoF0prRbSxw33AfLQWaquJpBTo9oQ6QYwJouke/ccl7z2+
	069+V89LFEWh+OClgEEOQqhRvOHGxfY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HhUM9DpS;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 57779419C1;
	Tue, 25 Aug 2026 07:55:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 914011F000E9;
	Tue, 25 Aug 2026 07:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787644536;
	bh=yhrTrxCBc00NwW0qUXfxz5rqpATbkL+cccg5ndk3DOA=;
	h=From:Date:Subject:To:Cc;
	b=HhUM9DpSj6ZkEzU5cwmyQ5RXsssO8cVqBAGv/VeXMmcTHyAmHUQ24pCgP047DjJj4
	 gqrhNq8/Ae0JRp1nr3gBVa4XYJ61+ecUvkD0X6UgoBN545Jrefi6UUO1aaS0ks9nme
	 yubv4nfOBEajsfM0NOTO+PTAYZxSo2Pf3AghAxB7M1ZWzdvQtBZoxSNDHeYFrof+YK
	 UM26+ThGmkiZoLtGpRs9C8PX/GlWMYokZKCMpGoxqGOJbXeDl+xOQCQ2XXZGL7AhIl
	 GU2u8mi9/Uownq0zkEkesRzPWs6rL4Cw6L0m6Jsjc6LXze5TAQRe7feGLjrrm/IGB7
	 Olw+zNie+1D1A==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 25 Aug 2026 08:55:26 +0100
Subject: [PATCH] mm/mremap: reset unfaulted VMA page offset for
 MREMAP_DONTUNMAP
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260825-fix-mremap-dontunmap-pgoff-v1-1-39a40b2c98b3@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x2MywqAIBAAfyX23EJZ2eNXooPUantIRSuC6N+zb
 jMwzA2RAlOEIbsh0MmRnU1S5hnMq7KGkJfkIAohi07UqPnCLdCmPC7O7of9yBunNSrZtWVVU98
 3BGngA6X6n4/T87xdfPTObAAAAA==
X-Change-ID: 20260824-fix-mremap-dontunmap-pgoff-a687134e995e
To: Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
 Li Xinhai <lixinhai.lxh@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 syzbot+f12658786a4153df5113@syzkaller.appspotmail.com, 
 stable@vger.kernel.org, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2999; i=ljs@kernel.org;
 h=from:subject:message-id; bh=XAjv6WtrWWzCB6YeREY2fuaNyp9p5PNb3fFaAqJ2NVM=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJ6vYo2Ht5/Yt8eMwWhH+nyQiprNOdO7+4+YKIsNa96W
 sCs2ae/dZSyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAidk8ZGbo3rwxj9fv0f/UE
 kdbLE1ecNl36+2B/2MvF9T8LtdZp585nZLh+mvPfTjfvv0JR/x7psqi2edybGCHLduiAtEJxvcN
 2PQ4A
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Stat-Signature: 377op9r1e9tjn5etyxm8jk7ofmhdmg1y
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 709BB140006
X-HE-Tag: 1787644537-897425
X-HE-Meta: U2FsdGVkX18SRP36phxR7KyepSnK+Hoq3rYFCcR5KWmafBReW1FfFl85wZdRbOvJaeT+BPqpYbxYQ1TpkEmIqF53ws+yk/A9lb8FQuYMksUZQa2hI2hN54Ciffm/HOgTVOty2bMRU4PNOSQf5dxYn9wcbTYhL9MXzgy+pZmSOMDO657p2YA/Gp8FIpdMCX1R+un9+iTX+j3b6hprihy9+ps6mtMxNAaA5sLK/iXW70HPVN+gkVW01sXDn01RhvE6a24YepmR6U2coAuggoUubcFT3JCzupSMdOIEk/dEKgA+JSGZV8EjV7tJGg3/c9cly6SpTogZKBI9ntHkae1AygijK/kDX4x5rK7jdiIww2bJPESWiYOrqMF27qbuI+XlCXpB4onhLUYH0n0FxWLGVIhdmBpYNE2FNSXcBELOgaUOREjZRm5W0d+wC9RXTQO0lJ6LKIt7/NvhF7VuzbLIBXIQ+v7h38cibJbyPJRV3HKIqvgbHqTVfStkCRjKhRSPaauoMyKqPkS2hy6jWVS5+ZGoH8ycEi67Q/fGAbTliQZzE1ydM9og8k42Y3ouHwCqK3Td/ZJDcIesxTAER4jfAXYbWj3WMhUQKL7/pxgVv3JZrrF9HXY73UTE19RGaZ2BuMFKhdLX0gAdMuEHeTO1M/XhjkHiUTWb6rR+pRhrIwLuyXPhQbtetziP6IRaPHU8o1VZkBkSge8X3OCsxviZN9oOAWu4ugfKK3KTJQcV0kA/CtdB0NPfMJIY9hrQlS9mpvvfnktqC0NGrB+pR8nRU6EFtGy6H2W42ZVVtFnayLzWM0PV+fQDV6vXNNPi9bypfvLqOqKTxfRxVFYIEIUTs82cEqYX8efBLuALvh2cDsf2x8UcDl8llxli0SWRlR2pr7LKi7AMY4f8jCS+fcNgidX7VzGtMybMr17iQjxITKnUC3E5VZkte5UAPfya5X3rUCCfrPe+SSutm4X0iw8
 V+rpRn0l
 pA2PszTJu94t8njybpLpA9PAkbVmL5e7Gpb9ajQ2pzELKuU4CsOBycd2RUvBgXZ0haNYvVdgUxidYTJfXE1rCaje3i/UlErs1dfchA0CMe3BZL0wcWQ8RWDvV9PEVsjpOxhg5Vd5PBQ54EQicN27ei4M6ThrgdyGoWIP0SirasNuaaZU8xaLi8QsfbZOJ0dynlW6226Dui8/OEEuPr2OTdkEt68LccAnKdTh0wuqgMYVIh6n+2VRwcV5qZ7JrF/i4oVBhOEDrf0ZHyxBqfnL3xeIXjJIJpmvFiCzb05y2o01gLq7SGcBiYpVnTlxcHYIDXQ8sLNQXYSKmEZ8R3iIU3775Ndcc6kV/nBYPPdZMq0+IiXpFMrVNlBRAM3gCAPuCZaPq22vxCzyLxt7UVMwFa5Nl/vyxESM+mRQD6Ps7cqODn908XIESoHUojYXZ8T3dAaJI1eooRmf4on2StIluCJijhg3wtmrDqcSfrtlQ/8o8R9pm9ui3QCOHcg/IBJ6XI4CF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Uniquely an mremap() invocation using the MREMAP_DONTUNMAP flag can reset
a faulted VMA into an unfaulted one.

It does so after the page tables have been moved to the copied VMA with
MREMAP_DONTUNMAP leaving the old VMA in place which is naturally unfaulted
as the page tables it had are no longer present.

However, in doing so, it violates the invariant that the anonymous page
offset of an unfaulted VMA is vma->vm_start >> PAGE_SHIFT.

This is because a VMA may have been faulted in, mremap()'d (causing a delta
between its page offset and vma->vm_start >> PAGE_SHIFT), and then
mremap()'d again with MREMAP_DONTUNMAP resulting in the unfaulting.

This condition is a violation of a fundamental assumption in mm, but now
also triggers an assert in assert_sane_pgoff() which explicitly checks for
this condition.

Correct it by resetting the VMA's page offset at the point of completing
the MREMAP_DONTUNMAP operation.

Reported-by: syzbot+f12658786a4153df5113@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/6a87853b.ae6ddae5.3da009.0023.GAE@google.com/
Fixes: 1583aa278f5f ("mm: mremap: unlink anon_vmas when mremap with MREMAP_DONTUNMAP success")
Cc: stable@vger.kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/mremap.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index e8df5cdb0ac9..2b4b523a86b8 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -1331,18 +1331,30 @@ static void dontunmap_complete(struct vma_remap_struct *vrm,
 {
 	unsigned long start = vrm->addr;
 	unsigned long end = vrm->addr + vrm->old_len;
-	unsigned long old_start = vrm->vma->vm_start;
-	unsigned long old_end = vrm->vma->vm_end;
+	struct vm_area_struct *vma = vrm->vma;
+	unsigned long old_start = vma->vm_start;
+	unsigned long old_end = vma->vm_end;
 
 	/* We always clear VMA_LOCKED[ONFAULT]_BIT on the old VMA. */
-	vma_clear_flags_mask(vrm->vma, VMA_LOCKED_MASK);
+	vma_clear_flags_mask(vma, VMA_LOCKED_MASK);
 
 	/*
 	 * anon_vma links of the old vma is no longer needed after its page
 	 * table has been moved.
 	 */
-	if (new_vma != vrm->vma && start == old_start && end == old_end)
-		unlink_anon_vmas(vrm->vma);
+	if (new_vma != vma && start == old_start && end == old_end) {
+		const pgoff_t pgoff_unfaulted = vma->vm_start >> PAGE_SHIFT;
+
+		unlink_anon_vmas(vma);
+		/*
+		 * The VMA is now unfaulted and it is an invariant that
+		 * unfaulted anonymous VMAs have page offset equal to
+		 * vma->vm_start >> PAGE_SHIFT.
+		 */
+		vma_set_anon_pgoff(vma, pgoff_unfaulted);
+		if (vma_is_anonymous(vma) && !vma->vm_file)
+			vma_set_pgoff(vma, pgoff_unfaulted);
+	}
 
 	/* Because we won't unmap we don't need to touch locked_vm. */
 }

---
base-commit: efecab401cb15fd3bb9bc05990609acb6b267ff2
change-id: 20260824-fix-mremap-dontunmap-pgoff-a687134e995e

Best regards,
-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>


