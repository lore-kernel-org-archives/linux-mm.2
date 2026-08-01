Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BA38C55173
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 17:36:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F7F36B0092; Sat,  1 Aug 2026 13:36:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A8D36B0095; Sat,  1 Aug 2026 13:36:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67D3B6B0099; Sat,  1 Aug 2026 13:36:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 372926B0092
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 13:36:09 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C33E81A0366
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 17:36:08 +0000 (UTC)
X-FDA: 85053404016.26.B8DDEFE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 38B8FC0007
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 17:36:07 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="LXIkgE/P";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785605767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3oTPCb+uFC9gTUspvXroRLy6myVSMRGtc9G75nT2wA4=;
	b=jrXB1DH3SjRi+fAdUPhtDnBxNe7RdXxpOALpOC9ArKdJqRZUgE5s1kZnBWhZGltmpNoacF
	C9dFU4ORWBeYs7Atr8GMHpAKQDcntlf+qV9RM43AAooYJz7VODfI+W3g5GugvlkRMJdyEh
	7kuAZ2HcCQ53xBOmx1UBLw2imM72m1c=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="LXIkgE/P";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785605767;
	b=2gMbrDHfiTfnLnPU/TtqjdLJv9CRIGqTbea65AHvqFJF+fD0tGN5DMYwYin4ht78O9Kibh
	F9ZSOaoiioluXta1esnEPivpKrlm01puJAW8tVQdYJ4eBcXOEuPsfG6HCtHxyN/nK5WZwv
	V9O1NPYa6iKE6czk6Vd4u5hvAB3+6bY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4E13A43C9A;
	Sat,  1 Aug 2026 17:36:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC44B1F00ACA;
	Sat,  1 Aug 2026 17:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785605766;
	bh=3oTPCb+uFC9gTUspvXroRLy6myVSMRGtc9G75nT2wA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LXIkgE/Phl2spAH+TaSyI40fQBmMzX+oWb52mHp0kJwWim/1mkUMIhuNY3V/tcF4T
	 3lrnLEjOjMIzN+DEJCrxS63rvxgnAFvnp+czaAxMnIlaBlnsVyP/s48I/+TVepo2ih
	 xkyv+OJGUoj3WRZgbkWJE/4YcaadqkZE1OO0VSaQUliAUFiLnT9kLzXJVgr3E6yOlr
	 CK+624jhDvtzDVMHTTEPAjynRHIBdZ8e3R+uH3ZxhjcIEOwZsMZOaLXDV9Z4485Fje
	 L2VHQaKUn0NUwhwQT+le12y4kzL7auhIjShTi37pPhVGiVmA52INz2J2p4NYhCtGbY
	 dWlU81TwvsVzQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Yueyang Pan <pyyjason@gmail.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 5/9] mm/damon/vaddr: respect folio end for DAMOS_STAT
Date: Sat,  1 Aug 2026 10:35:48 -0700
Message-ID: <20260801173554.94710-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260801173554.94710-1-sj@kernel.org>
References: <20260801173554.94710-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 38B8FC0007
X-Rspam-User: 
X-Stat-Signature: xgci76o33qfraaarodnq3j3ihn3mtr17
X-HE-Tag: 1785605767-71945
X-HE-Meta: U2FsdGVkX1+oykkZplGd4Kc0maE8snQMDh/Sqh16VNr1Lc9ruRb2fvq7E3Ac41rludB2Vuj3YDB714WjMpsQ1UX0ISYfFw5GHkTW0zXw9FH/i3Kw621gtd2qYj/ldV7eWc2v9ElFGRftn+gWSVHIrveroBS6v1ni0O9SWluExbGEIjrBsFVWUvO41bSk1t8DMfPqg337vAJTRWNoF73T4+e/ut/OH6HdDUqhjUoO+J3vQXMwOikZqpLli4iCqcYxCwtC8mSUhdDt5K/YwMJ/Nj817dVNva7mq0mShY88y97Pv1ON4KtAuKR/W8lWrL8lMxDiSMJ5PkXJsqJ1fMvp9P4Ko/BYJWCfcCnnHDERiXdvspPdbUi761MtB7O/QI8JuOX9n0CgjlID0782hTdmiQNGyGTXwYHZYMWcWhpso2lpV3D+IRlcDMlZOeq1GcuQ4LgnY49LQdDiTm92YKdYFVncHl3fFV0OPBr9a1Dnqc2uPYRJ3TWNs9PVcLETE5iZDQ4OJF8JliTkn+q1a0tOfwdqLAlG+8Sb1KFoKcQIqcgoLwkiDH8LNT84dKN7CyfeHHAwxDV5fQu3sZiT8Pd9nE3gdiVkKDZaulRKUMbUQyOEuKtPkXiFY/g+Nzi3ffiTGvgDn2yhMi0ltLudqrox1ggbVp/0YKI8i2XKY2TjFmKLJjPvzhVkr5UM1j5vY/A1wKTK10TH42b8EUiuvyYl+Qw1dCscMAW22uzf30NZl/9PV1OzVoFtOS1Y6DzOyVz5vwp2PoxE/akMOWOtvMQMwzGRhg6GTYeF6D+WffJdk7q8GGGVoDHRYKpNm3MjD2m24j9kTjQFKPa2+0ONP2GKTEsU1mEzQC14neABW767LNUakdrhTyGIx4bqlUfOm/xAoNmt03XHoZMrW+CZJzUKXQVSc7HzdxbptmOlTkOryVfPs9vsF7J8fNA9Q8yU/lAMffwhCO04YuavInnJcSC
 Frw+c2xU
 qXCM7BmdrviGoxh57NzGXqFyz9Uz5zRxq5B5XxgaRM5EZxkZmi0aO0SKsgUb3uu0gAs+m6ephaVrc0KFWmXgUALSSwz4gdZ3Ky93xraIiVQKvAl51Qc0cmWALcc5bvhY/GQz40KXEFCyL7vlLEAZokf2WVpH1MMQjzEpggW6A7RDxolsQnxTQQ8VNJRFZNC22Ck2LULPGzoccZddvye6GeaXqroE6mYsPEKKuaDCVvCYYKBEPKwZ7R9iXpUTrDrz60hN0vAkpZddXOz9vphtcd535ew==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For applying DAMOS_STAT action to a region, DAMON virtual address space
operation set (vaddr) calls walk_page_range[_vma]() for the region.  The
pmd walk entry function, namely damon_va_stat_pmd_entry(), applies DAMOS
filters to folios of addresses of the region in the pmd.  It starts from
the walking address and advances the address by the size of the folio of
the address until it goes out of the pmd or the region.

Let's suppose it is for the first pmd of the region, and the region
start address is in the middle of a large folio.  Also, the next folios
are small.  Then, some of the next folios could be skipped.  Fix the
issue by advancing the address to exactly the start address of the next
folio.

The user impact is that the DAMOS_STAT-based page level monitoring
results become inaccurate.  Since the page level monitoring is supposed
to provide relatively high precision, this is definitely a problem.  It
is arguably not critical since it is only monitoring quality
degradation.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260514015053.149396-1-sj@kernel.org

Fixes: 63f39737d1e3 ("mm/damon/vaddr: support stat-purpose DAMOS filters")
Cc: <stable@vger.kernel.org> # 6.18.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/vaddr.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index 0648400b2d65b..035cd509f6b58 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -831,6 +831,8 @@ static int damos_va_stat_pmd_entry(pmd_t *pmd, unsigned long addr,
 		return 0;
 
 	for (; addr < next; pte += nr, addr += nr * PAGE_SIZE) {
+		unsigned long page_idx;
+
 		nr = 1;
 		ptent = ptep_get(pte);
 
@@ -844,7 +846,8 @@ static int damos_va_stat_pmd_entry(pmd_t *pmd, unsigned long addr,
 
 		if (!damos_va_filter_out(s, folio, vma, addr, pte, NULL))
 			*sz_filter_passed += folio_size(folio);
-		nr = folio_nr_pages(folio);
+		page_idx = folio_page_idx(folio, pte_page(*pte));
+		nr = folio_nr_pages(folio) - page_idx;
 		s->last_applied = folio;
 	}
 	pte_unmap_unlock(start_pte, ptl);
-- 
2.47.3

