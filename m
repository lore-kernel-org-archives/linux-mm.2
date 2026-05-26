Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 627AECD5BB4
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 06:37:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E26D6B008A; Tue, 26 May 2026 02:37:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7983F6B008C; Tue, 26 May 2026 02:37:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A9826B0093; Tue, 26 May 2026 02:37:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5B8D26B008A
	for <linux-mm@kvack.org>; Tue, 26 May 2026 02:37:06 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2FF061202DB
	for <linux-mm@kvack.org>; Tue, 26 May 2026 06:37:06 +0000 (UTC)
X-FDA: 84808613652.11.6F89B43
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id 785B540017
	for <linux-mm@kvack.org>; Tue, 26 May 2026 06:37:04 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=n7cVM1vS;
	spf=pass (imf01.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779777424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ccif+uhctuZGIQUw0WPWdGf9zBcDJzg1I9E2r4bWeiA=;
	b=COeyYPWTnrmlndyfvRkWLH5UElpwif6oYeHEZ1yt7jpAMXggNB9XFPE6x8g1vMWw2N9vKK
	EbUpjy1fbzbB1HT1PXXD7IVXl9UnseMqLNBS4BSeBX1qmVV5lg8KmURafydYPAWEg41tfh
	FwCp7jG+OSG9h1VYx0kzGCZSqafcsLg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=n7cVM1vS;
	spf=pass (imf01.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779777424; a=rsa-sha256;
	cv=none;
	b=RA7ZH5wzINIzQbAKenUz/uc7OEfow6Z67l5YnEu9BRHz7XCRvbsbvPknuHrTd8YH6ns7Qj
	cntdOUk0slyhooG7HKyVAccfMDaAwodeVKKSPbsEXo2/zzdA8lkhu55gXpQuBlLCSTyr90
	TLj1CI2PYEE79mQR4p7y+4HAoKGsNug=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 51A3C16F3;
	Mon, 25 May 2026 23:36:58 -0700 (PDT)
Received: from a080796.blr.arm.com (a080796.arm.com [10.164.21.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id AE4AC3F7D8;
	Mon, 25 May 2026 23:36:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779777423; bh=Xa/9er1eUX/PuSAWKy037qgiAtOJ0rif1cB6o4Vp3s4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n7cVM1vSlO49MbiHV/Xz81cr3twIDsXmkmVC0yeSEedBCIz4I0/6hsuZsDsH2lUaC
	 Duy482BDdc9uS6iS9Ja2Xv8XlWvuX4PshenBqpYH1EuoOo0WadLbRLB5lmIz3rrHBC
	 Aei6IwKbRCGjkgGaHzQhXAuXIoc8JCV+bfiKntMs=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	hughd@google.com,
	liam@infradead.org
Cc: Dev Jain <dev.jain@arm.com>,
	riel@surriel.com,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	youngjun.park@lge.com,
	baolin.wang@linux.alibaba.com,
	pfalcato@suse.de,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: [PATCH v4 01/12] mm/rmap: convert page -> folio for hwpoison checks
Date: Tue, 26 May 2026 12:06:24 +0530
Message-Id: <20260526063635.61721-2-dev.jain@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260526063635.61721-1-dev.jain@arm.com>
References: <20260526063635.61721-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 785B540017
X-Stat-Signature: yk7nfqsyeddi7xu338wcxy4wueb1mrio
X-HE-Tag: 1779777424-92848
X-HE-Meta: U2FsdGVkX19xvuVbM3rkQsLpbaF4D7kzZKdhqrPuVngpPgJJmqrZFIEB7uD+5WeRTgymK0svY+qtJh9PI1UkaR+eP0MPeFsZm2WW9QmwTsOwnYBJXUQoNS8Jzgr5LPJpyC2UyKwomiLvOnpppwCRMdjDy+tEs8n5tJaWK96sOV3Bg+YxAX3TEYrCRzWuxk9brc8c5TpP2EuboPRYfOSI6KZ8lMY+oAAUDbh/sLOl25OwmhHDrwK9AjRGQ2dj4sdoANoe1TGW24eaarWTDasv6ldbgaCjVGWCNIQ4rYnbJWVat09G1VjwmUHD7zagr89O3V8NjqJC9o41Zr6PMrw6SqxMHqG3ZeVMdSPoDcedYYBGUD5hgulb+8p9lZvnRsy6l/uEzkG038LOdlp4IEUyGGnm6OjKNypjhlRt2Bwx22xntZv/iE4k3wZmeWvKJiFC2jA2ypdI+APVnNixV0Ry6wtDhKWMuOrv8B9BgqUw/SFxrDYGn8FQ18QoX+5Vp7Sb17ZxWNjSfkED/lbcnUSRiZIYdkSP5wRQ/29/WOwJhrW+x0UmY7q6s0kaiRDJan4aFAnFaW22TB33XVOSFeVNEhsywrxkRnH5G+HAo3cxle1GMqA474GW6Qg1a8iHyei5Vme7SgK1uzCl1zVS1U0GNRa2T5ivQiUMiVdOZSRvPjDkNgSOLRaiYYhy2K2s1DDYyVLO/4m0eGSfxM8ax9G9O2in8GLaYz5MwOuis69deZrS5PDbPW20ZfWGh7QwIsl99f9L2Ul8yp1LKtUhUT1mceWC7Cme6wSib4xecoQzOzzV7C2ooImoM1WzXP8vkKA2EXEw1SCcftm1tM68uwwabM2EJe3XWJ2Tn+Cm7Ems88q/yNqfkeTbJt6tOJr40KdtayxYA+JTugNrWc18KpHr8eU9+ODsUI/jXk07tftAwVDbAJrLdP61I4wL9XDGiL1ukXvrZeUNiQqgS28P2XX
 M6MKRgPi
 5FwvJ99S42UjbcPV1Q9RHJVvpbBaneYzVEvtR0LC15Bk0P9bnkNTDenu41hCe2rmPAQZjX7oHIz9KeE/usoXHhNEjyeFCUbGM4EAWCquukEh1tqwEHmV427FogoBTV7o9vbNmEqgKrqjPF1IYsusTF+pTvrHMD+Jn48wn1t5Pvc/gkWDvGr2bzWRe7lMg/Y+LleqGKCk9I1gG2F0R4kGzD67Y/5WA1dWl542i/u1R7/HmBjCVUmVpCqse3yyLJ86FxwOXafFrq0jbFg5jCEEALL9LVg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If any page of a folio is poisoned, try_to_unmap() is called with the
intent to remove any mappings pointing to any part of the folio.

Therefore, an hwpoison check on a single page does not make sense
(although everything works out because the memory-failure path sets
hwpoison on the head page too). Convert these checks to check whether
the folio has at least one hwpoisoned page.

While at it, convert VM_BUG_* to VM_WARN_*.

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/rmap.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index fb3c351f8c458..430c91c8fe2ae 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2116,10 +2116,11 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 			bool anon = folio_test_anon(folio);
 
 			/*
-			 * The try_to_unmap() is only passed a hugetlb page
-			 * in the case where the hugetlb page is poisoned.
+			 * The try_to_unmap() is only passed a hugetlb folio
+			 * in the case where the hugetlb folio contains a
+			 * poisoned page.
 			 */
-			VM_BUG_ON_PAGE(!PageHWPoison(subpage), subpage);
+			VM_WARN_ON_FOLIO(!folio_contain_hwpoisoned_page(folio), folio);
 			/*
 			 * huge_pmd_unshare may unmap an entire PMD page.
 			 * There is no way of knowing exactly which PMDs may
@@ -2198,7 +2199,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 		/* Update high watermark before we lower rss */
 		update_hiwater_rss(mm);
 
-		if (PageHWPoison(subpage) && (flags & TTU_HWPOISON)) {
+		if (folio_contain_hwpoisoned_page(folio) && (flags & TTU_HWPOISON)) {
 			pteval = swp_entry_to_pte(make_hwpoison_entry(subpage));
 			if (folio_test_hugetlb(folio)) {
 				hugetlb_count_sub(folio_nr_pages(folio), mm);
-- 
2.34.1


