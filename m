Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEB4EC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 05:59:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE6306B0096; Fri, 10 Jul 2026 01:59:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBDA96B0098; Fri, 10 Jul 2026 01:59:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFAB26B0099; Fri, 10 Jul 2026 01:59:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BBFFB6B0096
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 01:59:52 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 58AB11C3355
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 05:59:52 +0000 (UTC)
X-FDA: 84971815824.21.55BCC79
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id 93C23120005
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 05:59:50 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=et0TOOI6;
	spf=pass (imf29.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783663190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BK0IGR86LM1hyN2g9Yi6DdafkFe2k1tjJxtSjm5E0AU=;
	b=T/0t8jNSCv3rv4oSxxHDBGWu68AfNv3EyXEwc/MYgDnggFgO/vKq3I6BUCx9kkKay9/jF1
	QeXVWHQWXCQpf5qvkQuEzhlEwb2/ZGAZzLiqgn6W9rSdHigOsZXECTSuyvYE1UG+wYVjYW
	O+it+pPbu5qnndVFG3DIehN8rbEvgrk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=et0TOOI6;
	spf=pass (imf29.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783663190;
	b=cNZATMLdiILNmy8cE8ch7vneo1EGruSEUILBoPVlkfWp5cnChmMwUfWx9eHw8DF1q4EgFD
	n2sVAKGYQq9dgx9PKTOeDR0cPImTyD4aA5FyBRucBFotMcruslnh2PRXxuIxiO0/Nc3qeG
	4++tXYOg+JzVs0STjEPyMr2Q/suA41g=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 916C91FC7;
	Thu,  9 Jul 2026 22:59:45 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 90D673F85F;
	Thu,  9 Jul 2026 22:59:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783663189; bh=FTNvFo8zJJiC9Sw9FEkIdDyjrgMmiRN2wZltHnRPR6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=et0TOOI6ceXcgTO3k2Y3sElxu8IwptHF2mHDX/rWBFcZsPha/M8RGlmRn6sxHOIv9
	 QcPGKmiU+NUgePZV7vy7CD/mtcbeLq1KTmCzjx06iwU9dFN/dgYRK0NXr9ksEgSsbm
	 xL7FioeDuJJy5vyS1ebTFGqpfwPxUDASLyCABHj8=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	muchun.song@linux.dev,
	osalvador@suse.de
Cc: Dev Jain <dev.jain@arm.com>,
	riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: [PATCH v2 5/5] mm/rmap: add anon folio unmap dispatcher
Date: Fri, 10 Jul 2026 05:59:14 +0000
Message-ID: <20260710055915.638659-6-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260710055915.638659-1-dev.jain@arm.com>
References: <20260710055915.638659-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 93C23120005
X-Stat-Signature: mq1sgj6fe7qfnh86xrsydrhn7jdpb7o5
X-HE-Tag: 1783663190-847578
X-HE-Meta: U2FsdGVkX19Xay418NwTE1QO58gAMXiP+OEbQ0h/bkqlqP2o+3g7roS4K2gesPP5M7xTC5Toj6Hiu/JAw963+9X/y+n8yVUwRqgZBghd0zzEdhMau9AyjsnGXjUgUmIrsjhQxbuhBWDP6XI1WU23QTZfVQN/LbatTcYYmX3VG6F5uXRw8r3IBJiZNGg47JfsjF4RMi02oKubRkSVQHhfEz+y7xh7xLJeW7Jpd7wAwbw8rBAF8hblZ/gp4RWxXNt5iWTgQoKHYx1WY0BkxvvSEqO++qA4xegm5IJ3dqKnlujC3jIs615snh9+mP0YgB1jWxuXo8B2EdcHfo1AxqYYDK0s6l64Kivna55sfawjLfPFJ53vr8Jn0wV1DcGYRazdF7wClh+GoY6P5Fi2ehRn42SInzC/yaz3P9K2J6k9l8RC9NEfONxTdCDLMhb+kTU1Xj8UVZjXK1idO9YaFJJYhLpNz/rjKUzo3XCS1tn0Epov487qkYoRKMdb3xD8lu45zIB0gdyENiSe+37IrkUoOOmqM66JgtkgSfNLEa4UACWQSXV6Iwc4wy15+4assiN6rvsOJqWWsqNHskNvra/QVaZ8aIEsoplKXBJdYcX5jl2eo7ld6M/9gnzpbnDUoQDDPtJF5It4rHZyDPVGfUJYNtBsfGYiAXWqbuKLpfC6Q8sqRb2QJDGojludhfSn/PnC1Pe0GETcbWOmuPW+7HHtSw9dJUWZARpU0M/z7Lr7cGqfX4IZLLqD+m8T/kj7LNfm2voS0XedzqDLiSnbj0jMX90+n0rqqpe6te21Tob3VMeSjc2JoQPUR6Csub/Ci/EfGmJyxyljTfsKIjN83Mta/VRMqUb9Neg3T5e8NkcetXvtcOnwzEQZqa9tm64wpkSM+tBFpFdB+udnsnJVTYqiho6uR8yOZ+oiECNmSKuC5y82xEQH1mKNyO7WKDKxzfWYBAlP9onTdzyEZOA5HV0
 ifh/4Y/Y
 HiV8YuVlJn1QECtWlaNfxPfzRI7flbGiA3mnGFzRYqSYHD/KfM939VoqwmPMtgZddl3yjhUmTc/GO4HUEqZ+mrZjei+GMwhtqQl78gpIbCR75N2FW1wDjPcBUqf6cCD+CXKtXsCPJPcyxcHZYOTGfmaxg9UUPaSxImMEh4IADzvcKWl0iN8SWKqpy9CkKwTUYIBfsRAbJgIZ/QoFowX8YavA3oTbCBSG4nKwpBcSIOBtxiL83qFx6b/0KpA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add ttu_anon_folio() as the common entry point for anonymous folio
unmapping. It dispatches to the lazyfree or swapbacked helper as
appropriate.

Keep restoration of cleared PTEs in the caller, where the PTEs were
removed.

No functional change intended.

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/rmap.c | 47 +++++++++++++++++++++++++----------------------
 1 file changed, 25 insertions(+), 22 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 68459f23f5c0a..55aa3ff8bf216 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2172,6 +2172,28 @@ static bool ttu_anon_swapbacked_folio(struct vm_area_struct *vma,
 	return true;
 }
 
+static bool ttu_anon_folio(struct vm_area_struct *vma, struct folio *folio,
+		struct page *page, unsigned long address, pte_t *ptep,
+		pte_t pteval, unsigned long nr_pages)
+{
+	/*
+	 * Store the swap location in the pte.
+	 * See handle_pte_fault() ...
+	 */
+	if (unlikely(folio_test_swapbacked(folio) !=
+			folio_test_swapcache(folio))) {
+		WARN_ON_ONCE(1);
+		return false;
+	}
+
+	if (!folio_test_swapbacked(folio))
+		return ttu_anon_lazyfree_folio(vma, folio, nr_pages);
+
+	/* nr_pages > 1 not supported yet */
+	return ttu_anon_swapbacked_folio(vma, folio, page, address, ptep,
+					 pteval);
+}
+
 /*
  * @arg: enum ttu_flags will be passed to this argument
  */
@@ -2352,31 +2374,12 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 			 */
 			dec_mm_counter(mm, mm_counter(folio));
 		} else if (folio_test_anon(folio)) {
-			/*
-			 * Store the swap location in the pte.
-			 * See handle_pte_fault() ...
-			 */
-			if (unlikely(folio_test_swapbacked(folio) !=
-					folio_test_swapcache(folio))) {
-				WARN_ON_ONCE(1);
+			if (!ttu_anon_folio(vma, folio, page, address,
+					    pvmw.pte, pteval, nr_pages)) {
+				set_ptes(mm, address, pvmw.pte, pteval, nr_pages);
 				goto walk_abort;
 			}
 
-			/* MADV_FREE page check */
-			if (!folio_test_swapbacked(folio)) {
-				if (!ttu_anon_lazyfree_folio(vma, folio,
-							     nr_pages)) {
-					set_ptes(mm, address, pvmw.pte, pteval, nr_pages);
-					goto walk_abort;
-				}
-				goto finish_unmap;
-			}
-
-			if (!ttu_anon_swapbacked_folio(vma, folio, page, address,
-						pvmw.pte, pteval)) {
-				set_pte_at(mm, address, pvmw.pte, pteval);
-				goto walk_abort;
-			}
 			goto finish_unmap;
 		} else {
 			/*
-- 
2.43.0


