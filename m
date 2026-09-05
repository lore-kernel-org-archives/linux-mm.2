Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6BEFC624DB
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 14:02:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2F2D6B0096; Sat,  5 Sep 2026 10:02:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C06EA6B0098; Sat,  5 Sep 2026 10:02:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF5AA6B0099; Sat,  5 Sep 2026 10:02:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8D2846B0096
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 10:02:25 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0818140385
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 14:02:25 +0000 (UTC)
X-FDA: 85179873450.21.64E4897
Received: from mail-wr2-f10.google.com (mail-wr2-f10.google.com [74.125.225.74])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3481A120011
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 14:02:23 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=otVQ54sC;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of christosskarlos.kernel@gmail.com designates 74.125.225.74 as permitted sender) smtp.mailfrom=christosskarlos.kernel@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788616943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lAVqgBHrMqJB3BSpfl35IypQuNVtfirpz6pazsL02KQ=;
	b=AZ09v/8C10HEZi4jwhW9ZX0UWgNwg42ntOuCQS2IdJtoB+ewdmDJqRvYUYbYlqD9q8LVso
	qzYnUy9amGindi7BDsT3aqGe2wi2Q85vxl1P/JQyRnKURobHYK01beP8q1+uRag5tNnTgC
	qs8Yz4kY9j2hSHQm5uTXg96k4ujDp/o=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=otVQ54sC;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of christosskarlos.kernel@gmail.com designates 74.125.225.74 as permitted sender) smtp.mailfrom=christosskarlos.kernel@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788616943;
	b=6/XUmEDIOW4ncq9v9MoHHQ5EpBau23qoDEajTP0lAZj07O/333eoJ6qztBH2DOnrFYCVXv
	OEfsZMWBnuDI2jxI2t1hD5j9BuraKqI7ERS89oRSNt1O3WKv0NQIuOYpC2Q3f2X3fLqOEM
	cQ9+D7jRLzedbBwtSuirT1RqoCJonkY=
Received: by mail-wr2-f10.google.com with SMTP id ffacd0b85a97d-484372811e5so610513f8f.0
        for <linux-mm@kvack.org>; Sat, 05 Sep 2026 07:02:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788616941; x=1789221741; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lAVqgBHrMqJB3BSpfl35IypQuNVtfirpz6pazsL02KQ=;
        b=otVQ54sCwr3qpykPL1LtIi4HbcqZhKoBtl96hZeoVr4TkYKswtt5onPK/R2gSJKi1F
         G5WQEm2h17sfd9rRhXQAih17GK+3yjCX7WDIrF7OGCr8ZkDcRvN3q26SgMnCEFqDd0Ml
         DhvYkCMjUL8K9gPK14nMDQgQG9inKEVb4pQMvxMDbB7yVYJOe/1oPBEy27VZCe/Xk0eN
         WM+xBk3XsyXA1Aioh1XExXezdF+2UPoEC1qMlpUNoro7MtfikvmuQav8SNGn4G7/LyPT
         qIIpIKNLCaH4Cv8k/4OJADwiqf/stmXtnWyF3u2Z9CdgjUeOcmkZbcIUqNMnUoZad83c
         P28w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788616941; x=1789221741;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lAVqgBHrMqJB3BSpfl35IypQuNVtfirpz6pazsL02KQ=;
        b=SFEAwDTl19B9Oo9Fj/5D+HWZEmLsizV+tW/gwziNAkL1ykWH+qq3XAfsZHwem1CWpI
         Fj7sHX1yPfMuYby4BMKHrQ57Y5n2t6558h/oXnJJELtpbPHA7J4G8xVS3TSgQa25RO3K
         HhjfYERJIg8yr/gZ12CG+ZpD0/MAmW2yvGyqmM1LZ3SlUL2dsoETGebFNsEnocp6x3qs
         nv0p8yEyrO+8qT4ssZsCJoBLiFD91+5kpx8GgG327C5Vp151G6x0BJmomKuKvwZGJnyV
         VP59D9/YqkUHSJyc6SGt4y3d/03mFKGQU+lwMPuFjv9aLmt5hXDSwbqSNz2eTfSYoQZn
         bwRQ==
X-Forwarded-Encrypted: i=1; AKwUvBywQNH/ADT9NNDUOwBBsrFGqJurPUQ2AEk120CBH4ZUT4F3Z7qUUhvsmeQhRamZPGHLJfWtiWVBXQ==@kvack.org
X-Gm-Message-State: AFuF++lvwgrycyCIUOlgpNiOXR4VY2R1yAa7KQTQ+9H96ibGJtbsTgF9
	Gp9smTzl69exe8vC3FDN5nTBECjFL0RrQSYlXwNPeyeGK8DX9vkfvadA
X-Gm-Gg: AYBFou3KvxjO+qoh7pOfFvc2VVtcc8Ij9RmsTGEZoXCuzBwDu0xUiLcAncRFjvKgc+3
	WgcDU+vda0e6L+7XFwT2tdqjZClZSpwWTbQbdVx5zIAvGAD+J9iAoX7Oepp7yyLqtJ6HvDkliR9
	ymbtWdZGkgatWFZiWijpgTcgBw98Nweu0YKPG9YMJeeR5IdfaSiD9Q2xMOkLtF5BH4MnqNWM0Vf
	jfNFyoyGisELMQVjiLmU5z1H4q1TIRBgsClKvM1F4s4qT8/KF3wlSmqiv9pVpigO2TR/h5ozLnu
	R/Zc35c5+SswIpIxf/MZy3vH75/FNIR6PeMSBYUXUUDy6UqKeymsc45VtBLC8DdPbqztLVdKEYh
	pPycUfP76MvQB8HKrajWSfvMCws7VV6gK0xVN55+3bD9bR3MqNmntENdbT5rmOuGrs3estceUg6
	Ml2fHTWK3A+ZCEfjw5nsQY6570o8154LqSgj7g34F4PLmbBtfGLS1cdfaTfcQUQyMe5RljAXxS6
	ORrwY5l6yVjxNM0gbsDQvxK0OD8mw==
X-Received: by 2002:a05:600c:4f83:b0:49d:91:274 with SMTP id 5b1f17b1804b1-49d00910374mr51848155e9.10.1788616941497;
        Sat, 05 Sep 2026 07:02:21 -0700 (PDT)
Received: from outlook.com ([2a02:587:6022:4b00:84ac:4417:9f37:a496])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cf755c22esm149866765e9.0.2026.09.05.07.02.19
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 05 Sep 2026 07:02:21 -0700 (PDT)
From: Christos Skarlos <christosskarlos.kernel@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	muchun.song@linux.dev,
	osalvador@suse.de,
	ljs@kernel.org,
	hannes@cmpxchg.org
Cc: ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	mhocko@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Christos Skarlos <christosskarlos.kernel@gmail.com>
Subject: [PATCH 3/3] mm/hugetlb: fix various coding style warnings.
Date: Sat,  5 Sep 2026 17:01:40 +0300
Message-ID: <20260905140140.60792-5-christosskarlos.kernel@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260905140140.60792-1-christosskarlos.kernel@gmail.com>
References: <20260905140140.60792-1-christosskarlos.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3481A120011
X-Stat-Signature: axd6p1kwsws3i1bx46nf4h6c3mrzqnf3
X-Rspam-User: 
X-HE-Tag: 1788616943-307513
X-HE-Meta: U2FsdGVkX1+Sdc2VY1uuSa0WGFm1kwEZL3ontsDHTEBwhQR6CeB49/lDJB+eXDa3M5Z0d6jo8QNoTEMkCTsNx5zIlDCjiP3l9IWpkYT1AMh5KvG7+KpXoCe6ZAODxg7C1HV5RFwFovV7AFD1G4BuR3p7N6bEfyf8X5YNn/gk31b0YPFW5M6SnievPvkTpj+cTu53C67LaMFZ/+PKwi/gUa96VFR4gCob1/Oc30lQUXXPkMSt/MG01L1DJZW0iqXVlDYwdYqrIZMtVH71DMB0rXsbRv3ii8hbh9cNMuITzXyePa/oz4daODOifZjAqATs8STJuIivCBgp4TIoJtHcw1rmyDzKbUHVkfP8ysQ/fpwwzJ6qTg0Npfu/cyn3WUVCzHDKbtGVb3IIGfjfMA59W6MKbfCI6tTJiOILnQ1AEGHqvCcXqtzGOFZ8tdxkqlsrvr3t1AxK5akka+hNrETIyRJqMi1vwwX89DYTHJI0dAw/LBC+Hp+y6vpKb3Z39qmX3btIn8/Ezz1wuhKTJe/xMZ8eVaYTmqyxC9dV8Eks0evZ/O3UvjOh5snPeylLaKtJLgYBmOd0GYXv2VW9wyDpy8o0ohmxEK93N4JCDHSE+ed7mu+ZtS/pEmscbrzdl+gYe4TUiJgQFbGGhuUdCxDyi80jaZPug+Z3GFvP22aErGKNTUrDqg3zY29aoxJat/Nl+/oHIuM6ZW2I+H+ugf9ZGoX2HEqgjKxI0UwTWtK/lfgTkwpuobPlCMxqd4yAh4pmPlGiTFw20Lm4MixcfYRPYkoOUdYxwpYB1svVRUHvQk8zH3+gn1tjefTVC/kEQUR0NRnyoREFKYP6AMzVE+wkndy12wCdaFkm3wUCbC/RrjSiG+v3IG6sx9NEd3BcUASNH0YWZaiM2mmQpOMQrIH9YvsZod2EkVbLMBdtWA35WQbSkhXJG+3dGcO/+qof7fXFE1P7wxaQRDwEopvIZar
 8vAFVjef
 D0nmEf0m934q8Wo4WdZWkZexI7h3UCT6b301HJ+NYN+v6OHVOOx3s3HRy5/P9fQjSOY166t3E93F6SyW9JqeZxqXkYAhM2sHpQJuPt37k6PxbgvqTb3B2mn0PGCQHzZhW3w8NV/JoDjFP/qfr6fUWubjnAKTLeHrz9Sgy3eGZkex+/ytEozTbryDzVmKnoGaoRlw3kVo4AQ2dCt8789FKGs1MrLv2OB71H3iMZBcrI2RIZZ/ZszzUiQhG1tYFej/FSty6seGfJ4Gsy8AAfBURZ3XuX5mK09A9oITKtQXDqVKyZCKGoHe7EdbQA04x83lFA2ynIEIlOPd0cQ+eom3G9FCcKRZ4R345qwHsGp6iiBA+6BxXWEMZX0UX4J61vsR37VuRiZ0eFR+uns+1E+gHW/y5otzOVgvWBJAUCb6N1QW7xIUEjBAVdbnK9dt9j1Hx5iFCLvy9Kp5EytDleZbIUFHCmFnwtnBUDaI+1SC+XMZXE2vGGfWy7nG1OA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Resolve coding style issues flagged by the checkpatch.pl script. Specifically:
- Fix block comment formatting to keep tailing '*/' on a separate line.
- Add missing blank lines after variable declarations.
- Remove anecessary braces {} from single statement blocks.

No functional changes where introduced.

Signed-off-by: Christos Skarlos <christosskarlos.kernel@gmail.com>
---
 mm/hugetlb.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 4f6f58bf3db6..ec8e799e356e 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -145,7 +145,8 @@ static inline void unlock_or_release_subpool(struct hugepage_subpool *spool,
 
 	/* If no pages are used, and no other handles to the subpool
 	 * remain, give up any reservations based on minimum size and
-	 * free the subpool */
+	 * free the subpool
+	 */
 	spin_unlock_irqrestore(&spool->lock, irq_flags);
 
 	if (free_subpool) {
@@ -3700,6 +3701,7 @@ static void try_to_free_low(struct hstate *h, unsigned long count,
 	for_each_node_mask(i, *nodes_allowed) {
 		struct folio *folio, *next;
 		struct list_head *freel = &h->hugepage_freelists[i];
+
 		list_for_each_entry_safe(folio, next, freel, lru) {
 			if (count >= h->nr_huge_pages)
 				goto out;
@@ -3764,6 +3766,7 @@ static int set_max_huge_pages(struct hstate *h, unsigned long count, int nid,
 	unsigned long allocated;
 	struct folio *folio;
 	LIST_HEAD(page_list);
+
 	NODEMASK_ALLOC(nodemask_t, node_alloc_noretry, GFP_KERNEL);
 
 	/*
@@ -4188,9 +4191,9 @@ void __init hugetlb_add_hstate(unsigned int order)
 	struct hstate *h;
 	unsigned long i;
 
-	if (size_to_hstate(PAGE_SIZE << order)) {
+	if (size_to_hstate(PAGE_SIZE << order))
 		return;
-	}
+
 	BUG_ON(hugetlb_max_hstate >= HUGE_MAX_HSTATE);
 	BUG_ON(order < order_base_2(__NR_USED_SUBPAGE));
 	WARN_ON(order > MAX_FOLIO_ORDER);
@@ -4832,11 +4835,11 @@ static pte_t make_huge_pte(struct vm_area_struct *vma, struct folio *folio,
 	pte_t entry = folio_mk_pte(folio, vma->vm_page_prot);
 	unsigned int shift = huge_page_shift(hstate_vma(vma));
 
-	if (try_mkwrite && (vma->vm_flags & VM_WRITE)) {
+	if (try_mkwrite && (vma->vm_flags & VM_WRITE))
 		entry = pte_mkwrite_novma(pte_mkdirty(entry));
-	} else {
+	else
 		entry = pte_wrprotect(entry);
-	}
+
 	entry = pte_mkyoung(entry);
 	entry = arch_make_huge_pte(entry, shift, vma->vm_flags);
 
@@ -4919,6 +4922,7 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
 	last_addr_mask = hugetlb_mask_last_page(h);
 	for (addr = src_vma->vm_start; addr < src_vma->vm_end; addr += sz) {
 		spinlock_t *src_ptl, *dst_ptl;
+
 		src_pte = hugetlb_walk(src_vma, addr, sz);
 		if (!src_pte) {
 			addr |= last_addr_mask;
@@ -6321,6 +6325,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_pte,
 		folio = alloc_hugetlb_folio(dst_vma, dst_addr, false);
 		if (IS_ERR(folio)) {
 			pte_t *actual_pte = hugetlb_walk(dst_vma, dst_addr, PMD_SIZE);
+
 			if (actual_pte) {
 				ret = -EEXIST;
 				goto out;
-- 
2.55.0


