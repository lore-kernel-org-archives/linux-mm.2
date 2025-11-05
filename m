Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54565CCFA0D
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 18:51:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6E6D8E0009; Wed,  5 Nov 2025 13:51:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B45978E0002; Wed,  5 Nov 2025 13:51:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5DB68E0009; Wed,  5 Nov 2025 13:51:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 971888E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 13:51:50 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4E5CD879FF
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 18:51:50 +0000 (UTC)
X-FDA: 84077447580.24.608F826
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf10.hostedemail.com (Postfix) with ESMTP id 57A96C0005
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 18:51:48 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bVSsmcSp;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of pedrodemargomes@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=pedrodemargomes@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762368708; a=rsa-sha256;
	cv=none;
	b=Uqj6HGdEDnSzI6cmT3ia3m0I4K6DeMtCpJSYueBNlv+ePUtsGX6EMgW1vFifjH4szSyLHN
	rqb06+bv8x7I6/qIzn2wvukqKqH58H8hI9XCPCWdnfQ6SacaCvWlh+NJG9WyI2xn8UQ3MI
	9dUNCLjdiaXRJUgpcqYv+lDMDWQhFB8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bVSsmcSp;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of pedrodemargomes@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=pedrodemargomes@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762368708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tmLEmnzV4CrNqkySbGU+qJrkaecvk4DLsCPkYeJhZjk=;
	b=X9WEPxGbm/nhTO9LIs9l7yMaTV7vzs1nQygzOaORexa6guOhDbhfSQqmiiw2hVgd1HveL2
	uAVq2MCAyJaof1uWZLn1mG7ujAzosLOxv3weXmpumz6QKfymVBvSW+/0V7IGu+ULVQzVoZ
	79lH7rkapX2tqP1iN0G0V9o9zopqiXs=
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-7aad4823079so229823b3a.0
        for <linux-mm@kvack.org>; Wed, 05 Nov 2025 10:51:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762368707; x=1762973507; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tmLEmnzV4CrNqkySbGU+qJrkaecvk4DLsCPkYeJhZjk=;
        b=bVSsmcSpkMYH+flFa4SwOI98n0/r5MxAdSutXSN4NDDfAz3eMZGruQe5kQU6uV6htr
         uZr9KwLIneHNuP/S0RvDzAPp7+pmGA4e2XHKPRU7wNZ70zH8prFsxL3nqmDEDOtDvhkF
         rY0YKsR6ee/da5JYklo/+SSusVqF5g2bNBqxZGMcJ7AaC8nOwU29mRvFSxcsOlXEhTJ5
         3pZqLSsKzFEgzGwnos0fTkqfnxCGP4wrbf7cayowQUX9pwoL1JY/MgvJjqoP/6MM1Gab
         l4TM2IMtGLwJdIvwCY1ISASlOQfVOaPQO0ZKEMkRsp+wY0mIlR8MXTmitFMr7HcQP0b7
         ZbJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762368707; x=1762973507;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tmLEmnzV4CrNqkySbGU+qJrkaecvk4DLsCPkYeJhZjk=;
        b=J92Y2EKUERZEueA6n0G6B/UQWPN2HKcmGUggwjscViGpEwbNlQERrRZBkh2Z4LGxuU
         joyL1Kf2W/OetZPWFv5/H1frtpyIqp5pdZvjo4L1jCwI06XxtkD1jFRSciE3Cb2ZozOx
         8/H9Dut+AisYiJOezwUj99d4nyzjPzAIQCF6bVssyq8YuAtYP7qZEeIMC8oV5qiRKcUk
         wPZNIxdkIq3Kh0OCHoU096eVnIxNFFZKPUn5LEdroXVYvejuVrfy3NZ/qlBIQbLnfWop
         9e+bhpYQwPbm6mCcGgpD3JfZ2UyLnVB9j1bDpkU+73iFS2vbxnE+IbuonfYN4c96xAt/
         cIJA==
X-Forwarded-Encrypted: i=1; AJvYcCU/ldBbVlWbwQHKaS0HNDEyLD05BNoKcRvl8kTclKcJHCbokzjPGFJ84xU0qAOZGIYyYfk/2boU+g==@kvack.org
X-Gm-Message-State: AOJu0YxuLK+QC35Qbf2H3NUQFJkSYltwUIObCabwHzKFlXEmS0XtzrRX
	73mT2+/uBxQ2C1VQ1fyeNGnHwMO/DLCxziBXeR3s9gt+ujjR/dQjkPME
X-Gm-Gg: ASbGnct+bZQ0zd2iTCfJZ7jeNXwpAVqShCG+On+oZSvC8eHJHggsP6N9YHDcHdseb5T
	RDLCyH/pnX8S80i74dJo1Y4S7IpLxPv+lKSp/MynVRmQRTQ4DuWydXcBrNKzECMdkCU9SEo1QXA
	xDjMgVKJkjXBl7VCyALxiaMXtmI1aCz2dE/IEONCp8YURpYCjHljbFHBJt3mbwig32YByI/a9Sh
	fvVo4nb/3Kk1bsxJNv6Hg5aF8WWZC52Ox5eQl3rzk/HQDBTkJExPgrKhFSLSZhnzvp7JSXhqHPR
	D3Hq+9g2ZxqrOgSN+f+CP2+IRzBEGQCzfZW8lcZCpJ/FdqwfBLKU/31XS2xH1H14MJefN3JT2KH
	P3GlRm9jg8DrAjxR1WCjhen2FCl2032CSCAFBpV+e5i38RpmeIDRUjc/7bVVY+w7Y0K3J8HveSz
	DNAFJscmr4tH0DEL0KcAN0koWTgTaFYUMFyqpPfM/m8GcD3G+l2tW/FSGG
X-Google-Smtp-Source: AGHT+IEyUJorx7igb5KOutnZidsynnr3yECYJZmO9q0c+o5+U9+fi/41fwXrPf0Q6XYPeJTYKLVFmA==
X-Received: by 2002:aa7:888a:0:b0:7ae:d1d:d500 with SMTP id d2e1a72fcca58-7ae1cb64cadmr5041801b3a.4.1762368707099;
        Wed, 05 Nov 2025 10:51:47 -0800 (PST)
Received: from weg-ThinkPad-P16v-Gen-2.. ([177.73.136.69])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7af827effebsm118409b3a.57.2025.11.05.10.51.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Nov 2025 10:51:46 -0800 (PST)
From: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
To: David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Pedro Demarchi Gomes <pedrodemargomes@gmail.com>,
	David Hildenbrand <david@kernel.org>
Subject: [PATCH v4 1/3] Revert "mm/ksm: convert break_ksm() from walk_page_range_vma() to folio_walk"
Date: Wed,  5 Nov 2025 15:49:10 -0300
Message-ID: <20251105184912.186329-2-pedrodemargomes@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251105184912.186329-1-pedrodemargomes@gmail.com>
References: <20251105184912.186329-1-pedrodemargomes@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 57A96C0005
X-Rspamd-Server: rspam07
X-Stat-Signature: x9m39jacj5gdnxebey4h5s4sikns6tpt
X-Rspam-User: 
X-HE-Tag: 1762368708-695560
X-HE-Meta: U2FsdGVkX1+hLvtFjlmQ9841tk/DXiesqKq2lBC3Potg/4CSd7KrNh6tI6WJs8wTCmLVAV2u7yL13Rx9Ftwkj3HnYnuKTSK0oZW0WJLHqC+6CpJES3+3gJHvQULHar9SCN2mDc1ZeGAmMuNMjBZR7MOeMaHfc0DD0e21lUUmSUXoJAESwP4W54wVVsa9fUf6DiwivPb5ai1v06hS7v1CuMdmtvRQgniYM5ZS1Vawxhxm85IkR1UEaMROQClO9iXonfU1nuIaPSkeboBPl5WIIae5w99k6tY6Zj+JHzcNqUgxwgKK9TnaZN9w1ZZ8aOBZuakMcF9VT7nYtxdSST/wlW4k1JYA40QmeiT6XbrhyBZgllabSmGn8oZquDRcvwLpi8pBFNUxr7OnXASDMU029iYFJgq2uIG/MzMwZOG/+RUOiVsuw8OoneioQb8pBRGu/yG7JgsMFeeXtFyZ8b2xk1A1Nwds0GkFP90/aUppYrz26UHOwxAdKsWqVy2K2YNJCXWzHl2jx+BLDxrBrt5Q8aQeIns4KQH2k0XBo8QTeMXrHzZPCgIrVGUsWUVmtY2LERe0E8t6bzqZ8RUqiv5plYxguxM0fneOAqT5O4Zy+RqhvK3iDBxiquB+0x/4hE9Ba5bvRyiU6TBehFxdJxEt5IeiyCzx9dQ6cmCkuNuMSJ/aqsBhjExphbwjqZcmj7HU9xPDfgBMG/6iI0CrzOyxMdbIoW90qVsEz4t2Q6eGKlqZLZg+zbZhhDXfCr46yccoAOAm7uuEuR6LekvEASyEhIK7+YL8cs7krrjXyEXKa4HeV7ZKfdTG8bImLacr0csNHn+ABAabiA5Txay6g6aPyCnXSpxS+RSC9izIlylb0PIqoUcCSgoc9BZd6fr/85mPbv2nN/6FihJqXpiwXrgp6Jf0VpX8oZlrNZrX5XeXNknm8Rbn/1TXfIJGaqJ2mkaV8992PdwkrZ0Bv5QY+hY
 DT/ZMndu
 qJG46TguXFO2UgEWqUCnL9L08MDXV0vmhcjAwDeoou0QPbk0w3uWAQmoE7hDw1ijddybUJXK+UNIzF+Dj38/Vtgsarm1a29fvpSKUUm/mspqeZ7ivXWApm06/BSn6ppCtJVGUWlLUPzHqcPs+o+D4UmNTHSJRmp/TPqixoyk1zRqVSOBlv1eaTYVBdO8wA0KqMAZeYFt70YR/u7GkRsq60YkE++kb9vhVTVnli7QLW/c1vQnrTYlfaym3Suf9c9Fp/YRB33lqt38rlq/WimSLyey3ZSUODjfcTlEaweuoup0lp3soGzQ4BZ8Iuk9AOj7Ec0PjfAC+Lm5SI6BAN2kXoSOKdXV374wwAlvidfoDxuchlHsVaDm4mZ/QRhoe10HE5sdh8XHUxwqTsBU8piQrgR4cUgdlJzyIdG/GnX6I/Oh/IXtfyIO8M8QXKJZ1ni4cavTq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This reverts commit e317a8d8b4f600fc7ec9725e26417030ee594f52 and changes
function break_ksm_pmd_entry() to use folios.

This reverts break_ksm() to use walk_page_range_vma() instead of
folio_walk_start().
Change break_ksm_pmd_entry() to call is_ksm_zero_pte() only if we know
the folio is present, and also rename variable ret to found.
This will make it easier to later modify break_ksm() to perform a proper
range walk.

Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Signed-off-by: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
---
 mm/ksm.c | 64 ++++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 48 insertions(+), 16 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 4f672f4f2140..9f74baf01e46 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -607,6 +607,48 @@ static inline bool ksm_test_exit(struct mm_struct *mm)
 	return atomic_read(&mm->mm_users) == 0;
 }
 
+static int break_ksm_pmd_entry(pmd_t *pmd, unsigned long addr, unsigned long next,
+			struct mm_walk *walk)
+{
+	struct folio *folio = NULL;
+	spinlock_t *ptl;
+	pte_t *pte;
+	pte_t ptent;
+	int found;
+
+	pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
+	if (!pte)
+		return 0;
+	ptent = ptep_get(pte);
+	if (pte_present(ptent)) {
+		folio = vm_normal_folio(walk->vma, addr, ptent);
+	} else if (!pte_none(ptent)) {
+		swp_entry_t entry = pte_to_swp_entry(ptent);
+
+		/*
+		 * As KSM pages remain KSM pages until freed, no need to wait
+		 * here for migration to end.
+		 */
+		if (is_migration_entry(entry))
+			folio = pfn_swap_entry_folio(entry);
+	}
+	/* return 1 if the page is an normal ksm page or KSM-placed zero page */
+	found = (folio && folio_test_ksm(folio)) ||
+		(pte_present(ptent) && is_ksm_zero_pte(ptent));
+	pte_unmap_unlock(pte, ptl);
+	return found;
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
@@ -623,26 +665,16 @@ static inline bool ksm_test_exit(struct mm_struct *mm)
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


