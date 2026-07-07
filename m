Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB8FBC44500
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 12:12:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA7656B00A6; Tue,  7 Jul 2026 08:12:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7E096B00A7; Tue,  7 Jul 2026 08:12:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C94836B00AA; Tue,  7 Jul 2026 08:12:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9A45E6B00A6
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 08:12:11 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 287DBA03D1
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 12:12:11 +0000 (UTC)
X-FDA: 84961867662.12.04FBFD9
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id 72A13C0006
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 12:12:09 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=UeijZayO;
	spf=pass (imf28.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783426329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+zzrJMwJdxRlUSfSMas0l+O+YdZlJTvvuvigq8zM54c=;
	b=7Xn8IRmm/RejRJHfvPLYaZDruWVAiLMNYLFp5wWJ4UoZlKCggALQh119DAI42JfFm7UWD0
	Z8ZAV+OhEexcoud/WvSbXwJOhCzjxhO55VJckBKqkORG8EmtyXGuzAKbWlE0+T6ZIM1L05
	savjRCfMYCnjmQDqsQx9GH0fLc2cEkU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783426329;
	b=KOycwOJz+leMU3FASW28r4hWuRe6ca3+6YZJtBIvqC+7RrdrX5pp6ftAyF00m870pkAubT
	ISG8ZvuNxPDGliCJRZJGKsikyaPfUurqILx8Ukz5Ka3iqLbJMel3ilK9a233skzMahQt/1
	Q9Vd5W4Gg95cE+ZniRijL7UC28cA2so=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=UeijZayO;
	spf=pass (imf28.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1FD812379;
	Tue,  7 Jul 2026 05:12:04 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 33D823F7B4;
	Tue,  7 Jul 2026 05:12:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783426328; bh=poxfCcDCcSPlWq8ZXKhYROLqj29INPweL+jWzNypFRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UeijZayOl4RX6iWdhmgfKB3RJYGE+jJj7uwMGXeD4JnJB3n+G89+nlxckRhgxKpD1
	 TZrb46rms+a4+/A/PDD17AADhs9YnpBEXgyPZ4scZ3j664tiAVIV207rzc4qDASYqK
	 PHE/pHQ0hD0jTlJIzekXCQrFiVD9Zrc3mfkrDw1Q=
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
Subject: [PATCH 5/5] mm/rmap: add anon folio unmap dispatcher function
Date: Tue,  7 Jul 2026 12:11:23 +0000
Message-ID: <20260707121128.373192-6-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260707121128.373192-1-dev.jain@arm.com>
References: <20260707121128.373192-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 72A13C0006
X-Stat-Signature: 4wa7trpowfrwmit1hodfm151q53z1rpz
X-HE-Tag: 1783426329-306380
X-HE-Meta: U2FsdGVkX19tz8wD0Znhw8FYSHrZjyTQP9vfoFVW9EOH5QhShsSROmMOXXZ35Mz6JxFCNSKBQ2AaYNo3wgUkSlmJX7yUJXA0d5JtMd5292Sy8PEwBUV+0o0BNqWTMtn1Jd1lZdNyWuRkhrs1u1ATZumdTebP35n3RO1vkPqx0FN0gArCImErYQO7hD+6hb4sfbc3gZH2VESi0LheaSISq7At/kGBK8EY+buW+JxUePK9rlIeY1Ii1e1DuWAHU7CvXeWtFfxJ8Gh3zLM2UZk4b679aqp+5kseLraJ10BksKqDdOBXIC0j/CFj/WAstltqWbhWsYZg/uJ811vSMZE4bSeuupm2QfvWg/4vc4/L77PiGS1FLY67fMuWs5fO8BHe7PzZIwNm918NoEwrmk5gmo9TO2UMxUwyvH7JLjh158/2jtRb6s2Ug6gT15yFpNJEgQpxFPxOFu6urI1M1obkQhTWeYG88Qnwo4mUwcZIuvn7McbfhOM7SYxIx/vDc4oyCPtlnrpMnyOYksrl7+Rd1f4Ib1hKx5cEfMnp6aTMqTXbGQYs2NWMAIbQbVIyAGWt3hfIsQibyr5/pfLISFQjNIeb0dhZJ1MDGTxL8n/NGnj9EfgBBcABi0heCPVKhBhjgC6ulyydG84DxA4eVvDlK2VEjSyBwGPiEpm96ZnbqByywOcXCrai11q74TCv9rZuFSFOs2cFqMOm/u+au9FSxGsOA3pb3I+WQnDcqeSb7pcO95Sbq+NICLVFyerkg34g/9imOsb/zP7ou45Dkbl30k9cCd8A77i984sgYBhWYAK2AFe7J1e6WyN/UdYTO+bNWAUhZi/kl/YH7yqC4PAi60WV2k2lmZJxs0M3Or7KPS71BbVUtzv0ZfdF3W6i34Ye0SZoJ8ZAUdBvTY9XV4SDF/RY8dYdo8I+uRqR4wimsF+2Zck1PZFgDshY0xa7qNGr/nFoygX3qQYZkKOL1lL
 ysF38iEj
 cnEVt6xKLnNXkN7StwZ2OuwOZba9gl8a8l4ENptLo3TNzZP1+wlIeenVTmTCBRDvLtXo0BCa6ss0FNEWDxMxIzTxrWYinZBm0OtKzPUTGqnSvyFAk7lwPxJ64HdX81LbdC0NbVldu6borXfPArAabL11GtMCchpd/xZYhsdKxCn/tc0qmMKYs+lPCjl2GWb1YDn+a29V8VxSohIl6B3GwgETTCmcBBEzIQbAXkiT0zteyPKXDJmR9xDgpSg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add ttu_anon_folio() as the common entry point for anonymous folio
unmapping. It dispatches to the lazyfree or swapbacked helper as
appropriate, and centralizes restoration of cleared PTEs on failure.

No functional change intended.

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/rmap.c | 59 +++++++++++++++++++++++++++++++++----------------------
 1 file changed, 36 insertions(+), 23 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index ade78df5be2bd..f021ecd51a4a2 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2171,6 +2171,40 @@ static inline bool ttu_anon_swapbacked_folio(struct vm_area_struct *vma, struct
 	return true;
 }
 
+static inline bool ttu_anon_folio(struct vm_area_struct *vma, struct folio *folio,
+		struct page *subpage, unsigned long address, pte_t *ptep,
+		pte_t pteval, unsigned long nr_pages)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	bool ret;
+
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
+	/* MADV_FREE page check */
+	if (!folio_test_swapbacked(folio)) {
+		ret = ttu_anon_lazyfree_folio(vma, folio);
+		if (ret)
+			add_mm_counter(mm, MM_ANONPAGES, -nr_pages);
+	} else {
+		/* nr_pages > 1 not supported yet */
+		ret = ttu_anon_swapbacked_folio(vma, folio, subpage, address,
+						ptep, pteval);
+	}
+
+	if (!ret)
+		set_ptes(mm, address, ptep, pteval, nr_pages);
+
+	return ret;
+}
+
 /*
  * @arg: enum ttu_flags will be passed to this argument
  */
@@ -2351,31 +2385,10 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
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
+			if (!ttu_anon_folio(vma, folio, subpage, address,
+					    pvmw.pte, pteval, nr_pages))
 				goto walk_abort;
-			}
 
-			/* MADV_FREE page check */
-			if (!folio_test_swapbacked(folio)) {
-				if (!ttu_anon_lazyfree_folio(vma, folio)) {
-					set_ptes(mm, address, pvmw.pte, pteval, nr_pages);
-					goto walk_abort;
-				}
-				add_mm_counter(mm, MM_ANONPAGES, -nr_pages);
-				goto finish_unmap;
-			}
-
-			if (!ttu_anon_swapbacked_folio(vma, folio, subpage, address,
-						pvmw.pte, pteval)) {
-				set_pte_at(mm, address, pvmw.pte, pteval);
-				goto walk_abort;
-			}
 			goto finish_unmap;
 		} else {
 			/*
-- 
2.43.0


