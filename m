Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1100EC55171
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 16:27:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A6696B009E; Sun,  2 Aug 2026 12:26:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72FDD6B009F; Sun,  2 Aug 2026 12:26:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A8B06B00A1; Sun,  2 Aug 2026 12:26:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 374346B009B
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 12:26:45 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B329B16050C
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 16:26:44 +0000 (UTC)
X-FDA: 85056857928.18.2B95944
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0CA47140009
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 16:26:42 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VPP1daxk;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785688003;
	b=7LPDjFN1XuYOsb8pzma40nscLqxDzYZkvJxfefUv/U1VMFpnzhQW72iMTJUzsykdEKKGlp
	K6dEI2WQx0sNP2dkjzIIUAMVwYKbYj4yx0zdyIP84zYkkGqnQzGwLLpsdNtnje5ISO9elh
	wjeIVV4L1tmo0/9UgKiXowC1bSQga+8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VPP1daxk;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785688003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nSTjwnDV8A+NiGPVQu+FC6bukzN4Edj/bjp5VqLzRxU=;
	b=E7/oN6fppjBsMuHhPdppty5AoLGJKvugIMl7l0uyharXl8xcHU5XSI5Lq5KRX5n714MnvE
	HBUWOW8al1GZBKUtz17T5vyG8iDXYoqAJmSoWm7ca4prGJWIo/E/FOD+fZvTV9MOhktND3
	miLIitmJ4mGbZYo5CMO3ETtVnR6A4fg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4D25E43A60;
	Sun,  2 Aug 2026 16:26:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F13D41F00A3D;
	Sun,  2 Aug 2026 16:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785688002;
	bh=nSTjwnDV8A+NiGPVQu+FC6bukzN4Edj/bjp5VqLzRxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VPP1daxkJXKjw19NUc7Z6RGkRDyWKUmVdKkYofrxQZWt8lBLVZTvam9kiHMe1LwSf
	 eHKwTdEIgn9wBVNn0qj+sXBU3eCkzVzzI4eWILMp/iF9v9VRe/r2AOw+Tif9jBWPgm
	 GvaHlqsVooEvjw2hbbfg19RwBT1P2TBs3IyrYe5MN76ybOdaVecZEAkdhdPQuu8lUS
	 7bVvIDnhF35q+yG8YusWGJuMq6ffaSU9/ekxHOrwNU4mzSsJYqEoUtu19TjkmNx0Lu
	 5FavlCCTIB8ptfqY4M8NhWR/IWyFIQPJQvUiZJW0MyDlEX+8JPjjRK0fTincYLI1CE
	 FlSURFfAZcCCw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Yueyang Pan <pyyjason@gmail.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 5/9] mm/damon/vaddr: respect folio end for DAMOS_STAT
Date: Sun,  2 Aug 2026 09:26:26 -0700
Message-ID: <20260802162631.90304-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260802162631.90304-1-sj@kernel.org>
References: <20260802162631.90304-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0CA47140009
X-Stat-Signature: 9y9coxtg9z963jthootdoq6smfzw51i3
X-Rspam-User: 
X-HE-Tag: 1785688002-37401
X-HE-Meta: U2FsdGVkX1926+dU2N4mjpjUPFPqGJ3a9wnMYw/349T9ZORWng5gmlQJzJ+K8UOFcY77qVkt2i95fJpuRJmuPmKcvb+2LVp1Xqe3s5MBdv5whBBKg4vii5IW6mJEB1k/A12FEPq7kcbsbC7nWE1Joxha8hkGNmJ1WF1Ku05oTHp1Kl8QNOtZXC6xwsrI6lAaQ48yKe1IWaHp9fTzFKkuytcE66RTB4e0MKGk1WzrkOnnUbs/9QPVhI/oed4ZAnWUSgftlikMKWZD0WOwOrEvt0phd3ajlVVM5cCdSajokfhfvPy8Zkm9C8duSC8o0agCccVLeF63ASv3lryE/YL+9gL7QJjeQ8sEK82x62Vy4dDK/fNqBSr762DAcQTstiYb+6xXVfc+3kcVPPiwx9/+n/HEc2HpoMeQeXlFMAPuTQ78jHY2z+9UrwfhDjW8hSqf7XsaVOdGuoKFSbglJXlNL5+LEt0+gwuOABp5rRIq6odA7dKLwcmFp9yFFdMTnCQYkdDqnm0fZ0+5UYEwXlWqqsc/rJ7osArHVKtZRvPd6+t2Dp9fNw2K86HcI8RObeGloHBVByE51TEbc35954Ks7nMNMAHvzjTOMmL0TSTN3J8eFfVag84S5jWg/UN3XJVZaMsQuMLyKsyCE1BoDfRQ6yQQMCRjA99HC9651bQWcjMQy9DuAPzF9i69+aJSLS8F+li+L7KbnkBL6CSfNevyrQkdjEcUoD+NqRx2MHMu/FTooRHWkB6eGm3q7j4DrZ/z3RiSCPXGjDeA7Rw8jwmFyaUk2UkJBF6oQ3cGyakpOU4K74MZT//6in/0nUSOGkEXKEzmCVYPrOPNIuX5wv3vR7PcK+7Z2zfwqhpFnLNlxfVlypIjgHGFvvMj+XIDqLmlTMvejsv5jFZrek4AWTw9sU4zFc/mYSFLyxF7UB8cf5jlJZ4o/OC39Z45JBG4pb3/T5/YoqDXsU0OqbYFwVZ
 mnlt/qU4
 AThHCGFQn4BizQJ1G1MXzo+yZ8gusEFbZ5JbGbicsVg+rqtObyreWUOJ0HBUL7jSw+y91QVa1bf70DjF5l4k2NADCDIUXgDawMmSX+z0RdYn9njG9kZbBmhfCtJVsvpiocP8LgT47sq1WbIu5gGiZByOOwvhaI/2lBgdBPtDT1zw5X+sTboot0UxJL58FZh5QCI0JDywqrfNtFmA1ivYdVRhXQfjDGEa5kFpu8PVXnu7KSo6aK+Up6jTrAITfnkJ8GCXUJpJWcS1wCtrOYvScfY4XGg==
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

