Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72532C3DA7A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 18:31:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B99B56B00A6; Wed, 14 Oct 2026 14:30:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B711D6B00A7; Wed, 14 Oct 2026 14:30:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A391C6B00A9; Wed, 14 Oct 2026 14:30:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 883216B00A6
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 14:30:47 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 26C81A0254
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 18:30:47 +0000 (UTC)
X-FDA: 85322072934.14.C43AFA0
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5840A2000C
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 18:30:45 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="Gq89Lh0/";
	spf=pass (imf03.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.174 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792002645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QJo2gAKsEo0t/BTlHKqqnwXUysT3Hn0OcnvXdcWDu6U=;
	b=pdD0xaY0uA9hnmP8Gvc+5FIY4zmdhgvWSWyBf4acAd8/1eVe4GX1zAw2CeQ2YMa5pp+mqB
	iHVsFaxUFt2gV6CT0NUii+fH3enu0FQKLPL3J0GlbpR314OQTXc8NMnpev2ro2Ll1WcZJY
	FDFFu75Wq7ZJrmiq2MHC5J6hAr+HoPk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="Gq89Lh0/";
	spf=pass (imf03.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.174 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792002645;
	b=S+FWbzHF2/jih6j8CF6/sgx14t+LnPFuG2VUdTSu1nPlkOPQ0HlTFvKBdbfHIElQhTq0TO
	20UEhqy1h2hKlJVoo3dpXiYOfFW7WOTE5QMFwI3mooKOKDAF22TzXHDEr0ShqnCqOURsOB
	GvO5jjXVJd7AFCgk3Xcgk28EKdZKXHc=
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-93e7ad9f78dso528712785a.1
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 11:30:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792002644; x=1792607444; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QJo2gAKsEo0t/BTlHKqqnwXUysT3Hn0OcnvXdcWDu6U=;
        b=Gq89Lh0/wHoNFXSphq5yh6EwjGSU6gKW/tuc/E0e+3iIW3kEKonnctP9mRqHhlNNNF
         ZP6LcNAVpsEq1DjbTaezhuJc1DmV0J8YncM0NRp6V5l2LMj9KU/IhpqYGvt/i7Z+RkoJ
         GqYz6u6QLpNwGP7Srjtrtnx7C+dwaMFZxyT+7gxlnrF2Lgwr4y8lW2dE941cE4gbulKz
         0CU7Uajak0odTGgJRaQZom8DT/gv/c5iY/pHtLRZAvF0vjQjOc8b336UZnpjcRFRAv5P
         nGvn+6otGrMy4SWSw2Y85W8v4kKGax0HDEorL4F+0bHIlER+kwXa2b5Tm1Jnp1jWh75F
         SmYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792002644; x=1792607444;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=QJo2gAKsEo0t/BTlHKqqnwXUysT3Hn0OcnvXdcWDu6U=;
        b=bB+w6/SPf6HHnF7fUgQaPFAAE/Ywn/OQlZVDx0ePYty07Mrfq2DbdaVPcuhijojrMp
         89pWXbKl0FZ2lhMWpu6s6RoD8r0SKn2jvMRWUtKR+eMei5IlWAiTzJFiHR1edGQ5xDAw
         e9goECnLUyi1yqB8nmKLPnz26LbQ/0UWd1/ToUZihLTmH/X9Fh95oPcnp6QeN+bp+VQ9
         IlxRZ3K29vlcmL1HXKqseFB21VxmQIqZchYQ5PaMuMYkv7DZitzrPxe6urGaq2hmhAUP
         vGqYHd4XiBk6fRHhqhGxnyLKWz8oqBcrOO10ZqdftXp2z2CZXJeDTx51cQaU2pOvS10N
         Nmwg==
X-Gm-Message-State: AFq9FYLOdMLtHKsUma1iecmv2yHqcm/Udj2XLOde6CFAz2t3C26xcQsW
	rjZRcGOwscD14c3mo/Qj4yALoG9EQDOnw6TZraQ9Tq+73x7UHkR1KfilSfRJmcUp2s3ShFrxvx3
	c12N00+w=
X-Gm-Gg: AYBFou2jqD/yH7YUsBgEtmnex9L074xNVElLbmo8ubVQ4nj0CjUHJODpLK2UzevCtaF
	N3asTenYe9ac1CYS0ImnFnwDxYidaAlXuH9C5lDwOZQ2miTn6VYrybWBFb6WBVYup7vxyWT2XTb
	fhYv6biQXe39clziic/B+ZCf1gYh2oNfsg0Skl5MGgegEcYJO5eiWmwL8PRApoKwvmpSCNJ+qTg
	aArtS/wVvwCd8vqCBGdcZQJml67yX69OD7PgmBTTtEUNoG0XsHPgIBSGae6zrupRDtfIb4siNX8
	PaTuiYU7wcgyMhq7EMiSF929XMtC6gmIR90WSna60kgQkUgKNvD5B6qpX5I4nL7pqo8IWW2XHn2
	Ga0LoP66i5dS4+duy+S7F+a//GRPRiTIpXJWGjWvK+xnSi919meVnfEc4DcszpG3xDQ4jRtyVKu
	JLrDnOFLGQokrvlkb+HuPk6mQS+TIrD/b884vHljIfbFhCy1pCHeZH6tbC7RDen1IeleRnVnvoV
	A27HZq6g6tK001WwcUEBcWC6Q33vzzQM9oWar+sdttjOoirVhK+KDQJlvpuow==
X-Received: by 2002:a05:620a:6493:b0:93e:60e8:c9ad with SMTP id af79cd13be357-93ebd09e6cbmr2693181685a.12.1792002644454;
        Wed, 14 Oct 2026 11:30:44 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93ef508811esm556593085a.36.2026.10.14.11.30.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 11:30:44 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	liam@infradead.org,
	ljs@kernel.org,
	david@kernel.org,
	vbabka@kernel.org,
	jannh@google.com
Subject: [PATCH v2 10/10] mm/madvise: share cold and pageout walk setup
Date: Wed, 14 Oct 2026 14:30:24 -0400
Message-ID: <20261014183024.2075709-11-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261014183024.2075709-1-gourry@gourry.net>
References: <20261014183024.2075709-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5840A2000C
X-Rspam-User: 
X-Stat-Signature: 5b1jtoujhqs5tkh1gwkrck5o1z9yx1f5
X-HE-Tag: 1792002645-242225
X-HE-Meta: U2FsdGVkX1/eer9Tk0hsYN/o+0aO7SO4Ifn2dvYVq1BEwa91Ft8M7pz/Yg86MVOWiZz+AvfTr64ZlDG3O665xeq4WcwdqE9gDq8Y1R3pRW2QgXA+5m7YY+GHrA6I/ZHHbillCXxYpG86z+4UB+uNZByb+8yfhODwO2sfAfbg/qIJ6brSStkOLVaPnNpJ8zJJS+IjhYjI3DxS8nqwM6S7WEycoauvTTB/I00eRBYsEA49RKmR+vCcOxVLkhu6JuS25qk84ZQr5FLJfUKFp6YD51kzBZ3s3u3Aqs3jaoIhYJLz90khYI1rYsSA+hFhJPu17UK4hURne1+XtEIHKmO1W3+O2m+UzRjk94tXvnMewfvUoDgzLAq+dZTFW9W6a+3w0q9tLks9T4fOB6k70jgBGkYn1FDigod0eBDgUpnb8Eamo0w1m2p9/IEpmbcI+mOQVO+KHnN1CThoPde4ccUizgjKUtzlmn/xQIpPxkvt+Q86H7CkfaHBSZiU7UGsVGC0dx/0yCkQ8ovkaJxw2sxIWe6YqoDR7cq2Ze6IAGip6UnpPxgw/P5y3knQIUQPNpJO8WT7JoD5/GKLQXUUwURaEw+DYgM+S1LfpY7v+XYz08jby4+lZ/zU6D0ue0zfTq/9TPM/4roOpYUiAq7gAyG42oIre5gev/EwvzNaEn1KsG/Z5pP4/pWTeA2z3WL1KAwfHPVDiAVKNaSq4RhXyp/EezoYNoNmZQx7opiq1rjXhNCbSscDBqfo8Xh5YbLTTyeWbNM3+N04K+Aq5tE2Qq/r1oL6SFOdCvSMoRC7EJhrNSD7acyBycVnYObDRQ5hhakhsmwrJzIgpTzuvRnxD2l7J9VPV7ZQrPQuIU/8JgJIrxhT7hbAUbwnc+rBmc8iCPyylOnemhYrKIljN44pqPPzuMuv+2pd52HUR6odxndHL5VfpmAsKbQfXCaKJZVu5crQ1cmfX8MuTGb4UB2hbWB
 yhVG5vK4
 VGyYk+i0PzXd5gRT4FdT4+bV0vESg3jqqG4kSwr/udpzjhxDYD4mkHlAh1cByMJeBfbBPkU718KRA9dRl8JvR9QWNAi6mZ71ZyrKRax/kRwCwUCKk1zaqsvEXgWggXYYqPOYxOUB+mlIKwmH4gwizckQp8yRNE+6Me1BgYi96wzkQHIe7qLZIIoIZ79iKiPFdv+RiIia7LXCTKHUGZXgupz9YIi3Eyuqg9kKZaAL0xKQ5nH8rHJxJxPDPtY8TZT2loFl9kYdb9BMs1+t2C1fV9yQ08CQ8NjPOgcmhV3jxF7+7N7s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

madvise_cold() and madvise_pageout() each open-code the same mmu_gather
and page-walk sequence, differing only in the pageout flag they pass to
the walk.

Move that sequence into madvise_lru_vma_range(), which takes the flag.

The walk now gathers into madv_behavior->tlb instead of an mmu_gather
on each caller's stack.

madvise_init_tlb() and madvise_finish_tlb() leave that mmu_gather
untouched for both behaviors, since neither batches TLB flushes
across VMAs.

No functional change intended.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/madvise.c | 37 +++++++++----------------------------
 1 file changed, 9 insertions(+), 28 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index acfe5b945eea..db4f498840eb 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -656,21 +656,23 @@ static const struct mm_walk_ops cold_walk_ops = {
 	.walk_lock = PGWALK_RDLOCK,
 };
 
-static void madvise_cold_page_range(struct mmu_gather *tlb,
-		struct madvise_behavior *madv_behavior)
-
+static void madvise_lru_vma_range(struct madvise_behavior *madv_behavior,
+		bool pageout)
 {
 	struct vm_area_struct *vma = madv_behavior->vma;
 	struct madvise_behavior_range *range = &madv_behavior->range;
+	struct mmu_gather *tlb = madv_behavior->tlb;
 	struct madvise_walk_private walk_private = {
-		.pageout = false,
+		.pageout = pageout,
 		.tlb = tlb,
 	};
 
+	tlb_gather_mmu(tlb, madv_behavior->mm);
 	tlb_start_vma(tlb, vma);
 	walk_page_range_vma(vma, range->start, range->end, &cold_walk_ops,
-			&walk_private);
+			    &walk_private);
 	tlb_end_vma(tlb, vma);
+	tlb_finish_mmu(tlb);
 }
 
 static inline bool can_madv_lru_vma(struct vm_area_struct *vma)
@@ -681,37 +683,18 @@ static inline bool can_madv_lru_vma(struct vm_area_struct *vma)
 static long madvise_cold(struct madvise_behavior *madv_behavior)
 {
 	struct vm_area_struct *vma = madv_behavior->vma;
-	struct mmu_gather tlb;
 
 	if (!can_madv_lru_vma(vma))
 		return -EINVAL;
 
 	lru_add_drain();
-	tlb_gather_mmu(&tlb, madv_behavior->mm);
-	madvise_cold_page_range(&tlb, madv_behavior);
-	tlb_finish_mmu(&tlb);
+	madvise_lru_vma_range(madv_behavior, false);
 
 	return 0;
 }
 
-static void madvise_pageout_page_range(struct mmu_gather *tlb,
-		struct vm_area_struct *vma,
-		struct madvise_behavior_range *range)
-{
-	struct madvise_walk_private walk_private = {
-		.pageout = true,
-		.tlb = tlb,
-	};
-
-	tlb_start_vma(tlb, vma);
-	walk_page_range_vma(vma, range->start, range->end, &cold_walk_ops,
-			    &walk_private);
-	tlb_end_vma(tlb, vma);
-}
-
 static long madvise_pageout(struct madvise_behavior *madv_behavior)
 {
-	struct mmu_gather tlb;
 	struct vm_area_struct *vma = madv_behavior->vma;
 
 	if (!can_madv_lru_vma(vma))
@@ -728,9 +711,7 @@ static long madvise_pageout(struct madvise_behavior *madv_behavior)
 		return 0;
 
 	lru_add_drain();
-	tlb_gather_mmu(&tlb, madv_behavior->mm);
-	madvise_pageout_page_range(&tlb, vma, &madv_behavior->range);
-	tlb_finish_mmu(&tlb);
+	madvise_lru_vma_range(madv_behavior, true);
 
 	return 0;
 }
-- 
2.56.0


