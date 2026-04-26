Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0DC0FF885E
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 05:29:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 899B46B008A; Sun, 26 Apr 2026 01:29:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 848DE6B008C; Sun, 26 Apr 2026 01:29:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 737446B0092; Sun, 26 Apr 2026 01:29:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 502006B008A
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 01:29:08 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F3F4CA051E
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 05:29:07 +0000 (UTC)
X-FDA: 84699578334.29.D65D8D9
Received: from out162-62-57-210.mail.qq.com (out162-62-57-210.mail.qq.com [162.62.57.210])
	by imf27.hostedemail.com (Postfix) with ESMTP id 406BF40003
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 05:29:04 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=tmOPdLTa;
	spf=pass (imf27.hostedemail.com: domain of fujunjie1@qq.com designates 162.62.57.210 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777181346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+YpIY0t3be6D2t4Rt7v+pAtsM8KQj8LPg+CNst48tRo=;
	b=1vcsymIC6isBSqZDoKuF9z+UgMr4uVQLxzI88+Ma6pELBHm20X36rTUQlSDvAyPp34kJV3
	fM7UUPa7uvqSx6GXlem75iUlMM/27yJx6rtkVPYDOH43b9IsQu76WXdlfFQnB2TgvCM7sF
	Wyb7pjXroFSFsuTsehYyeBJ/L9uGYhs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=tmOPdLTa;
	spf=pass (imf27.hostedemail.com: domain of fujunjie1@qq.com designates 162.62.57.210 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777181346; a=rsa-sha256;
	cv=none;
	b=7oPV2TPRkbhLx8v+tO8dv1ia085RiFYxMm4f+KBgqp2kvN0Tzd92XBTMthgAwRtymgu1x5
	KuLyGz341MmYaZvxXEqqbWRhvQQ5gPLsWVaVQF8RKlW0N708LIR+9A1V/t/JE3rY6neCC3
	ZSmg1X3khLxXjVs4xc5BMR0yjR+z6L8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1777181341; bh=+YpIY0t3be6D2t4Rt7v+pAtsM8KQj8LPg+CNst48tRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tmOPdLTa6lFWNjuecWieY8Ymr4qnDNwpBJ0j78k5l95CnxL9NFAKZFroHRydyBN65
	 RA8rwyC8UwD2T+dgoeqwUwgBdmlbAWfkW9/xz7gK+dtPQwh42rey4UxHWLDfRGpR+k
	 hQILAi60AVo7CM9HQXOVICe+8Pcc1QHr126Q78V0=
Received: from node68.. ([166.111.236.25])
	by newxmesmtplogicsvrszb51-0.qq.com (NewEsmtp) with SMTP
	id 7391CC41; Sun, 26 Apr 2026 13:28:57 +0800
X-QQ-mid: xmsmtpt1777181339tljcmz0ay
Message-ID: <tencent_89E6313DC046746E8A2CF2B8D29EA9158709@qq.com>
X-QQ-XMAILINFO: M1rD3f8svNznnYPrAKQcCP4esB0htCNVZNLr3LLptC7SoeL00Uc9SUYw9vUmEu
	 DAei1yAQbIxZ6bdEvwO6NLrLlP9J2UX68VTegw9mGTAUF9CM7J4uZe9Kc5K8Y4dzI0Pb7uYPgVrg
	 9UAv2FmALkFKdumlzs30SAR7XL3L+NCw07qxALfwFezF7b4d6AggZwWl8jvfdD15ra8TUpvvVaZ5
	 uJAVF/LNR2g8rx4K7uqVJXQVa4EMakksIhOiyxGkG7e/oeEmSoSr359JXiVraC4eBE8kqxjW0bAh
	 FmMDi+3ZjyQLj771W/vxAaXhTOiJakHc+hTyL9wGXjTtpfEKt2dihvtJHQC/IZEZXOinEOBSBPUf
	 Q8Vt5MWlYvjeV04OagRzhUK0Lnl46GB1YmnalwPnrllCE+Y7M+L8D8/snwzbyHVO0SIDQVODZfpE
	 9juqjkSCWCOyjhGAbWAZ1hJT+ZZLjhgg3hgCkmtd465EEBE/mKAgP4HRlPjej13Z4KfNkpgfT5tu
	 wsit8e3vpmCKc91175eN0Y+j6VqKYN3mpJRWNfGiznp3Hq2tcjCYxPIecnd1NjTrq5XfpiYm7YT9
	 iAnetezSfDTNnMtwHwUn7OZlhptZjnu+PB5o7jafNycXrGqeM3jKNAD+qmQgNe4Mf3sLKPcDJvKO
	 DcsbRYWTMOeUMBgKPMpZv9vJduKJpyjOFquk9hdH8xmKx64KbK5ZQxEBRI5L+T+c7GB/YITGeDiq
	 Bdb38vnST9IT1sSUdG6sAKuPjQd+uoa+cYG2eDVIUONpqxPXJI2Jf7N3UYy5zdQO5O1iI97YLsy4
	 gZPiyOsxoXwlxSoM+XQShr75Z9t/akFqmzpAcOIkmsT4htychsLMVPitfvC8qRy9AAoICD0vAf/a
	 hkh9Cs4iUeSQHd+SSeGVd+wohkYcLGeHX6xiJ3pYbS4Cd/IGP2Axocx1DFkp2wtuOnNkMtYimZfc
	 Ixen4/C8WKOP9Hlh4TMsQdu8WIzt5u++ws8NnDwh7zvx1xRijPtdPHN0twIB3EF6pGMHzwMvKwin
	 ReZcAeVLttGAqAnLOs
X-QQ-XMRINFO: OWPUhxQsoeAVwkVaQIEGSKwwgKCxK/fD5g==
From: fujunjie <fujunjie1@qq.com>
To: akpm@linux-foundation.org,
	urezki@gmail.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	fujunjie <fujunjie1@qq.com>
Subject: [RFC PATCH 1/1] mm/vmalloc: reclaim tail resources on large vrealloc() shrink
Date: Sun, 26 Apr 2026 05:28:57 +0000
X-OQ-MSGID: <46985aa32b734532c3a24f82afce68feab4b3f43.1777181243.git.fujunjie1@qq.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1777181243.git.fujunjie1@qq.com>
References: <cover.1777181243.git.fujunjie1@qq.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: b6fyt6o6snf7x9he477ahne4scpycuti
X-Rspamd-Queue-Id: 406BF40003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777181344-931589
X-HE-Meta: U2FsdGVkX1+ZY1IZJVCqHTkKQq2rX2WgKpyTyICEqDye5exxOJivpQEEO4u7vfMdzgTEQq7reCKJkVrSNT8nxb/8JfSDYMnHb/kc0AK68lIm0TNAkRAMgC5OAjTqMWg4wHhMpozFsDFQracyI5X0yo4eJ2tt3W3zJdHkiWBckMadZRd10vRWrhuE+MzlHPxff1fbCA9madFSg0bj1V5SxptSGDHzGdRaEdOdtVay1DKlN+2XA0PhKtWuMOwjhXPRgqW8ebHwlcErrH/+NB7cPDe04BLBznvJmX7iR8LVbSvSPbyXrOhSgWLnZ+RHqyl+0OZn0XvXSFIg3JhoEWSxEmj/gxmnVhuAxgh3gViDRwsb3JNPr4fVBXOYVnKX5duhVPic4HF25HG1ROrhdpov1QHUdr1NAoqHMDQHwwz12K7o3EoaPJNomghnKHIHc6Cu/20nxNC3oeMKaZOHa/hQtdBs/+jPVZI5rwTBMYD3Cct9uatHQX0W9MGrPuQFyO120cGiHQ8Q+CNaC5Zp2iYliB4ccc1jJiOtouI/kgjVabyfWhE8MJZONZzSRGoiZFF3IO+f6blfNz4T+VD/BtFioSI6r+yrcnIoxKOIzpVmbuj36QKeZ781U6eAT3U1DDvB6jb3LGhFlxOvu8QQjhOr4rSCIXtDeVqAIkZHYha/Z2bS2L76zUK1mkaJ20kr6KdmoSztPBFM64mu1SIgEpLqR9Ey/FNdSdLmHSBEl6zLe6ZPuHnWfhbSA9gQFLzSXKaifJJXzdMSOh9NjnI+mG6V32FKpAIZio166bxpBCpn6v26F7W2xrAz1PzHoqpW1lrLB3o/NYYMXEG0yZItVqVBInYrRpvqbdygbslW6Sdlqn45YW8XATHs0oMJYYf6UA7Vhuw4UhRhUCybniC1Qvzn0gCyer6CS4s3jHysvBC37Icfij/QQNJ8+0+vbVm1HL2ZtE6UevbwEks48P5M7VW
 YZ+tzXbw
 5oqyMeJSfrMxF0kGn2kEtBdvHYz5Pctp/u41TAPQ1F3RsBvSQ2nvUotwrbOSQS4wQ1RWNdkSC3YGxNI/VGr4oRcBGVPvVOM8SxpqxgpznEFG+EZPnXVSD2u67JFs26C+q3HOr14QVk5rOWYFLufc9r7Ec+OTpGdnJ/+9C7V3xSXWj9l8p5/2KUcS9WMG0KZN1sdQPMAZCn10fUGdnxvaofCyvWL7isjrZ39WOcc5/9SXKGEU+fyLa36J9Vw6lDp2kChqi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vrealloc() currently preserves contents correctly when shrinking a
vmalloc-backed allocation, but it does not reclaim the unused tail
resources. The requested size becomes smaller while the tail pages,
page table mappings, and busy vmap_area range can remain largely intact.

For large shrink operations, this can retain a substantial amount of
vmalloc-backed memory even though the logical object has already become
much smaller.

Add a conservative shrink helper for simple VM_ALLOC areas with
page_order == 0. When the retained mapped waste is at least PMD_SIZE,
unmap the tail range, free the tail pages, shrink the busy vmap_area,
and return the freed tail area to the lazy free path.

Keep the first implementation intentionally narrow:

- ordinary VM_ALLOC only
- no huge vmalloc objects
- skip more complex vmalloc object types
- no attempt to tune the threshold to any specific workload

This is meant to close a resource retention gap in explicit shrink
operations, not to act as a general reclaim mechanism.

Signed-off-by: fujunjie <fujunjie1@qq.com>
---
 mm/vmalloc.c | 105 ++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 100 insertions(+), 5 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index aa08651ec0df6..ecdfe2028612c 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -4260,6 +4260,99 @@ void *vzalloc_node_noprof(unsigned long size, int node)
 }
 EXPORT_SYMBOL(vzalloc_node_noprof);
 
+static bool vrealloc_should_shrink_vm_area(struct vm_struct *vm,
+					   unsigned long old_mapped,
+					   unsigned long new_mapped)
+{
+	if (!(vm->flags & VM_ALLOC))
+		return false;
+
+	if (vm->flags & (VM_IOREMAP | VM_MAP | VM_USERMAP | VM_DMA_COHERENT |
+			 VM_NO_GUARD | VM_FLUSH_RESET_PERMS | VM_MAP_PUT_PAGES |
+			 VM_SPARSE))
+		return false;
+
+	if (vm_area_page_order(vm))
+		return false;
+
+	if (old_mapped <= new_mapped)
+		return false;
+
+	return old_mapped - new_mapped >= PMD_SIZE;
+}
+
+static bool vrealloc_shrink_vm_area(struct vm_struct *vm, size_t new_size,
+				    unsigned long old_mapped)
+{
+	struct vmap_area *va, *tail_va;
+	struct vmap_node *vn;
+	unsigned long addr = (unsigned long)vm->addr;
+	unsigned long old_total = vm->size;
+	unsigned long new_mapped = PAGE_ALIGN(new_size);
+	unsigned long new_total = new_mapped + PAGE_SIZE;
+	unsigned long freed_start = addr + new_mapped;
+	unsigned long freed_end = addr + old_mapped;
+	unsigned long tail_start = addr + new_total;
+	unsigned int old_nr_pages = vm->nr_pages;
+	unsigned int new_nr_pages = new_mapped >> PAGE_SHIFT;
+	int index;
+
+	if (!vrealloc_should_shrink_vm_area(vm, old_mapped, new_mapped))
+		return false;
+
+	if (WARN_ON_ONCE(old_total < new_total))
+		return false;
+
+	if (WARN_ON_ONCE(old_nr_pages != old_mapped >> PAGE_SHIFT))
+		return false;
+
+	tail_va = kmem_cache_zalloc(vmap_area_cachep, GFP_KERNEL);
+	if (!tail_va)
+		return false;
+
+	INIT_LIST_HEAD(&tail_va->list);
+	RB_CLEAR_NODE(&tail_va->rb_node);
+
+	vn = addr_to_node(addr);
+
+	spin_lock(&vn->busy.lock);
+	va = __find_vmap_area(addr, &vn->busy.root);
+	if (!va || va->vm != vm || va->va_start != addr ||
+	    va->va_end != addr + old_total) {
+		spin_unlock(&vn->busy.lock);
+		kmem_cache_free(vmap_area_cachep, tail_va);
+		return false;
+	}
+
+	va->va_end = tail_start;
+	vm->size = new_total;
+	vm->nr_pages = new_nr_pages;
+
+	tail_va->va_start = tail_start;
+	tail_va->va_end = addr + old_total;
+	tail_va->flags = va->flags;
+	spin_unlock(&vn->busy.lock);
+
+	debug_check_no_locks_freed((void *)freed_start, freed_end - freed_start);
+	debug_check_no_obj_freed((void *)freed_start, freed_end - freed_start);
+	kmemleak_free_part((void *)freed_start, freed_end - freed_start);
+
+	vunmap_range(freed_start, freed_end);
+
+	for (index = new_nr_pages; index < old_nr_pages; index++) {
+		struct page *page = vm->pages[index];
+
+		BUG_ON(!page);
+		mod_lruvec_page_state(page, NR_VMALLOC, -1);
+		__free_page(page);
+		vm->pages[index] = NULL;
+		cond_resched();
+	}
+
+	free_vmap_area_noflush(tail_va);
+	return true;
+}
+
 /**
  * vrealloc_node_align - reallocate virtually contiguous memory; contents
  * remain unchanged
@@ -4299,6 +4392,7 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
 	struct vm_struct *vm = NULL;
 	size_t alloced_size = 0;
 	size_t old_size = 0;
+	bool shrunk = false;
 	void *n;
 
 	if (!size) {
@@ -4326,16 +4420,17 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
 			goto need_realloc;
 	}
 
-	/*
-	 * TODO: Shrink the vm_area, i.e. unmap and free unused pages. What
-	 * would be a good heuristic for when to shrink the vm_area?
-	 */
 	if (size <= old_size) {
 		/* Zero out "freed" memory, potentially for future realloc. */
 		if (want_init_on_free() || want_init_on_alloc(flags))
 			memset((void *)p + size, 0, old_size - size);
-		vm->requested_size = size;
+
 		kasan_vrealloc(p, old_size, size);
+		if (size < old_size)
+			shrunk = vrealloc_shrink_vm_area(vm, size, alloced_size);
+		vm->requested_size = size;
+		if (shrunk)
+			alloced_size = PAGE_ALIGN(size);
 		return (void *)p;
 	}
 
-- 
2.34.1


