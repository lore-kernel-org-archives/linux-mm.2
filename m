Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3EF7C43458
	for <linux-mm@archiver.kernel.org>; Sat,  4 Jul 2026 18:25:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9710A6B00C2; Sat,  4 Jul 2026 14:25:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 921E96B00C5; Sat,  4 Jul 2026 14:25:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8376D6B00C6; Sat,  4 Jul 2026 14:25:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5CC8B6B00C2
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 14:25:01 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DF7431C3998
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 18:25:00 +0000 (UTC)
X-FDA: 84951920760.09.E0B2D19
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf07.hostedemail.com (Postfix) with ESMTP id 559F84000D
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 18:24:59 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=Fyo5eWPG;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf07.hostedemail.com: domain of anuradha@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=anuradha@debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783189499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=hACWZDGicwLS7HRSY+Ve9L9KGL/6WKzUt/UcgS16CTk=;
	b=h6g5i4lUcE13pC0N2+jxHowNpn3LOxWiMGZAwMd2cNxjkgKBv+5aMv0e5rmIkizOeD2AJg
	voRn2c3JXLP0h+LYMs9lF+Dt7XFaNVYHk/15fvZMCGD8OrNWWjV8toy4EKTZx5YTK0bF6S
	RbonUkz1iJFp3vWwyKf+8MpADhTIWBM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=Fyo5eWPG;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf07.hostedemail.com: domain of anuradha@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=anuradha@debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783189499;
	b=fuCaT6aSG5XCcYa3qpwykiI4zCKuFNKHIIn3ILzMZLEHRZXZAuVrSMnL8K9A/m1ebj5uBH
	tCtQDF6i4xXYtAdYw/JO44NOtAuIMtTMWcWRTgY4Vlo1c4tXrBSaKORUo5Te2YR3JmN669
	/mLontpqleI6Sd949fL8MT3VAWUxdvo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Content-Type:MIME-Version:Message-ID:
	Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=hACWZDGicwLS7HRSY+Ve9L9KGL/6WKzUt/UcgS16CTk=; b=Fyo5eWPGNiFIVwBU7hvfcIvPpI
	VeyyBtcfK0ryqvygiV64lyxnrbR3imVT8eEuXnT/qkZ7t9QIhjBQndhA79bxeI9nAvpTa4llIOAc5
	X7MiN+MnAsvIIiYNuEF9vz0UkYGmBlH9MZ81Z8oqNMvq9J+2nY33SEf+OlWn/8ICi1JaqsNtkO4oh
	jKdhrou1i3o/rNhhs5+Sxapr4W6RSFjYWqYYfS8YpkjXKMMZ7E14YUuJSSO2FZWrJ56wAUWsY3Wwc
	TGBSBqmNVNtPwmdTLy2yrDdOr4ix9wrbHxdsINw6IhhxzVg3rK3PmPfkLki/uTuywCEtZM5mDSFky
	p9ZxJdYQ==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <anuradha@debian.org>)
	id 1wg52u-0003pW-0W;
	Sat, 04 Jul 2026 18:24:56 +0000
Date: Sat, 4 Jul 2026 23:54:51 +0530
From: Anuradha Weeraman <anuradha@debian.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm: avoid shadowing global mem_map in
 sparse_init_one_section()
Message-ID: <aklP82yPNq5lA2Na@riviera.anuradha.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Developer-Signature: v=1; a=openpgp-sha256; l=1369; i=anuradha@debian.org;
 h=from:subject; bh=JzCfrQ/XxMDqEDG/UTxdvbdbL5p0fNeF9l29YuMbLkw=;
 b=owEBbQKS/ZANAwAKAWNttaHZGGD9AcsmYgBqSU2SctZHWggYTjB4X/SMjIOoJ0/VjekLLTjjz
 AgPcjnCslWJAjMEAAEKAB0WIQT1a48U4BTN710Ef8FjbbWh2Rhg/QUCaklNkgAKCRBjbbWh2Rhg
 /fu3D/9YJGjArSgVrIDJ3GXGUYa3J3R7S+DIUnW37DTUMkAhWSODztayoqyO1TRYCQHeoSkJm+6
 bOffnyddVtE8u4BwHTMDdHmSuwN7ZcF9M+1MvqLfGlvMFXh+eM8kaGg43W8XOCu2I9yfi3Qv21m
 vbwT1rgkz2n0NMC1JlFxXr0Z4MOL8MHy/wFZGlr7uodhDY4dSuBIKYQ3AzwB3EGRAUAY3SV3WQv
 P0E5CrWZ9tmfVpY7q0g3QIgDupeVtU5bFTbbu4jzL8lq8eFnOWq704lyccpsKspdQzZoVkWQqvH
 xqXkyZ8JOlFuYi27NcsDy/WmJ54H0IwcaRYKLFO8CBGf9MgG7I2VaAuitmoyuhEtNRe3qK0Qljb
 jKGqs0XowA3qSZ0+q5u1iOoJVgF5HehKHjAGi3DD7R+0Ex9U9uj1CojCNEjXFRo9SIFsjwnXLV3
 PQ+EHQdOmgH3O4RzQh577EhkgmxGgcGio/SLNPVVtyYrZSgH2GhZTArkp+2BwTiLpx85XOG271I
 DPe9cTgV8ceUPe0MKggtqdA9NCD36dKoWD4PtvbwzH32tbrn/MLdvxY0cIGqXDisrRUezEnuOBO
 +3Y/m102GMDfz/VTIYa5gE0jR2KVlF7KwkCuZdyBvnsQ1tuPgpx2HsdzbS63aIbmk9ioymEFwcG
 tqVJESSJ3CIxRug==
X-Developer-Key: i=anuradha@debian.org; a=openpgp;
 fpr=F56B8F14E014CDEF5D047FC1636DB5A1D91860FD
X-Debian-User: anuradha
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 559F84000D
X-Stat-Signature: jp7iijb3sdpy3bq7rqgia6wwptbohnak
X-Rspam-User: 
X-HE-Tag: 1783189499-199082
X-HE-Meta: U2FsdGVkX1+3XKAtWGyoHh6BEsglsxg8aF2+6vgoxE8Dsi6ADkMa/GXHg3mPYe+sqf7EVBYErue0TmhvlSXE1vfJ6c4Q3hQTggNaYjs1wpG7lkNuwLDMRl11KwFGGpFTkSSm6IyB7pnWBr1n29auA+Js2Q6zdD4aIn4uS3VLNl3mQNM5AQFcNiRrxrfcQDFtd1NYZcfr/QKSv6VjThdJu+nUr3q/s/qc0lrTRk5XNmYfd6RrX6C4Po14U/S4W/4REY2uAEum9VIN9DOiukc8CdIL1isEeS/8QbatXldoF4E6BFAl48cUKJfZl11sEaUK1jvlbiPKIUbZwdeH5y75XsXhJbL1H9IQDG6dsb+eKMPqFPCBuhicV18dEilTZpV1u5Dmu5snJrUa1sad6y/nE9ZpRuenLFBMi7qD/xaRWAx9U/PITMzrp9f/M2eSq0SNj5yitfSQIxpZazAKbOyQvdRFnI8RkEflwfo4o/bg//2PVid0vuvkDPDvMe3oatiqtpJcJphoWngAcwlDYXzns7B6p1iiHupMn0DwMyxSLgaH6RBx1xrcMpAou4omJbjEKOGfs4OMGu0v+fMNY2wjSHrDy3v3xjcVcznduYLVkpghHmkIB68xKnbrWN4iMlATDMfMEb6JrLQnSV4cpyE5FCDfofsQXAyOqIaGNbv6EvL0IMkcgA2U+XM5SZlAZo9nw+Q8TXVAuKSKK3vXoU5qgI9+qftkpDaCXBHLRyQTyOUX3zFglgznfSAk0NvWhYCZRHgbNg1TR1vAgou0nu1CGvylTVUWCHHY3EunxVq5dp07ie4S4R2SOlNc1LvHYOQA5mT+L+K1zZXize//oRcKrkAwUjdLXbinH3ErGWlQ5vx4QM23J99pQIZVPeB00v8i29iTDCqdaz08nfIyN1+6C+AB/84qrGWZw/n+g+FH4qETEKwWl+3xntyBfaWk36fH4zVukCstbhxny4YPvwb
 SG0Px4jf
 TeQ55giLxXz8mnAXCJuupDznqYRESxLOOVxENq6OLvMBfJjBCU/85Rw2Bmil53CZPBDsKUGi47Q4ivwCxQvg/M01cdGBNw0hqdS54jChkkXTWAudtPjsJQFBWUl++rvwPHrKJlf0jFwtuh890frVDbe4NfE3cY46Ck4oa8f4DYdTT1HgIRIDXK+0vttZU5ROTN6LYWB8Ybq1sqd6hcNoIxBfTaRFxAJZ3PXX1JB+2p4EPjF2e3uq+XD356OKRHz55IiqL5oDSouehnoP1P3Udf24B0/pGqZY5uL6Us+tx4o7nsT/f629lCZw5mD1VmHcp+W1V
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With W=2, sparse_init_one_section() warns because its mem_map parameter
shadows the global mem_map declaration in linux/mmzone.h.

Rename it to section_mem_map to make that scope explicit and avoid the
shadowing warning.

No functional change.

Signed-off-by: Anuradha Weeraman <anuradha@debian.org>
---
 mm/internal.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 181e79f1d6a2..4943def97167 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -957,7 +957,7 @@ void sparse_init(void);
 int sparse_index_init(unsigned long section_nr, int nid);
 
 static inline void sparse_init_one_section(struct mem_section *ms,
-		unsigned long pnum, struct page *mem_map,
+		unsigned long pnum, struct page *section_mem_map,
 		struct mem_section_usage *usage, unsigned long flags)
 {
 	unsigned long coded_mem_map;
@@ -969,7 +969,7 @@ static inline void sparse_init_one_section(struct mem_section *ms,
 	 * page_to_pfn() on !CONFIG_SPARSEMEM_VMEMMAP can simply subtract it
 	 * from the page pointer to obtain the PFN.
 	 */
-	coded_mem_map = (unsigned long)(mem_map - section_nr_to_pfn(pnum));
+	coded_mem_map = (unsigned long)(section_mem_map - section_nr_to_pfn(pnum));
 	VM_WARN_ON_ONCE(coded_mem_map & ~SECTION_MAP_MASK);
 
 	ms->section_mem_map &= ~SECTION_MAP_MASK;
-- 
2.53.0


