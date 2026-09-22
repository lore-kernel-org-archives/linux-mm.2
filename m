Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41E43C982FE
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 23:59:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A5D46B0098; Tue, 22 Sep 2026 19:58:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7569E6B0099; Tue, 22 Sep 2026 19:58:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66D026B009B; Tue, 22 Sep 2026 19:58:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3AFEC6B0098
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 19:58:48 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C9108120616
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 23:58:47 +0000 (UTC)
X-FDA: 85243065894.24.43361DD
Received: from mail-qk2-f43.google.com (mail-qk2-f43.google.com [74.125.230.235])
	by imf23.hostedemail.com (Postfix) with ESMTP id 18648140004
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 23:58:45 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=cxUuLYQk;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.235 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790121526;
	b=jFFPUDOc/4+LBlkk6ms66SELdaTWJdi9kOKYAKBt7q5M7N968JxG9HrXZjhW53rtwXoHSe
	Uk2s2NgDsYSou4MQIuBQcHe4nDcKd7JDSufb5YoW0VZZv2XkUA3sNYLH4xKkXoMczWzPZn
	LxO9wgfWMtpVpdojC1t1FXDr3WNsQyU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=cxUuLYQk;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.235 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790121526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Obo7lHtS5J/HNUJlSapmyf6Vr5VJeymYNsQD5zlwwVs=;
	b=fEeWIRe6WlzwnR9qWxlQWdEdnQ6Lfh1r4+OSxiP8HcjxQf4pBt9LCbCBIjqBTSZCHZjIdt
	mz9FvDPwR5eyF3Y8NNEp5kYP7vCy9GYRBDmVlbm1VUZLcPTKJb3zH6ZXVXAlbnZCvAMVmk
	cANiZ+lb5ZppRNmK7xZpIoyVlQyYOEo=
Received: by mail-qk2-f43.google.com with SMTP id d75a77b69052e-532db7db0c6so3690921cf.2
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 16:58:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790121525; x=1790726325; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Obo7lHtS5J/HNUJlSapmyf6Vr5VJeymYNsQD5zlwwVs=;
        b=cxUuLYQkMX/cTcs7ERynBpAbk2FwIxKinXO+kFm0n09d6F4pnE7YwwPKucbBXc3I+x
         xtBPj/TyA28Ybu15onM8ASwRp9mlf978qwW95wDcRn8Ap0f+yAfEPJk0OCEo2/zULM1N
         O+6fFShZzgOETzp8SRRHMTw3psnEh5be2s10a2xgbXKtVwi+WFz3RKWYJW5ardGGgJKh
         NbctIOd8QLxwl/dH89pWiusSe8bHszLrPFOROmAmV1kyfm0Hp5J8624bDuU2D/hv3+7s
         2NRX4HJI2x9l+xsKar2m+j3jZ7N4FFrurx5Nz5QWGSffv3KAbjCx6HDGlcrqC2M7cKRj
         tOdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790121525; x=1790726325;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Obo7lHtS5J/HNUJlSapmyf6Vr5VJeymYNsQD5zlwwVs=;
        b=qr9TwLS0xXjTjATQAM0zWyMPids7U3eK2gks4kPhjDpk7IrjO+KSQkZuVQySPc1DSH
         7u1LC0VuuzkRA6UxbNes3sYLpcGFUCsTLih1yuOfoAAkjQMg/ShS9GdFCylAgl/EP+9Y
         GsqIEqcEjYkHMr8eQ2WXqnXFpN4bv4rHV5O8NmZtAPLrUBydocl4zNSb0u5QuWzyR1Ib
         F0HxiavhZ1Z+1SNHnNSqKx2KUhb0EshDQWlucblbp+JYJM3cgsxg3j0YqtxzsYElvn2e
         /Xv2HL7zEeWe9feXskEi35kujxsaEtTrLn05uFuBYkvrGBofypuh8G2pAUmToIBgpect
         cbYw==
X-Gm-Message-State: AFuF++m1IpK8Ldudm3DNh24eacABd9mTMxVivHJJhMNDuzddw8UyE1+Y
	PNogfLHSqHiyJtPFeXWtB5BkAdzn8KiDDGPI+HsSVjdUc3QIENrQ4c8pxhivQPRsRpKj/4gRtZx
	vcAflPo8=
X-Gm-Gg: AYBFou2c72bTgh1IuwygqnMW6TLx3uAIbUp1yXkgM1+xnLXnwE9YmPbDQlsBCXSYP0e
	LkOK0/SaMz1cxAsCh2meZTORLil/wW2nRCYwCbAwarKqeNLIhpiuqpRbrkP30VCv1JmHoDV5Pwh
	gha9uVIXX79OEhwJeDNhXSJnPoep3PCQ7ZJyR+UsxdKeZfukIzRgxr0cdb/cQIJDre/SpbFYMza
	1R50Z347LysG53ksOOqiyEFco9LBmZoShTlv6uaSgihEQagcyLDBgWMRZX4Dj++yQX+u37ubu2y
	Z12d3YgBo3+uSK2qLkbxrMtQeVYdh3zNfbuv3MEV0n05k3NWz+chbJvAuae6hCCqfcjUeH905Mu
	cx4pPLri8aHWC2/+hxKJZsTd6sIXB69N3oJ8i0FkqorwwM7U4Hrr+pIen3OSm9/3Voa8wl1+r5F
	DdpuFgtiQwoZx2ulK/xUn5FBsvNjZAOjtdeYeyJ67PYeoQqNzLIwdoJojcQBEvSNBPT2Fac/H/h
	TY0g5SG2UWq2K9/O44hpNK7gL4UZvh6adjspkolmw8zCQk4Sms/NBfw1QyUrm0/DSyxtqw=
X-Received: by 2002:a05:622a:2b09:b0:531:1e27:90fd with SMTP id d75a77b69052e-532eac081e7mr17011201cf.30.1790121525263;
        Tue, 22 Sep 2026 16:58:45 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-532eb3c6715sm8323261cf.30.2026.09.22.16.58.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 16:58:44 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	liam@infradead.org,
	ljs@kernel.org,
	david@kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	"Gregory Price (Meta)" <gourry@gourry.net>
Subject: [PATCH 06/10] mm/madvise: separate huge PMDs from the PTE walk
Date: Tue, 22 Sep 2026 19:58:26 -0400
Message-ID: <20260922235830.2350770-7-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260922235830.2350770-1-gourry@gourry.net>
References: <20260922235830.2350770-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: t1crj88gjrdjrfwrwjet6sk9ydohrrrc
X-Rspam-User: 
X-Rspamd-Queue-Id: 18648140004
X-HE-Tag: 1790121525-129371
X-HE-Meta: U2FsdGVkX187ZipUb7hhj4mFYFcTiKb7akJaG2L/Iguz/4YtELhH9WF4ItZqpOToEZWak+1VcjjnJsPAGeH33Tk/09wAYxW7EROEIZl1JCKzQeEnQZ0Dwfv0oVn3ptHrm52shmwOqvtL+quu0UMkRCMO5dRzB/qKn2+p5gdzq4CmFdS4o3N7Os6uCcvdsjFbrhUE0+7utGYHy7Mu1RCujoe8FMVJUm3dg9V8ZkEfyAmAcrdxqHOPzhmD0laPjwkbMIvwj4Wo+8NczcKOEPuDWgouddRPXpmWJ1O2yiEMe1G3lrN207XDvBLzOliX8RyByB3rDVw8j0Cf4HjHdzH00RA5vgm010utRHS75jMKYmQYxJrBkxghqc4RjWr5h0ganJ6N4+QD+hSavHTjZLhQiluiWhyIHBbqz9TsDnzxQ+2oX0QK7vkVFWTqNJQ40m146iuJgrcSWZTwuDAXJqjSw1VMm3hnVdGZ30zLueo03n2OA71+bZcuMEjtTc6PLq9PPXdWdaqWDVvsrh5NBHVWRuxiWnbee7X0Opir0hgqKUE1ztzeK8bsvtksfOCxC/o26P99O4WFQ+91wInf/HmLFNB59WcMUs9RUZXPseJyZgau0jklhS3x10hhagrzH4JFNERfCpKTW6rhJuM+KIrrdnSwruiryZcQs7BAFrM+9BwqlBnBaKbsfDjmDymhjpTp5gNKu98XE6AhnU83qcY3jVnFlcGNBQEJ5of5tnJOhf8nDjZ8PdRhsnEd5/6zwXGHqYSBjpynCKlHtp8Bp/Vq0qVCWGDNI1pTAoVZs5UH3H2wrjfVKcK9lGN5B2RtKKeo2mPP3PJ/spgiA3hRZjprojxwhw8HB+4jNIoCfyK+JTzxT/tKuApFMXcOp1otrRY/IBy6yzxxvwrLl/R6whFGz1hZAUrNzRA2V9mWBcwgRD6UP61PD1FfnTwlv5asesmlnHTKPbPrwGO8QhL3pMG
 O180Ou2a
 qqxI0OOL3rD88WjAJuIVy/X03Wk5AR8juJ+ATTJSzj3qCdjh+mfYXiEQiVJkY4GGKp/vY07OfA8pukLGcBGRq+gg9GLqoqVgje86XRTKklUeP2XeQ1fqE5eo0yYzhc8Q2SoM9U8wR0GCXjMkSgOmf+yJPDIU5yOE5zdMiUhhBEn2b/3RYjUxswQfZWqtaHz/yV9Ocb8kfxXYoEAj6TJpe2+j9D3tSnAk0J2sIqQaFTWV582/jaoJX30NqXxWk1FGWRuTupT4m1LZdxx0CtYIcW4blcUM1Uc2sFkXJ5H0cuXQs/0w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The PMD callback still owns huge-PMD locking, splitting and reclaim along
with its PTE-table loop. This obscures the transition between the two
paths.

Move huge-PMD lock ownership into a dedicated helper. Return false after a
requested PMD split succeeds so the callback continues at PTE level. Use
the PMD boundary already supplied by walk_pmd_range().

No functional change intended.

Assisted-by: LLM
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/madvise.c | 85 +++++++++++++++++++++++++++++-----------------------
 1 file changed, 48 insertions(+), 37 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index 6b518f7f73651..83b27258c9673 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -435,6 +435,52 @@ madvise_lru_huge_pmd_locked(pmd_t *pmd, pmd_t orig_pmd,
 	madvise_lru_folio(folio, private->pageout, folio_list);
 	return NULL;
 }
+
+/* Return false when a requested split requires a PTE walk. */
+static bool madvise_lru_huge_pmd(pmd_t *pmd, unsigned long addr,
+		unsigned long next, struct mm_walk *walk,
+		bool pageout_anon_only)
+{
+	const struct madvise_walk_private *private = walk->private;
+	struct mmu_gather *tlb = private->tlb;
+	bool pageout = private->pageout;
+	LIST_HEAD(folio_list);
+	struct folio *folio = NULL;
+	spinlock_t *ptl;
+	pmd_t orig_pmd;
+
+	tlb_change_page_size(tlb, HPAGE_PMD_SIZE);
+	ptl = pmd_trans_huge_lock(pmd, walk->vma);
+	if (!ptl)
+		return true;
+
+	orig_pmd = *pmd;
+	if (unlikely(!pmd_present(orig_pmd))) {
+		VM_WARN_ON_ONCE(!pmd_is_valid_softleaf(orig_pmd));
+	} else {
+		folio = madvise_lru_huge_pmd_locked(pmd, orig_pmd, addr, next,
+				walk, &folio_list, pageout_anon_only);
+	}
+	spin_unlock(ptl);
+
+	if (folio) {
+		int err = split_folio(folio);
+
+		folio_unlock(folio);
+		folio_put(folio);
+		return err != 0;
+	}
+	if (pageout)
+		reclaim_pages(&folio_list);
+	return true;
+}
+#else
+static bool madvise_lru_huge_pmd(pmd_t *pmd, unsigned long addr,
+		unsigned long next, struct mm_walk *walk,
+		bool pageout_anon_only)
+{
+	return false;
+}
 #endif
 
 static int madvise_lru_pmd_entry(pmd_t *pmd, unsigned long addr,
@@ -458,44 +504,9 @@ static int madvise_lru_pmd_entry(pmd_t *pmd, unsigned long addr,
 	pageout_anon_only = pageout && !vma_is_anonymous(vma) &&
 				       !can_do_file_pageout(vma);
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	if (pmd_trans_huge(*pmd)) {
-		pmd_t orig_pmd;
-		unsigned long next = pmd_addr_end(addr, end);
-
-		tlb_change_page_size(tlb, HPAGE_PMD_SIZE);
-		ptl = pmd_trans_huge_lock(pmd, vma);
-		if (!ptl)
-			return 0;
-
-		orig_pmd = *pmd;
-		if (unlikely(!pmd_present(orig_pmd))) {
-			VM_WARN_ON_ONCE(!pmd_is_valid_softleaf(orig_pmd));
-			goto huge_unlock;
-		}
-
-		folio = madvise_lru_huge_pmd_locked(pmd, orig_pmd, addr, next,
-				walk, &folio_list, pageout_anon_only);
-		if (folio) {
-			int err;
-
-			spin_unlock(ptl);
-			err = split_folio(folio);
-			folio_unlock(folio);
-			folio_put(folio);
-			if (!err)
-				goto regular_folio;
-			return 0;
-		}
-huge_unlock:
-		spin_unlock(ptl);
-		if (pageout)
-			reclaim_pages(&folio_list);
+	if (pmd_trans_huge(*pmd) &&
+	    madvise_lru_huge_pmd(pmd, addr, end, walk, pageout_anon_only))
 		return 0;
-	}
-
-regular_folio:
-#endif
 	tlb_change_page_size(tlb, PAGE_SIZE);
 restart:
 	start_pte = pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
-- 
2.53.0-Meta


