Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9155FCA9EC3
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 18:05:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 258E56B0099; Fri,  9 Oct 2026 14:05:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BACE6B009B; Fri,  9 Oct 2026 14:05:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0827B6B009D; Fri,  9 Oct 2026 14:05:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C66436B0099
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 14:05:23 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 54938804C4
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:05:23 +0000 (UTC)
X-FDA: 85303864926.06.894B48C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 78E56180003
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:05:21 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L3qLqNhV;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791569121;
	b=TuaEvCzTCe4+U4pYvPZ0lDRATZJJfX5vOq4jd3x5qfQ4lEghV7dKcmjgz0qdyW9URRGleJ
	k0pgDgYWA8G2hng3aI/rpuR06btgzV+yIfO2IC9fOyePjBHQMAUueecmNg9ACwqViXwlhe
	AzRd6mWLNd4/Jw4lue8u+21qK6AkuWE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L3qLqNhV;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791569121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hpQ3dp10EQMwRCwD3eHi09l9cQIxAnlp034y5giT03s=;
	b=p6BxCHW0xuZsIN6vYCC2SXyvqn/l028LI0LO1yAdTt33OG8VKn+2GYvEk1wsNanouoPRtZ
	DRNBQZeSSTSZ4QVXtgjza6RPqlaNxZTfGxllDOIPRSJtVONBCa4ID1Z0Q170pw9ot3MSeT
	jF8dp2xVQS8mu70d1nKiJMNRSEMo45U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 07DC660AB9;
	Fri,  9 Oct 2026 18:05:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 555DD1F000FF;
	Fri,  9 Oct 2026 18:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791569120;
	bh=hpQ3dp10EQMwRCwD3eHi09l9cQIxAnlp034y5giT03s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=L3qLqNhVtAqtRoH4KUKA4HjzDT34jcPjxFQtiO1J8Nz81ipPOTkmO7dW5K25SPdWj
	 sxkVyQLqCCRKN1anhjgC3Xg3gLLqyYnweHUAgNKkgIt86WoenigAEg8fz4nIIGDKll
	 o8E7rTbSWXn9ksG7T+4KM+oB+h4hZMyJUqptZrQcA70sdLLPiuLLkRnP3YwTEh8A/B
	 QvuEjRjT3Y2XSofKnX0MzECCYwPHhCkW7ymdx43djTrsdE0la4fqB5kEP6FLP1UZ9Y
	 yHwY+3/cIY3HqzeqbYe+nF/+sanQcHq3pNQfMjHPYFajDavk5rX5rlwbQB0M65KmnC
	 UqcDlhX7aQgRA==
Message-ID: <70ea8ee6-6fc5-4209-8cee-362da37f5035@kernel.org>
Date: Fri, 9 Oct 2026 20:05:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/hugetlb: avoid recursive i_mmap_rwsem in PMD sharing
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Li Zhe <lizhe.67@bytedance.com>,
 "Jose A. Perez de Azpillaga" <azpijr@gmail.com>, akpm@linux-foundation.org,
 muchun.song@linux.dev, osalvador@suse.de, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260930064308.58159-1-lizhe.67@bytedance.com>
 <arzVaC2IYkqSb0_U@gmail.com>
 <9a7c026e-f5f2-40e0-84aa-919c988cc136@bytedance.com>
 <2b4571c5-8e51-4c91-9d88-11929f200875@kernel.org> <asjVUa6XBZ8ti-0_@gremlin>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <asjVUa6XBZ8ti-0_@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 78E56180003
X-Rspam-User: 
X-Stat-Signature: 13gp7arm8okh4cxwd1ozed8kh9eaaae9
X-HE-Tag: 1791569121-466939
X-HE-Meta: U2FsdGVkX19EHN5E/dxFSHIxIOJYwyqFrJRZSi8k+En8QR43mciyTBRAq1FSU1UpjLxiM/FROO9Wax0zDl/3zmrubO6LVNHPGn/uFh2l9y6egdqSpTWNu4Lb7xqgJEJ1+1fqCB3goQ1+PQrBcrS3IoeTuR/lBy2aASup0AQLYknWEL7xTj+i1En/0TneDztvZWf0+0Yyb8gMVoCExurNmxgRY8Ac/Q8HdAEd+nyXRdmG3gqF/GNjarGVGTCAFnEs6Pe1Ak2/Pqmc5KqSvC46sTFkjcm892KHMex1TsUld4NAg3SDWVyTPrJi8dMdfwPLEsy2hmVBNGLULaAeVzWQfKzbdc9vvN+WZ0ac7LiGT0aE+j+xBgLorjXawx8KsJEGHMrpi0XI9c95mvsoiFDhdSdnyGVdKT/Dee9XEI6eGRQ6LRZc2L7yl/d50pD3vQ/mjjycswdzcPu+Mq41F25g4WRRBjahwkvkmZwPZ/egVy2pjV4AkCEpT4yHnByuxoTpJPgdLueOyHVp4y9FEpMfWhWyQ7sHIfUXsC1FcvsPxw9In7vFD3e/M2xWJoWn6y9YVuwr1SWqblk1EjCpQjdlugm/f0wwGonBPfgDQZsWvkfF4CltRoYf3LILsrkyFqYf3GS8tpZchICCafHnotZwBloijwIajBrChkqK+krfTt+5i5a22sxk7fNv0nJhEmcCFJzvF2p71cO6iIW5X/IKLOC/h34TXyWaXCNiOWyjziXAd+t4RfUqgoo0+lzqBOG+uKZOxXCEZuYWuwpa0ork940BgcBkNHV54CBWjtusfdmccecNvBrVooPImGhjtG+d7vBW6TQBzzIWK/caLxBFcnmtYqwlMEdVIMXA9RyBMidH4b52yjcXdmQkhRLLXtn4ZDV2L29vcTK46IjE3Zo/JDA3jooes3NxfYu7D4TV6h+yjHmWFaVOGswEkQ1hYKJSLgevEwVbqkUs2jC+vzk
 oE70c7Aq
 JC31XAkW3e4RZQoyYfbLjeGeQDCSzYlAAwkpYwkb++o8nzcpuqc5mTYGRLo0HbYGMQmC3cZx/vgwAQ1Zr3iYd6a0uVKQKQAHvP3hpifl4ihSZbBqlxxz2NNyzOdGSPZoPPo1kBrNsOHUKiny2cIqH1qLY+UV5NfEjUBHZ3bclCnaAPwbZU4YEBCfnfziIhUkVlVZ0UGzd9KznbhOrSAslx6q5anYT538RY8evhS+7sZhZ+PCqt7uGOmui3PdJOwXLFZTzCr/C2wJ6a5UfUJh8/Z4k1knMOhY0SZVadazIhRhb20fRLeJfzhCXMUZEaPVzxqS7/g5sp2GHk9w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/9/26 13:52, Lorenzo Stoakes (ARM) wrote:
> On Mon, Oct 05, 2026 at 11:25:01AM +0200, David Hildenbrand (Arm) wrote:
>>> David mentioned that Oscar was planning to send a proper fix for this
>>> issue, so I will wait for that patch instead of moving forward with this
>>> trylock fallback approach.
>> @Lorenzo, if Oscar is too busy, I guess we can paste the overall idea for the
>> fix here as well (publicly)?
> 
> Yeah I don't see why not! I don't think there's anything that needs to be
> private here.

Li, see below, can you work with the below?


----8<----
From 9e1c0676ea6c9cbcabf91cd8badf81a9d88fd3ef Mon Sep 17 00:00:00 2001
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Wed, 29 Jul 2026 18:33:08 +0100
Subject: [PATCH] fix

---
 mm/hugetlb.c | 103 +++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 79 insertions(+), 24 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index e93c4d2456aa..88ff2c4ad483 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5077,6 +5077,79 @@ static void move_huge_pte(struct vm_area_struct *vma, unsigned long old_addr,
 	spin_unlock(dst_ptl);
 }

+/* Returns last address processed */
+static unsigned long prealloc_or_move_page_tables(struct vm_area_struct *vma,
+		struct vm_area_struct *new_vma, unsigned long old_addr,
+		unsigned long new_addr, unsigned long len, unsigned long sz,
+		unsigned long last_addr_mask, struct mmu_gather *tlb,
+		bool is_prealloc)
+{
+	unsigned long old_end = old_addr + len;
+	struct hstate *h = hstate_vma(vma);
+	struct mm_struct *mm = vma->vm_mm;
+	pte_t *src_pte, *dst_pte;
+
+	hugetlb_vma_assert_locked(vma);
+
+	for (; old_addr < old_end; old_addr += sz, new_addr += sz) {
+		src_pte = hugetlb_walk(vma, old_addr, sz);
+		if (!src_pte) {
+			old_addr |= last_addr_mask;
+			new_addr |= last_addr_mask;
+			continue;
+		}
+		if (huge_pte_none(huge_ptep_get(mm, old_addr, src_pte)))
+			continue;
+
+		if (is_prealloc) {
+			if (!huge_pte_alloc(mm, new_vma, new_addr, sz))
+				break;
+			continue;
+		}
+
+		if (huge_pmd_unshare(tlb, vma, old_addr, src_pte)) {
+			old_addr |= last_addr_mask;
+			new_addr |= last_addr_mask;
+			continue;
+		}
+
+		dst_pte = hugetlb_walk(new_vma, new_addr, sz);
+		if (!dst_pte)
+			break;
+
+		move_huge_pte(vma, old_addr, new_addr, src_pte, dst_pte, sz);
+		tlb_remove_huge_tlb_entry(h, tlb, src_pte, old_addr);
+	}
+
+	return old_addr;
+}
+
+/* Returns true if preallocation succeeded across range, otherwise false. */
+static bool prealloc_hugetlb_page_tables(struct vm_area_struct *vma,
+		struct vm_area_struct *new_vma, unsigned long old_addr,
+		unsigned long new_addr, unsigned long len, unsigned long sz,
+		unsigned long last_addr_mask)
+{
+	unsigned long old_end = old_addr + len;
+	unsigned long addr_end;
+
+	addr_end = prealloc_or_move_page_tables(vma, new_vma, old_addr, new_addr,
+			len, sz, last_addr_mask, NULL, /*is_prealloc=*/true);
+
+	return addr_end >= old_end;
+}
+
+/* Returns last processed address. */
+static unsigned long __move_hugetlb_page_tables(struct vm_area_struct *vma,
+		struct vm_area_struct *new_vma, unsigned long old_addr,
+		unsigned long new_addr, unsigned long len, unsigned long sz,
+		unsigned long last_addr_mask, struct mmu_gather *tlb)
+{
+	i_mmap_assert_write_locked(vma->vm_file->f_mapping);
+	return prealloc_or_move_page_tables(vma, new_vma, old_addr, new_addr,
+			len, sz, last_addr_mask, tlb, /*is_prealloc=*/false);
+}
+
 int move_hugetlb_page_tables(struct vm_area_struct *vma,
 			     struct vm_area_struct *new_vma,
 			     unsigned long old_addr, unsigned long new_addr,
@@ -5088,9 +5161,9 @@ int move_hugetlb_page_tables(struct vm_area_struct *vma,
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long old_end = old_addr + len;
 	unsigned long last_addr_mask;
-	pte_t *src_pte, *dst_pte;
 	struct mmu_notifier_range range;
 	struct mmu_gather tlb;
+	bool preallocated;

 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, old_addr,
 				old_end);
@@ -5106,30 +5179,12 @@ int move_hugetlb_page_tables(struct vm_area_struct *vma,
 	last_addr_mask = hugetlb_mask_last_page(h);
 	/* Prevent race with file truncation */
 	hugetlb_vma_lock_write(vma);
+	preallocated = prealloc_hugetlb_page_tables(vma, new_vma, old_addr,
+			new_addr, len, sz, last_addr_mask);
 	i_mmap_lock_write(mapping);
-	for (; old_addr < old_end; old_addr += sz, new_addr += sz) {
-		src_pte = hugetlb_walk(vma, old_addr, sz);
-		if (!src_pte) {
-			old_addr |= last_addr_mask;
-			new_addr |= last_addr_mask;
-			continue;
-		}
-		if (huge_pte_none(huge_ptep_get(mm, old_addr, src_pte)))
-			continue;
-
-		if (huge_pmd_unshare(&tlb, vma, old_addr, src_pte)) {
-			old_addr |= last_addr_mask;
-			new_addr |= last_addr_mask;
-			continue;
-		}
-
-		dst_pte = huge_pte_alloc(mm, new_vma, new_addr, sz);
-		if (!dst_pte)
-			break;
-
-		move_huge_pte(vma, old_addr, new_addr, src_pte, dst_pte, sz);
-		tlb_remove_huge_tlb_entry(h, &tlb, src_pte, old_addr);
-	}
+	if (preallocated)
+		old_addr = __move_hugetlb_page_tables(vma, new_vma, old_addr,
+			new_addr, len, sz, last_addr_mask, &tlb);

 	tlb_flush_mmu_tlbonly(&tlb);
 	huge_pmd_unshare_flush(&tlb, vma);
--
2.55.0

-- 
Cheers,

David

