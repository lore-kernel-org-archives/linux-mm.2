Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD4C3C61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 13:13:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E56C86B017E; Tue,  1 Sep 2026 09:13:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDFEF6B017F; Tue,  1 Sep 2026 09:13:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C592E6B0181; Tue,  1 Sep 2026 09:13:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 921C36B017F
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 09:13:40 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 67795C03FA
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:13:38 +0000 (UTC)
X-FDA: 85165235316.16.550CC9C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id D1A8D80009
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:13:36 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O4pt0221;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788268416;
	b=mwFSe4tgdDctshb1dHU3PrN/mBR4WjJ9/kcFjJq3EI1ERiyigGqm4DGLhc9QSEE0Mu3m0M
	/7y/Z2r1eWa/CN5la3t/0/FMwQy3gY01J+Eswx44ryX9YQuTSzpbRUCdnyLM46VghL83R3
	K7sbFfxglou/rC20lwpdEhd0o38KBFU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O4pt0221;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788268416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nSTjwnDV8A+NiGPVQu+FC6bukzN4Edj/bjp5VqLzRxU=;
	b=l0L6cvh+mlRwoZoP1KkLpZJfTCDeYVUp5oF79RYu4L+Nvrex0WU4GC0MOjhMHtXuv7l7uT
	fFs6L3lGrXg89mk6DcXwFY7ianzRLyI+Cv0/7Xgfq1G1XoTyJjbSZdW1QPzT2jlwboitK8
	rGZZpQa+jQFxcZbDeGFbaT9IF1+NfXg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6603F6020D;
	Tue,  1 Sep 2026 13:13:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA72F1F00ACA;
	Tue,  1 Sep 2026 13:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788268416;
	bh=nSTjwnDV8A+NiGPVQu+FC6bukzN4Edj/bjp5VqLzRxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O4pt02213qlx6vaOUorj4+qScp9QUGMdKg0r2z7Ig1+cTKFLdGATxgOPJmG+0ausZ
	 9k7uxgUAbpuj1hA2+pe7xKB9/ya+XvAms303tM+x4cVqEKT8XVnbEGYCgBYdl2+8zR
	 NT4u3lOIHDm+eDIXGl9A22qGzY1KWJL8UXKa4WK2fIuKlN+Yeo7mIbBMhLdrw+Zc0O
	 e6Lr/ANyMNKg3RHSWVhgEJm1RZQOapI3KuQ2uAKfzH5n+ZTA1DzzdPDLsFHuYvUEp1
	 lJj2cwxm2pQr9wtVpR0Pgx63/x8BcbQBW0qufPtI437MoV+XatD9W9DN9mBIlcQpgM
	 vrGgioAlPAYVA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Yueyang Pan <pyyjason@gmail.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 3/7] mm/damon/vaddr: respect folio end for DAMOS_STAT
Date: Tue,  1 Sep 2026 06:13:20 -0700
Message-ID: <20260901131326.97615-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260901131326.97615-1-sj@kernel.org>
References: <20260901131326.97615-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: yfh14mkbd8a9o19np8kqtzropxzd9jd5
X-Rspamd-Queue-Id: D1A8D80009
X-Rspamd-Server: rspam06
X-HE-Tag: 1788268416-252550
X-HE-Meta: U2FsdGVkX18KxM+wFykiwP2Q2jdf3qCWd9l024LPWKipcw6DMPamc/O11dFRqXQIv6n7ys0JP8FUmo+JsRP2atRFodtDGVhoLioefmD7usiZvliC+il0u1Zagwkup9qurCV6nfiVBCVtSiBkWFsbK+6JwVH+HqM+h0mVgPkjXzvVJLCW0CbP4okJkSvW+g0h4Z+cm/TVQCueEt4HBFyU9CbvIHJJtS4BGjDBKGuLMHGEKwFo1QT8lBilg906ck3T+xassYH3MKPEf+stkt0RVnQghk1YpXXaZJ7q6mqi2evsuBhjgLdIkZA6f5OF2ARfIWR7PGeMbQgQA0xvAEZ1sRsBNWCPxnDG3teZ3PzEOcY1UOjjxwccfUt2hJazmXp7Y2NP8TkU9LfaGxoVUe7FiNr3X09B1HO/4BntSyz8E7IiEj0fg8ukHWCV706Rp21qMRfU9p6L2aOddZF3FAAjTcEcKgQvR9FpoGoaqDTE8Cv2SFzIIGkqe1fxNRFedFaO8oGM84IeVFJ9ZJ8Oybw26pX7RalLDOCsI6Z7tuxBctCFrC6jNCgQn1g8q1t54OC+S+3jUYcFCIy80j6JcjPO/ctFBKDml4bJo6k+q7QbacmQF4Nui3epov8kclh/K5O072iVXWYZ/EL0Hb8CqgwSw2doCkuJpXxXjj6uU+oea1+sk9f7v/sE6RoZq1Z3McCp4/N9M87gG03wkOidwpURwy3TCuEpSPUGeu6M6lalnMng87tulKWtx2k+NStmTe++xJuhjxLSSbKfADzdMUUthpHfNbZU/pe/AHrY29Uac9yZSucvnyGe/VHlGCJEusVde0+crTz6+Iqg6RJ1KhBeh9W0lkJ1Gmr/9tCpPk67Sj+e4XyJLC3MHzlaF3RECMQN/HvKEL9/eTy8vclekKxAn2j+lC6A0P+zPjcDu//tKyiBBUNUzSzuEYTGimMZzzlAhE1R8KVLWw/4cC1Jbdj
 hdblNPYU
 CUA4J9CujoMHtljbp2gJ2UOI0//qrfYL6V0ESAvsdZcxo1Gk98avM2lYTP/0KFG9E7Xy42oqTA9x+HSNmWskHX28jf+R1AIhvskgZS76QW/kySfuh8zn45cOnFvfIMVRJjQZ2azaLqb6qJiyyVaZ+X98PeXaQ0RGMJ7ulmD1B7R64to1FywR2S+zsg9jipdx3HSTxkX7Im5j7OvaeitC0XxirgNOd6FxKGQsVimHBmzTCTL4YDFp3GZl9EYlbtEBjoUsafb0rOA9/CiyZzz1jA7+/lg==
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
index 0648400b2d65b..4b0b5edf67952 100644
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
+		page_idx = folio_page_idx(folio, pte_page(ptent));
+		nr = folio_nr_pages(folio) - page_idx;
 		s->last_applied = folio;
 	}
 	pte_unmap_unlock(start_pte, ptl);
-- 
2.47.3

