Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4ED7C79F8B
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 18:32:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 773026B0095; Sat,  5 Sep 2026 14:32:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74AE16B0096; Sat,  5 Sep 2026 14:32:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 612646B0098; Sat,  5 Sep 2026 14:32:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2490A6B0095
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 14:32:11 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AF45C14038A
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 18:32:10 +0000 (UTC)
X-FDA: 85180553220.12.6E717BC
Received: from mail-wm2-f7.google.com (mail-wm2-f7.google.com [74.125.225.135])
	by imf01.hostedemail.com (Postfix) with ESMTP id E491540003
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 18:32:08 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YDh0iavD;
	spf=pass (imf01.hostedemail.com: domain of christosskarlos.kernel@gmail.com designates 74.125.225.135 as permitted sender) smtp.mailfrom=christosskarlos.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788633128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GQhtRiM/OzSt8Zhsf9bNwGzEPuThkXQQtWQPWxIhnCk=;
	b=ioou+KUCyzLAID8PXjAqnytJIU7y7wvYghtY8jtF+2KBumpH7RZS9MKVU8zOYmVe8IsOKd
	nPvUad4vko17lSXSmm7vE1uqoq1ZDC2UbeUteWvpyNAsyjWNkEoBQHzsieCA/kzzrOcsDY
	JSy2S2CE5ozHGo2ayI6AISaAYyNuy0k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788633128;
	b=NzPuAVtBHFLQ3Co7pB0z1aflozDfYqWyKkWDI05umK2yq7lEqkVPQwyDdDnrRmT8eU4Wu6
	BR/N+Ol6m027fHb5AhSo2G1sY6DC/LcCxB9dpOcwmZFuqOj6WkIj6vnZy612jH/ZfD431W
	JfBzCcBZYlk1/hULK+f25pL4caB33Bw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YDh0iavD;
	spf=pass (imf01.hostedemail.com: domain of christosskarlos.kernel@gmail.com designates 74.125.225.135 as permitted sender) smtp.mailfrom=christosskarlos.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm2-f7.google.com with SMTP id 5b1f17b1804b1-49add2a23e5so8591595e9.1
        for <linux-mm@kvack.org>; Sat, 05 Sep 2026 11:32:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788633127; x=1789237927; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GQhtRiM/OzSt8Zhsf9bNwGzEPuThkXQQtWQPWxIhnCk=;
        b=YDh0iavDd86+ugk5bAmcPb3b+Hjam64jSIHDeRaAPUqpGv+QPv/4Ifc629P/JB0dDk
         Naz30hmeyQ33pemrn5x59J0lq/YD+sJGO23NIW3gWekjeTZDwJjHwFwLD29mC8NCg2g8
         7BetanfWl60tpm2m1jla0sdcFDIjqnQiS6MkI1GomvfRAQHC1cMTWc6ihQyY0K1zFHS/
         8+Kx/3VysJ22cwpwt++lzqCSyQL9wnq+kq+b1m5uEsCKl61SSkpoIEZr2x6OZwib72hF
         gtyPut4QY56Uu9RCrGw0y81/J2HDRtrgobEXwxp5JzrTYk6dgkGmX35r/U0lIYcZDV4I
         rIxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788633127; x=1789237927;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=GQhtRiM/OzSt8Zhsf9bNwGzEPuThkXQQtWQPWxIhnCk=;
        b=RN0UjK5W2qBqvvzXaH2rN8T5BiTrDYsn2GmMBswOKtUt0dGXr7rIaC4lpgCvM5plec
         6grvOnN1zUHQ3VuqeWHni/mNoPSVUvZocKuWNBEWYAEx/nkrGdHl2/jb4ibq+br/kHtW
         0IwyZeYdU+TqAQ4EY/Mx8HZTB0NzHjwy7IoeIN4cXnKF31qVoy3ju+Pkm2roI3NfVrJH
         61q5rrorjFrlrhgdZ4aC3uiBRnN4jIbw57tQNZ2IVKLfKFRZJ+OcmAVjfeqzsx3HnLWw
         YoSFkxpgE55xRSWn2PV2T7RPY3XnR7WAHwXiaEzQLxn+ZHmE51v+bRZCc68A57BJMr11
         xBJw==
X-Forwarded-Encrypted: i=1; AKwUvBwt6LyzHePXuXfNUvltVIIC/IjgA9BZHDAXOGAlRj5RUuDCd9TfrqrzUkPs/3iFelCn+QhAPpzRhQ==@kvack.org
X-Gm-Message-State: AFuF++mICmRoLy736m9mf+1xYnkRkiaqvFKuTmJRMfyE1f2GqAcoVUt8
	ny8qVyfxjp1Kns27cI6CtNis0pQXUeCTf9Fnk5YH7R4qq8y6Lc6L2vJV
X-Gm-Gg: AYBFou0rYvu4gOobMeMyrcBOmNs+jowMDdpi+5aLQCsNCvWfi7pZuXIPIE7Z1GQtuWW
	F3A2LPoInyGesBijbRrC3FSh+E/9Kr2YRbMrpFZV9p0xem3RNnZvjMA9qXnkyIuEhx58b5K3MI3
	zFai+KGGFj0azRARO1NmF6mXpCWbFZ8os/FROrBe79K5SQ+nc9ooOaF1JCbZ+Axx9OumsliEuT3
	J0lBIXOwYsbCQ3hDboVzs7v94ZabDj4YtgBxWV///XE542VrdsL2s28GeMybUzrpF0yad2pLDHI
	MxLMerphk3CisRWL6EClm269qxHeJNgjYiqA4zSwSZ9YehuUs9iwczyvgs4W0OmGKYawIMGpbLK
	MXXxs0zgh5XH1TySzYdAS7pt5xHq0fOcMdpbmoD/ttfRQXtHVwVNQgwVsOktDZXtLJAgnYyKlYH
	tkS6LCctqcugV8oEJ3m7myV95EVOKyxMFvCo7ijWOxC+ZUZ/2myd7/4XE6C7xSEv2W9xxbDL1cQ
	yvXEomUFOyU04x9dWAFY58PxWeB/w==
X-Received: by 2002:a05:600c:3b02:b0:49c:fa21:1c7d with SMTP id 5b1f17b1804b1-49cfa211d76mr120992185e9.18.1788633127562;
        Sat, 05 Sep 2026 11:32:07 -0700 (PDT)
Received: from outlook.com ([2a02:587:6022:4b00:84ac:4417:9f37:a496])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4858d2693e8sm13066670f8f.3.2026.09.05.11.32.04
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 05 Sep 2026 11:32:06 -0700 (PDT)
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
Subject: [PATCH v2 3/3] mm/hugetlb: fix various coding style warnings.
Date: Sat,  5 Sep 2026 21:31:35 +0300
Message-ID: <20260905183135.20993-4-christosskarlos.kernel@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260905183135.20993-1-christosskarlos.kernel@gmail.com>
References: <20260905183135.20993-1-christosskarlos.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E491540003
X-Stat-Signature: 5qe68yjdtkic94tu58mkk3btdf5fgdnz
X-HE-Tag: 1788633128-768606
X-HE-Meta: U2FsdGVkX1/etdE/8qasfHQb0TbVabsU5kmwxhPzucLm5mLWogvyKIOCbXRz6+p5bRKxCiRb65I7yZT2buc8Poj+pna8oSOx85poHTVK3Vo1zQUBOHxWuxO5PGwh9Sdo8CniczwS4MLt3A2S8gW5Vcpc1/uJn+O3KuEWdf08Hnh2hiBggXSE46+2mR5L/cZjXLL+0y6VpVeuUhO81dMrSHT6AqyO5SqA3Ge2b75zJmqZrT6LiARXgfUz2dUC77IHYOaIKUrV9OtXtEfowxzoryKs4xQnwIwqbKAVNn4VYgQt97lxTq5PFPNK/1mDTqAX1UKsUkRjesIYJr69prMkjora5E0gr65mA3LPLtpLHrOlXIuZXjreBDZr4C1crnwGkf+kfqA0KfQG+DRDt5NNuAfePFAobef9CaW5/h+4lMijA4mWx2kkLPX7aEY5DxQHHnPa6Ztl4FuEI4gSBa1s3P7qpY9Bc2avjUF0EcFQkQFwLUB09DAt9HxdG/H9XgOjUXyy4WU7BuOxIzbE1+ECiva7Z0/0tG0FlfFdGQ7uqLBfuPdZnAOJ9DNMyEiN15pTBM23yceJnlo/mi2Bcvby/NHTA6XHB8uS2C2HhhuKfSw225HkWD/9/RWdQHG2HP+zR/hwgXZlnIbSbKZIOcizm/HpfP7YSPxf/3gbO8sekH4UBAM4EAZdrFhKw8R96jMTn/TIo5+U0wBV7IeuFdD48kTr5HtjP3jkGrvC4ZCRV6BTwnUj/JCguh1rBM1h58QlztUcS2And7zzxzgsMR0FKo6fk23J5GlXSfXX9YVl2Kjomp22rSNdCCSYrilv7Uqr8cXRdQMjnxLcl78Dt1oGyZtl/YAUfIm/gGC6JZdKaVgt2uZIVwCP9+p2dfXuq8wtXYWoJTV5FRswAtUAG/zAz2NvTlcvH6KGy9POX6lkqdkmVfyKiwOWwU57PqvCEeTNO3bq/3vgysJ/66H7IkG
 Cmvebt2u
 aELJX+Q18ftjs1klmSCbBe/IQ7Lq7pNngq4mbnoKzO6Ml8OgP347n+oRAIGBncS0fSYZLI0JlkyHyZyuphdY4AOA3CDm24w89df20lG7Ap49E2lZaU/SeWwC/K4Vw/Q9ieTISXcbr4n6hbkL3aKjVavWwm+oAj8XohHkSXuGBKRLHbpygaW0/1JHIbyzCpqmVvWoG3qVASAcc/WnsluEe9hB9EnEc8BdpfoDspqcQg91eCPa45DFW5A3+KeOiMFmlrvsnEvz5nq/X8q2+W4zVYT74JQ5prcns/1UvyNcvI4tYCxRSdFyWz8KTCodLSmAw8VI4UgAMZ/heC6Dusj83aae22WPfGHAOfJFaNRZbk36iem9o1xQUJ9TsDX+z/AH/o/MHgN2JPGHbdoXegTIoZYt9slq2W5EY6gATt1S0H2C3m7w/clOEr/RJAQycplF8fYtFz+imIdem9gQSOnpXTVdianH3M+RlltPPt6Ng0DDT/yXRjzFXdlNkhA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Resolve coding style issues flagged by the checkpatch.pl script. Specifically:
- Fix block comment formatting to keep trailing '*/' on a separate line.
- Add missing blank lines after variable declarations.
- Remove unnecessary braces {} from single statement blocks.

No functional changes are introduced.

Signed-off-by: Christos Skarlos <christosskarlos.kernel@gmail.com>
---
 mm/hugetlb.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 4f6f58bf3db6..3b00e76332ac 100644
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
@@ -4188,9 +4190,9 @@ void __init hugetlb_add_hstate(unsigned int order)
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
@@ -4832,11 +4834,11 @@ static pte_t make_huge_pte(struct vm_area_struct *vma, struct folio *folio,
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
 
@@ -4919,6 +4921,7 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
 	last_addr_mask = hugetlb_mask_last_page(h);
 	for (addr = src_vma->vm_start; addr < src_vma->vm_end; addr += sz) {
 		spinlock_t *src_ptl, *dst_ptl;
+
 		src_pte = hugetlb_walk(src_vma, addr, sz);
 		if (!src_pte) {
 			addr |= last_addr_mask;
@@ -6321,6 +6324,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_pte,
 		folio = alloc_hugetlb_folio(dst_vma, dst_addr, false);
 		if (IS_ERR(folio)) {
 			pte_t *actual_pte = hugetlb_walk(dst_vma, dst_addr, PMD_SIZE);
+
 			if (actual_pte) {
 				ret = -EEXIST;
 				goto out;
-- 
2.55.0


