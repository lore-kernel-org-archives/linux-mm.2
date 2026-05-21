Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71736CD4F5E
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 08:25:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D59BA6B008A; Thu, 21 May 2026 04:25:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE3126B008C; Thu, 21 May 2026 04:25:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAA7A6B0092; Thu, 21 May 2026 04:25:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A3D736B008A
	for <linux-mm@kvack.org>; Thu, 21 May 2026 04:25:17 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5A3771A0567
	for <linux-mm@kvack.org>; Thu, 21 May 2026 08:25:17 +0000 (UTC)
X-FDA: 84790742274.01.D4482CC
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf15.hostedemail.com (Postfix) with ESMTP id B9911A0005
	for <linux-mm@kvack.org>; Thu, 21 May 2026 08:25:13 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	spf=pass (imf15.hostedemail.com: domain of zengheng@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=zengheng@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779351915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=vll20j9+w7MJceFe5X1cuzr8FPOTBImpzV1yxdmcZN8=;
	b=INbkI2yVZpBO3aiChMwgKyhY1jyajk8vb4IDx8ZU2KAL2NIt3SrcgrIpCJ8yoZvuqyiHAC
	MJg4LdPU3ej0+VN3nFUA/pVMgwySfuSYg6GOQ+5nfVNJSXUczSisXYYxBBMC3iaLeP13wu
	HT7+cPQIsN1FMGRDXOamRnqcUptp5M8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779351915; a=rsa-sha256;
	cv=none;
	b=jXSssljzP/KBQ3Vglea7qOZ2y4lK2/150or9k3UqLifJKWi5SjT63UiNrPU82f7iq4SYPa
	VaCk+A2pAGLfY+C0fyygikqABoBunaYpAn/b1Ba11SlATWmr/wEei3atPsu7bEabb1O92L
	5hb6iM+F+/T9aPxfZ38JCgqDWQjHZEA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of zengheng@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=zengheng@huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gLhKn66d1zKHMhZ
	for <linux-mm@kvack.org>; Thu, 21 May 2026 16:25:01 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 989AD4058D
	for <linux-mm@kvack.org>; Thu, 21 May 2026 16:25:06 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.109])
	by APP4 (Coremail) with SMTP id gCh0CgCnb1tUwQ5q4ilcDA--.28289S4;
	Thu, 21 May 2026 16:25:06 +0800 (CST)
From: Zeng Heng <zengheng@huaweicloud.com>
To: will@kernel.org,
	catalin.marinas@arm.com,
	akpm@linux-foundation.org,
	npiggin@gmail.com,
	aneesh.kumar@kernel.org,
	peterz@infradead.org
Cc: linux-kernel@vger.kernel.org,
	wangkefeng.wang@huawei.com,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	linux-arch@vger.kernel.org
Subject: [PATCH] arm64: tlb: Flush walk cache when unsharing PMD tables
Date: Thu, 21 May 2026 15:30:11 +0800
Message-ID: <20260521073011.4121277-1-zengheng@huaweicloud.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCnb1tUwQ5q4ilcDA--.28289S4
X-Coremail-Antispam: 1UD129KBjvJXoW7ZrW3JF18KF1rCr45Jr45trb_yoW8Zr17pa
	sxCrnxKFZ5Wr1UAryUXr48Xry3Ca1DGr9F9ryUWF9YvF12yF1qgFWvyryrAFy8AFZ5tr4f
	W3Wj9ryUZF4jvaUanT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvFb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6r1F6r1fM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAa
	w2AFwI0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxV
	Aqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q
	6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6x
	kF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AK
	xVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvj
	xUI5fHUUUUU
X-CM-SenderInfo: p2hqwxhhqjqx5xdzvxpfor3voofrz/
X-Rspam-User: 
X-Rspamd-Queue-Id: B9911A0005
X-Stat-Signature: ycettbobo9a9q7x1pgiqak11zbstoodb
X-Rspamd-Server: rspam06
X-HE-Tag: 1779351913-557037
X-HE-Meta: U2FsdGVkX1+pdy36yvFphoo1jTgVTj2a7uSnTRhzRleEtcG3GbZ976gWiD3C/+VxR6s+GPge3oQXTQVtWtKNSl1KUe2OrDRTw2fwtK1MKud0XduJYFNBdJ5CBmzouncrRPsZhbIsXB8rCJzyYxM7IiyznRwS+ItwjcwuYv4rm8dPcoXjKG2mIEs+OKxJ7o6fvg46VveShewbrkvgisheYGGPwYdDIiBnJPiyaD3OiSElbRI4GCMHynUKU5DsnJooq3RRbU5fqRWe65MmHyJKzvKzeWlyaT5BffLIvmc2tO8QD7TC2ybPMIHJ8pL9W1lQLFv1rFytQ6HgX4rVI7Lg6TmQcgpZUb0XMucJUimuWbY+z7T5j/H4vif3eZqGaVfasa1dedLyhXLIxfmpLdOfk1ka2vmM/1cuNrDlQIjAISilxGGCKepEqozQUryeoZ8CkFQRpJNoaG7ht91Md/gqs4xScVD/qISBNSVI5YMl40Y3VR6fmVJ3cqAk7Ju6zYmS7oPQ3qeIH+aJiAG6Uj0mWtdYs5v61F2f5xbqyWjHuAJLDxorh1MeHEg36z5rnvUbUZtRfCVqGmzHBa8wU55dibKZ5riVzhS36fkcaheAl5/zt/QBx8ula1PMSkMk5NaO5rzkj61/0jrmuCYg4GKkrrdCFHuePaYx0J418viK63g+d0o21dCOwD7NfYV+9SknuB1pqW1dHB2aU7Lp52mUtcHIOxZrDll0KsdipWZ6g5fx/6JaoTYuveZs9FaNhvtYLe2ihR1mNZSK9WctbGf50+3M73eYUtUTTv5u+i2ovB7MybQqprd6G0eUiMdUvbvMyy1P23NcXKzSEVWEzgbrGtEoI7NbUGbkqIyeJ93z2xB2UjF18jwJstMpk8o32RaI7CXXP5Mo01kVCAf7ohoEx0s5iUqp2NWfwrJshOV8DUyHIF/zVKlTi6HkHyLScFe2ZlxzwoFSJnBsLZdJomo
 ++40+mSA
 +vQuPv7qqJE25aMJEQgLFhdW+EaI4kSeID15lEuI/hDccDaErlABNRnfx2v5g0YxxgIK3Hz8YFeHKyI5YKRG968Ve6w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Zeng Heng <zengheng4@huawei.com>

When huge_pmd_unshare() is called to unshare a PMD table, the
tlb_unshare_pmd_ptdesc() function sets tlb->unshared_tables=true
but the aarch64 tlb_flush() only checked tlb->freed_tables to
determine whether to use TLBF_NONE (vae1is, invalidates walk
cache) or TLBF_NOWALKCACHE (vale1is, leaf-only).

This caused the stale PMD page table entry to remain in the walk cache
after unshare, potentially leading to incorrect page table walks.

Fix by including unshared_tables in the check, so that when
unsharing tables, TLBF_NONE is used and the walk cache is properly
invalidated.

Here is the detailed distinction between vae1is and vale1is:

| Instruction Combination  | Actual Invalidation Scope                         |
| ------------------------ | --------------------------------------------------|
| `VAE1IS`  + TTL=`0`      | All entries at all levels (full invalidation)     |
| `VAE1IS`  + TTL=`2` (L2) | Non-leaf at Level 0/1 + leaf at Level 2           |
| `VALE1IS` + TTL=`0`      | Leaf entries at all levels (non-leaf not cleared) |
| `VALE1IS` + TTL=`2` (L2) | Leaf entry at Level 2 only                        |

Signed-off-by: Zeng Heng <zengheng4@huawei.com>
---
 arch/arm64/include/asm/tlb.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/tlb.h b/arch/arm64/include/asm/tlb.h
index 10869d7731b8..751bd57bc3ba 100644
--- a/arch/arm64/include/asm/tlb.h
+++ b/arch/arm64/include/asm/tlb.h
@@ -53,7 +53,8 @@ static inline int tlb_get_level(struct mmu_gather *tlb)
 static inline void tlb_flush(struct mmu_gather *tlb)
 {
 	struct vm_area_struct vma = TLB_FLUSH_VMA(tlb->mm, 0);
-	tlbf_t flags = tlb->freed_tables ? TLBF_NONE : TLBF_NOWALKCACHE;
+	tlbf_t flags = (tlb->freed_tables || tlb->unshared_tables) ?
+			TLBF_NONE : TLBF_NOWALKCACHE;
 	unsigned long stride = tlb_get_unmap_size(tlb);
 	int tlb_level = tlb_get_level(tlb);
 
-- 
2.43.0


