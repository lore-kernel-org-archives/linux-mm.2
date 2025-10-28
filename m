Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BF05CCD1BF
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 13:22:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A66C780142; Tue, 28 Oct 2025 09:22:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A17D38013F; Tue, 28 Oct 2025 09:22:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 905DD80142; Tue, 28 Oct 2025 09:22:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7BEFB8013F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 09:22:41 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 28BDF14037F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 13:22:41 +0000 (UTC)
X-FDA: 84047587722.03.4212379
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf28.hostedemail.com (Postfix) with ESMTP id 4CB79C0008
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 13:22:39 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JjCCLiR3;
	spf=pass (imf28.hostedemail.com: domain of pedrodemargomes@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=pedrodemargomes@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761657759;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UrGZMy9hZEV5wyJpLWINpY79WwhAr5U2pevMnRBTDHY=;
	b=r1D+1O+x9F396CKehZkM18fuyfoPQkEwQfMyey4zkGpg+nYWgphI38ajgJPLTOf/jPXAia
	ctz64Uq4KLWdBP6OQSGXqousgoTXLnJ2oOKDYuN0c5b/PPlk7dFrq/t58tvAWCHkrl/Gfx
	qppaIcgTF/Y+8N10Le3CBGHlKl12oSA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JjCCLiR3;
	spf=pass (imf28.hostedemail.com: domain of pedrodemargomes@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=pedrodemargomes@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761657759; a=rsa-sha256;
	cv=none;
	b=nMl6s+8yyQzL9avE/7XREKDrGZR2zcTEPflzm0uEU1b0E60iEK6rlWmUJ4dPy5S7bE38l2
	FKCNT5DdyV+KKOXL/4oMryokHldtI5Q/5wlfH6PZ5f91Truh/tNg6hn0B0tFFa8SpKMZfQ
	S6NySpYN2/AojEkD6GuQ8FrO3cPjlKM=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2698384978dso39429385ad.0
        for <linux-mm@kvack.org>; Tue, 28 Oct 2025 06:22:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761657758; x=1762262558; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UrGZMy9hZEV5wyJpLWINpY79WwhAr5U2pevMnRBTDHY=;
        b=JjCCLiR3ZioreyqcRjZ9ks8OXlOtVsxeId5KcNnYxBLjaZbdUfNU7UmOIaYK3I5bj9
         Q6pGmolKSstacOgC0f5tOh2AahNAbfOXhqaGMNf9NQJBaT6DljeTSUVg2d1295fyIIy6
         o+ZC5yij6i5Smgdvd7uj57thPqGObFv69x6AupJNxfDvIeSOupd3wNyfV1ehywzbS9Eg
         5r+WzeW0Z6vIDBBk1+t0Dqkmo9evmIsBMzGgw5krPJ0w/SCNVShW/7OGnmMI5EPrt+vM
         lyHia6tI+Sc+IB2wHnLUmeF+Qcm8sLEOPG3EVK89SNacS8C6NvgOa9lbtTkG78Seabal
         6keg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761657758; x=1762262558;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UrGZMy9hZEV5wyJpLWINpY79WwhAr5U2pevMnRBTDHY=;
        b=G36uMlxkyz2rpMM6ohiLyTfSWK7Jl6SdF30pNcXfGURHAITDDabc3mxnaDWVJkBq2b
         n0JnOoWuNFl7bBMvrkQBsUCGu5/Mu4Yb2dg9B67Cl+7BgjapmIkMiPJmmxDKCjDS1GLt
         gEUsn+838Vmmx+s53hcDNDt8jLW5Qa2MHYsijKOcx0QjrIccSFS4ARHmdt0VN4bNZ+Qo
         AcmiqD7HWiuDa4g9bzJlID2Ljc3ZlcQTYLzuco2QB+T8usFmCevfqIAiRxVt+bE1ukk2
         V8QofgnndWK3D56qU4s2Rcc4PzilJWlf+3P5SiRBY9zQMeqAvNXvG42TzoMsQuuPEV32
         k1fg==
X-Forwarded-Encrypted: i=1; AJvYcCXiHM3bpOD2tpO+HgO3RbMcQKrePleeGMKxeCW2irQoBFgNcEpQsLJJd+gQhXYOF+nI4bLfPegSvw==@kvack.org
X-Gm-Message-State: AOJu0Yx1omKJFHpC5WCsXqhqYf771v8XFxhpIEn6RCh7J1oVO8z6+4Y0
	r/lUAnYQiK0kYtT8o7hz5S3sjLjd39XFFiKvm79QS3/+kwNKGHc4kEMV
X-Gm-Gg: ASbGncuJd3ihh6UjZ1YXkNNLHXougL+j5J0pttzZVFyJyINTCNoAdWAaLW2Vrduhpva
	7fLqbIp+fNuEbZn6vJcGRsBeMnP1bgpGM+NG8UMyaipFJGMmiw/ua16SYeoUFGgQmiATMu9ddqh
	y7ocV2bx7javDStOHqb3dThHyOz4+eNhI0PiysYYvGF9cFIQhN6oELfp6k+PTKn5CIW9O6CR4Fu
	5RMTO8RHpfnlGQzhFsaxNKjsQF8dRPioXumlh85zStQYmkEYe9k3BXbe0INuTTkFSoLFoJEup8o
	YkvMCBr4Hk4R85PsFud5+CpsMumLbGk/G/fLU09zTRYIAjP+YVuVTuv688EcZ2Gef35bjqecm+H
	UP2sMTb/UMgxzqiYN2vOYuSn/qv2fCSBp64UfvSB7gJDW7XVqmOmi9puH1al/17bvSNStHRTIte
	vZHapgBPl11RnoP/YEJKVD4+20
X-Google-Smtp-Source: AGHT+IGPTXiA8UA4+WfFWcD2ez/aP+Nf0BeAoSyjUo3zq3lEFekz/Uq+3yLX6MS444LZrXu6WCeBVA==
X-Received: by 2002:a17:903:124c:b0:273:7d52:e510 with SMTP id d9443c01a7336-294cb5371c0mr44527505ad.58.1761657756035;
        Tue, 28 Oct 2025 06:22:36 -0700 (PDT)
Received: from weg-ThinkPad-P16v-Gen-2.. ([177.73.136.69])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29498d0c6eesm117446235ad.42.2025.10.28.06.22.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Oct 2025 06:22:34 -0700 (PDT)
From: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
To: David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
Subject: [PATCH 1/3] Revert "mm/ksm: convert break_ksm() from walk_page_range_vma() to folio_walk"
Date: Tue, 28 Oct 2025 10:19:43 -0300
Message-ID: <20251028131945.26445-2-pedrodemargomes@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251028131945.26445-1-pedrodemargomes@gmail.com>
References: <20251028131945.26445-1-pedrodemargomes@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4CB79C0008
X-Stat-Signature: he6xby5rp5q3dxpbz31boxj5me7igae6
X-Rspam-User: 
X-HE-Tag: 1761657759-176704
X-HE-Meta: U2FsdGVkX1+o5SaRIwZKqXPcyKx4KP/W2r01TTukSc0oZeatMHGp31ERj+4gLPn87WS/DT4ZR/LJmYQSkF1idUVOEH0eC+DPVdyIAIaWaKOc09fIibu51tdjlJsUF+9a3wkMsx6IvD5lePIcemHccHBAoQ5fktB5dXZa7MIKYsV0pLwiQW7amLNRiC+ytmnJN2d5zvdit9Vf/xUNIYy6Cob+SkoKA8ISTEwQ0r481p31maBvccf2H9dVAP+ScqmroFknjdIvxZDGIhMGhHtmn6oIbBRaTHC8tnKQVdl6r51h1MvvBzr4YQPCQ5YS7qV3j0GhGi3LyzgDBiJU+Tk1/KTHkXlDOSQuM+n9to+1uFrYwNfTd/GWhYvZp6tKw+YaHI/yMkVaMlQxHJaaX1SDAraKqUR1HNZH/ffMtHh5hwhzbgyoyGM8Uc5BRI67vgXj19ZNv3YGCEnoB/8BLZAb17iJghIgvQGqP9z4Tk8XPBB7DiGZd48oR8aJ/RNm6VDJtjoY9ekiPneroVWq7u2c5Nfo8UWRoFdfRn/pRMxxz2piWMZhNSV6wJfN4EHuLwp8PhZ+i55IOT0Fnh3loGiVMNLHARsjy9Izzt3NVbNkjW1FhhEPHPpmRXNvAitH5UhOyLwUQkFBNpCfZyYmL2RiEft8hJ6POdhINCYLmHfT/RFSfKcn7rWZiKpLRfGWJMXmCmWKdoCw7ZqCuafmOR/uPKuweLXJvdIFkOwdOjhwjsnAAl1aTDmr8PQB2Htw4jmIWXhRS0ptFjx97iol+GHb1GAxflLx9Oo9Rcf4IBUtCxn4NBuixnaj0OL4b1u2qOeRvtuSsDZQ3fVwTCHbXZOXcImha5bsWT+RGoHsEk1+Z6FAGL6SAV+rgu9vAUutoakgQebmHe9wf9TYFZU7ZIv2F1vhCLX4s7lZEbOERJjZCwrK/vUCE4idiwwKnlh5qH6ndWMkM1qeyb4Tj+S7i4F
 fvgk9ZzI
 uVoAycTsp2+HIRw4bsrj93QaQe2TGZrsrwrFiRcml0K2DxrEIb9V4MMduJ/oajPOKiGJo8u4y61qbtIDkLNlh6ZK8n8Wp/OD7xNrckqZhh8fxnvBjr7W21VQw90Mj+fIekDb2fr6H54iafiFYl5nt1QCTwFbHPmpwgEFkfBe/HE+aRvWIrduECE21V7jAYQpTpbsHK8i2rzsRFn7OrhopvJJejyoWgqmCBOrohF8SDaCDZTgqrRYcI2Eizz8Z7oNKV8HNytDZzhk7dzFaaBd7zKsc86GznXXGPPzBjsUv3XzKJG3101WcqOqEFVQNlS0/GmbHRhkgPKFWOyaMBN3vvJ9Z2B+jagbU11bq6fzEhNnitWHegipd5JRAgFF5uaUodsydpBX4Uv4lvOSfWigkXc2bDz67FoOnzPWcy54H7ZwkeinUbZLSOjef8rK02Mjd7OAK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This reverts commit e317a8d8b4f600fc7ec9725e26417030ee594f52 and changes
PageKsm(page) to folio_test_ksm(page_folio(page)).

This reverts break_ksm() to use walk_page_range_vma() instead of
folio_walk_start().
This will make it easier to later modify break_ksm() to perform a proper
range walk.

Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
---
 mm/ksm.c | 63 ++++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 47 insertions(+), 16 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 4f672f4f2140..2a9a7fd4c777 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -607,6 +607,47 @@ static inline bool ksm_test_exit(struct mm_struct *mm)
 	return atomic_read(&mm->mm_users) == 0;
 }
 
+static int break_ksm_pmd_entry(pmd_t *pmd, unsigned long addr, unsigned long next,
+			struct mm_walk *walk)
+{
+	struct page *page = NULL;
+	spinlock_t *ptl;
+	pte_t *pte;
+	pte_t ptent;
+	int ret;
+
+	pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
+	if (!pte)
+		return 0;
+	ptent = ptep_get(pte);
+	if (pte_present(ptent)) {
+		page = vm_normal_page(walk->vma, addr, ptent);
+	} else if (!pte_none(ptent)) {
+		swp_entry_t entry = pte_to_swp_entry(ptent);
+
+		/*
+		 * As KSM pages remain KSM pages until freed, no need to wait
+		 * here for migration to end.
+		 */
+		if (is_migration_entry(entry))
+			page = pfn_swap_entry_to_page(entry);
+	}
+	/* return 1 if the page is an normal ksm page or KSM-placed zero page */
+	ret = (page && folio_test_ksm(page_folio(page))) || is_ksm_zero_pte(ptent);
+	pte_unmap_unlock(pte, ptl);
+	return ret;
+}
+
+static const struct mm_walk_ops break_ksm_ops = {
+	.pmd_entry = break_ksm_pmd_entry,
+	.walk_lock = PGWALK_RDLOCK,
+};
+
+static const struct mm_walk_ops break_ksm_lock_vma_ops = {
+	.pmd_entry = break_ksm_pmd_entry,
+	.walk_lock = PGWALK_WRLOCK,
+};
+
 /*
  * We use break_ksm to break COW on a ksm page by triggering unsharing,
  * such that the ksm page will get replaced by an exclusive anonymous page.
@@ -623,26 +664,16 @@ static inline bool ksm_test_exit(struct mm_struct *mm)
 static int break_ksm(struct vm_area_struct *vma, unsigned long addr, bool lock_vma)
 {
 	vm_fault_t ret = 0;
-
-	if (lock_vma)
-		vma_start_write(vma);
+	const struct mm_walk_ops *ops = lock_vma ?
+				&break_ksm_lock_vma_ops : &break_ksm_ops;
 
 	do {
-		bool ksm_page = false;
-		struct folio_walk fw;
-		struct folio *folio;
+		int ksm_page;
 
 		cond_resched();
-		folio = folio_walk_start(&fw, vma, addr,
-					 FW_MIGRATION | FW_ZEROPAGE);
-		if (folio) {
-			/* Small folio implies FW_LEVEL_PTE. */
-			if (!folio_test_large(folio) &&
-			    (folio_test_ksm(folio) || is_ksm_zero_pte(fw.pte)))
-				ksm_page = true;
-			folio_walk_end(&fw, vma);
-		}
-
+		ksm_page = walk_page_range_vma(vma, addr, addr + 1, ops, NULL);
+		if (WARN_ON_ONCE(ksm_page < 0))
+			return ksm_page;
 		if (!ksm_page)
 			return 0;
 		ret = handle_mm_fault(vma, addr,
-- 
2.43.0


