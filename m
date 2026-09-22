Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 975FBC982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 23:59:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B01C26B009F; Tue, 22 Sep 2026 19:58:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB2736B00A0; Tue, 22 Sep 2026 19:58:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A0B16B00A1; Tue, 22 Sep 2026 19:58:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6D01C6B009F
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 19:58:55 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D08A64062E
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 23:58:54 +0000 (UTC)
X-FDA: 85243066188.14.F8B27C7
Received: from mail-qk2-f42.google.com (mail-qk2-f42.google.com [74.125.230.234])
	by imf08.hostedemail.com (Postfix) with ESMTP id 215CF160006
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 23:58:52 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=uuKvSGID;
	spf=pass (imf08.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.234 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790121533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ndNxVkCk5WMhyvlnx4WQtybJ1XuSLrgG5RrCZvpyS/4=;
	b=eHgu5uwO9MCDiofnLWssmCEegT1lhXu/7hhdHl2l9rTa0mohMUE9RZj6phnlC9813YhkUr
	I20QhYx7f3WRPT5GK8qE6RS1JEwGxfC8jEkDXOabZcGBLGgzwKPPhnpH3sITK+K3mT27lz
	8Pd3mH1NGo0rgK1kuvIG8fsvTmixe8g=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=uuKvSGID;
	spf=pass (imf08.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.234 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790121533;
	b=Q63dgs+MBFVMGMZUDU6xi5MAsNSexcieLFQka8ZmSyDLGPZt13cruqaxnwe084d3PDw/m/
	5+lOPjMdDG1gaHtcC2ct/vBRv5JwYnkHPWt4o6dEwfL+Pzt5RasEI6rFshASgpSpHyiljW
	IWkvQBFqjTMYw/PcogVdD+hW2zbHjEs=
Received: by mail-qk2-f42.google.com with SMTP id d75a77b69052e-5329fc7e0bcso4702211cf.1
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 16:58:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790121532; x=1790726332; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ndNxVkCk5WMhyvlnx4WQtybJ1XuSLrgG5RrCZvpyS/4=;
        b=uuKvSGIDokxqngsIrCLNSzlGAstqHw/3UromwJC6X7QOQ7zZZEb8KkfAoowMWV9rJf
         Iw5cLX1FN9SYpG41ObpH8IGGVVrQ3PlSysnAmHFid7252Mccl31F7QWDn2Fa30IpNF+U
         ektDg40XjeJA45iRuTVfHr1nB6S0TyE47p7Jzdwr7JCGc78TB9H5+UJdasqsjnV5iGap
         L36dXeyryx4v1cQin37u1akppiHabhXOGGT9wIMSC5eMd+bj+DgbMRoSQpF9/HI691Vj
         wZJMaIn6OV1PSJ6uh2VMp1/HaFea8Q1fdzZQXu6WsOhvrPlMnyPdbfFIWVEJMIVJBwN8
         RknA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790121532; x=1790726332;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ndNxVkCk5WMhyvlnx4WQtybJ1XuSLrgG5RrCZvpyS/4=;
        b=fi2qrIlEahsHAE4lvtn9aIISK1TK+pknOhQWkvzSWbTHEMfTZ5Wk043gZyakm0xU0G
         bmsRkdtJ5rPqtx0Ii+/QxZGNnZpW6AQwu+f9OBaHI653ZqnYkZ62SVCnfQuhC64jrTLV
         xDpWqPvSMbDgkiiiHktLWa1mbzgqUvo4uChBHlROYnBVBmkvlucW31gfvn4Ll1T+QVYv
         xAH1LadqyRx5lHJGNs4Fyr0eAsjQJtnBjlXcTWLrOO4vn9+uVp27viF5zMFmRhL2ULkV
         W/XMqvKRt/Iu/kSWPfDUvxkfR+lv8CZwDyqDq8kGizWBUGQ11YF16Z+iF7HEr13Rczrx
         ak/Q==
X-Gm-Message-State: AFuF++nLFWzifxqO/rpqWaVs+d1mpoNafK1bIVh8vpLL1zC1HwXpoaPm
	4XNt7QElun/kBQ8MNmv6nLvzdHF1PUoSQzlrbPW7yXlN95Bd1Bl16fx7mTdLCpTO+4GuLMWHd5t
	z6p+pf5o=
X-Gm-Gg: AYBFou3Y2IEfJCUUAqgmrr8KYD+ChPYwAWcnpKZGQg8pT37LLtch1/18RoJOpoCIA+D
	z0jhTO4IXbV0LZIax5O041CdSoRaW6SMok0lvC01QUN5uF1FrmWF2G4WTivotBY7IBoyqRCG2ua
	VYFCygI4CJtOXbN2XPg4SC5F4qSoIH9K0SGPnDFUOPLZ3UcOClqIoUUd9ZzPzLBKftb2lFzTodR
	e8+RshbVH5QgPjIM9rDhYvT+dm3YhMdiIU43ZnC02aoFYgv6Dd6h0tnbpgCuUwvrLihucjEN4Pm
	7emkqW55j1RZ4LV4h5HgR+AD7qAhjuRSOcUz+6Fe2/o5otNnyj9ZvIi+n+kJDc97w3z6A5K5Hj+
	t4k62aPzwsLC8g/oavJ9mORR+2TDe6iTM+xiDL3UGL0tLvT86hGAeD2KnxB3vhLgJ4QBny7/X3G
	Bnf3NOXFwuOPR287HMlWn5KYoPakzJCC2wGyoVE//Qc4WwjwOfDrbwKAxuP2UVxilJCQ4o0VzWl
	QvlRd6qJoYJTmJCchMMzVLifqu9EzmEAfMsr56OxOAb2H8Acb7aeoZ48RVs
X-Received: by 2002:a05:622a:1e06:b0:532:9ade:b6ef with SMTP id d75a77b69052e-532eadc3523mr18790541cf.69.1790121532255;
        Tue, 22 Sep 2026 16:58:52 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-532eb3c6715sm8323261cf.30.2026.09.22.16.58.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 16:58:51 -0700 (PDT)
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
Subject: [PATCH 10/10] mm/madvise: share cold and pageout walk setup
Date: Tue, 22 Sep 2026 19:58:30 -0400
Message-ID: <20260922235830.2350770-11-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260922235830.2350770-1-gourry@gourry.net>
References: <20260922235830.2350770-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: sosb51fsnhib5cjsectgfzyo3wkexp5s
X-Rspamd-Queue-Id: 215CF160006
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790121532-406420
X-HE-Meta: U2FsdGVkX1+VFa+Jh59+crn0lHgSfsEIxEMi8z84/izLDpluFwnE6JC7NZ/Y9UUhi21JkAXLpGDCjBLd2B7CeBYScCLBkmJy+uIDXwCT6ZAq56/11c0FE+nsj7KOz1QF62kNJtkphbTW4HKmV/sV1ea4sEkfl4HU2shP3vZsmuB3kQERj0ZQV8QFB4VesZ5pFdCmU263Ms54aG+aAxoPLG+mCb+jD2kTd9Xf13jdQXt3ddRpvIkDRGPiPInlUY/vBKfTi3hZOOTWGSK3RqGpXTXrZ6zfua6ZyE1WQ3g3i/w3Kg11IoKsZJHxPPqNL6MZnBsAtOCn3rfnoIOABpWoAqG+KnpYZvG6rTa6xKdM0Me72L+DIj5oL7eqqQ/+Ae4P6Dc1JSRtnfJ5DrV7NAmn6FpplH+USz3lTG1F6LKF1/oiYNrt7zuGVbHZOsvA488AYsDnSG1IO7FirLAS+J46TqqabfeB9axAu6HogZelqApcjKTugmqm2kK0d2axxpYgpW2XZleWIn1BzLoIDc4gHY2zVwLl0qgxnxWcG3dTIY/F1yB5nfHgKnNPB6YRDOs6lcwndR3n/IZhnV2qQxmmtFkp+6uC07dfvHR2C7WfwX5C0JGXKuR2G7e+9TmDEdecKqr4sgeBByzEIesAf6m9SpoJbv6goml0B6WYfJgcxcMVpz4ZVfsLrgOhsTtnKRn3DZ/5wDfOfBnHCWP7r81Ox97mJwLp5APQB9fKBOVneeREYiTIi4EA5WhXD+dJq766tA/HifEqZToP3ysujRDgNbti66zIQai/R8Icl0J6YwHctMOYV4M3Qp/5PUI8mlVA0/Xu8oYwIsv6jNti667nTGlS1+eMqbhWtp6rs/hF/P5RSDBDbea+9F4Qjihm9RLVVzjmBay6wlZunx8VV5xMEbiNgUgSwe4QmfAzbrrWdohHg+D3EFzlftzzM+0qoAHRY/eyND0coufpJVFYDTr
 Uf3BzOA1
 OILbcE6kIYLrh6l97TPw5vx2EGCPk24V4tOO/s1ToMOjAgMufHgfW7KvYX/Livppq1zKvOO92IWVO5/H+2KFcBnFFcoIDrsJ/H/4X1AMqcZ7FvAvRr/SM3HaTOXKodq5k1QxUsN26QCgWC9ApCexJEixbbaWdsyJ1SBR/1kmluWtpXDLmtMKKinptWoqysOZQA7cybUdXLLG6KCaUFHlcSQWtyc+2zjiq5hH4JDWe4scwPm9DFsCMNSRXVtBVfOxtWvNn2CvtTcEfH2U8ySj0WJwhjOKXW7BeK9qUz/09xYm0+gc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The MADV_COLD and MADV_PAGEOUT entry points duplicate the TLB and page-walk
setup while initializing equivalent private state.

Use one madvise_lru_vma_range() helper for the shared TLB lifecycle. Keep
operation-specific validation and policy in the two entry points.

No functional change intended.

Assisted-by: LLM
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/madvise.c | 49 +++++++++++++++++--------------------------------
 1 file changed, 17 insertions(+), 32 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index 88a4a03dee04c..37e3d3a205a76 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -622,21 +622,19 @@ static const struct mm_walk_ops cold_walk_ops = {
 	.walk_lock = PGWALK_RDLOCK,
 };
 
-static void madvise_cold_page_range(struct mmu_gather *tlb,
-		struct madvise_behavior *madv_behavior)
-
+static void
+madvise_lru_vma_range(struct madvise_behavior *madv_behavior,
+		struct madvise_walk_private *walk_private)
 {
 	struct vm_area_struct *vma = madv_behavior->vma;
 	struct madvise_behavior_range *range = &madv_behavior->range;
-	struct madvise_walk_private walk_private = {
-		.pageout = false,
-		.tlb = tlb,
-	};
 
-	tlb_start_vma(tlb, vma);
+	tlb_gather_mmu(walk_private->tlb, madv_behavior->mm);
+	tlb_start_vma(walk_private->tlb, vma);
 	walk_page_range_vma(vma, range->start, range->end, &cold_walk_ops,
-			&walk_private);
-	tlb_end_vma(tlb, vma);
+			    walk_private);
+	tlb_end_vma(walk_private->tlb, vma);
+	tlb_finish_mmu(walk_private->tlb);
 }
 
 static inline bool can_madv_lru_vma(struct vm_area_struct *vma)
@@ -647,39 +645,28 @@ static inline bool can_madv_lru_vma(struct vm_area_struct *vma)
 static long madvise_cold(struct madvise_behavior *madv_behavior)
 {
 	struct vm_area_struct *vma = madv_behavior->vma;
-	struct mmu_gather tlb;
+	struct madvise_walk_private walk_private = {
+		.tlb = madv_behavior->tlb,
+		.pageout = false,
+	};
 
 	if (!can_madv_lru_vma(vma))
 		return -EINVAL;
 
 	lru_add_drain();
-	tlb_gather_mmu(&tlb, madv_behavior->mm);
-	madvise_cold_page_range(&tlb, madv_behavior);
-	tlb_finish_mmu(&tlb);
+	madvise_lru_vma_range(madv_behavior, &walk_private);
 
 	return 0;
 }
 
-static void madvise_pageout_page_range(struct mmu_gather *tlb,
-		struct vm_area_struct *vma,
-		struct madvise_behavior_range *range)
+static long madvise_pageout(struct madvise_behavior *madv_behavior)
 {
+	struct vm_area_struct *vma = madv_behavior->vma;
 	struct madvise_walk_private walk_private = {
+		.tlb = madv_behavior->tlb,
 		.pageout = true,
-		.tlb = tlb,
 	};
 
-	tlb_start_vma(tlb, vma);
-	walk_page_range_vma(vma, range->start, range->end, &cold_walk_ops,
-			    &walk_private);
-	tlb_end_vma(tlb, vma);
-}
-
-static long madvise_pageout(struct madvise_behavior *madv_behavior)
-{
-	struct mmu_gather tlb;
-	struct vm_area_struct *vma = madv_behavior->vma;
-
 	if (!can_madv_lru_vma(vma))
 		return -EINVAL;
 
@@ -694,9 +681,7 @@ static long madvise_pageout(struct madvise_behavior *madv_behavior)
 		return 0;
 
 	lru_add_drain();
-	tlb_gather_mmu(&tlb, madv_behavior->mm);
-	madvise_pageout_page_range(&tlb, vma, &madv_behavior->range);
-	tlb_finish_mmu(&tlb);
+	madvise_lru_vma_range(madv_behavior, &walk_private);
 
 	return 0;
 }
-- 
2.53.0-Meta


