Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78DC0CD5BB8
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 19:42:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 585496B0092; Sat, 23 May 2026 15:42:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55BD16B0095; Sat, 23 May 2026 15:42:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 498386B0096; Sat, 23 May 2026 15:42:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 387436B0092
	for <linux-mm@kvack.org>; Sat, 23 May 2026 15:42:20 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 86BAC120BD6
	for <linux-mm@kvack.org>; Sat, 23 May 2026 19:42:19 +0000 (UTC)
X-FDA: 84799705998.29.0F696BA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0D53C40002
	for <linux-mm@kvack.org>; Sat, 23 May 2026 19:42:17 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CbF9hMJT;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779565338;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=het8FaTsHSVHQ3fcgyyduLT5OvVhYs/8Bwvfiz3v2yQ=;
	b=wyy964pbgPwYLWl9PHbiKE18ZGGcAjCBgRJa3ikM/v6meGcuRYczC8U3xwQgi9Q3GARF6l
	iIDhIUtn554E/46d6c5vCFli+nvh8+NYB/uxaHQXhTiZNkpXddLPBnrKCcu95ppFmHC1OF
	t/exEPfgasdcRuwtlNYXZoN0uyFt/IY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CbF9hMJT;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779565338; a=rsa-sha256;
	cv=none;
	b=Y9z2tMinDV7T+BdE87rrRWY0Swz5Rnf6dyQDqFt9/I5NhdI65+iCFyQods6ye/Zv0/c7M4
	0MUDFd4w3YwrT+GSB08YCBRPoj03YKMyf07heOwKB99mMzu+hpYJQ/pAYvIdpgTAxEOpN0
	KFrz4g+mAs1HK2T52tUIGFpssMvgUQs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 05C0A4330D;
	Sat, 23 May 2026 19:42:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E7EE1F000E9;
	Sat, 23 May 2026 19:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779565336;
	bh=het8FaTsHSVHQ3fcgyyduLT5OvVhYs/8Bwvfiz3v2yQ=;
	h=From:To:Cc:Subject:Date;
	b=CbF9hMJTTz5QsL72pa67E3YIzwGtl6x39fJVnc2mgv7FQWFmCF1mle9kIX8mYLSMS
	 OkgA6ZWx9k/EcN8BkjNZ6IcT/W6ojTRLCesM/4lZVVCM6nJYVkHerNG8i7cJHw142t
	 l7YkVyTuVGA4cJseGykYRpezfadMOIur2SVK5dPC3WtgrKm27nNKkxijc7iXGV3Zsw
	 QI+jA2UeoMmdIHD+0WNBaGatK9CZqNxEpXLlMA/qbYJqHgk0mD41Uk+6xAmEr0+PiL
	 qqYWFEcFQpqGDo1foNyZYu86k8rKBxXGwr4eB5lK5qYW7YKdbRb+O6Slf/vrz9olDW
	 bF8a1tC8+j0yw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 5 . 15 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Fernand Sieber <sieberf@amazon.com>,
	Leonard Foerster <foersleo@amazon.de>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH] mm/damon/ops-common: call folio_test_lru() after folio_get()
Date: Sat, 23 May 2026 12:41:42 -0700
Message-ID: <20260523194145.93122-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: cedhj4168mohc688ra5sg819aic4tfo4
X-Rspamd-Queue-Id: 0D53C40002
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779565337-244052
X-HE-Meta: U2FsdGVkX1/5PVqBKYYoYpJWekDaINj10pbg2oCnQxdb3Pve987fqBTmxflCAyFpzuoKEiysjgb2Egax4X0L6qgm9o6Lz34l9mu3MeUhLZEPNmdwqhcDEI/SA8IzbydSILbUX8HzlYyp9Eq6b+UOnJMtATFkmGny7idR0z8n7EwnJVOUN7OYtlcxBEK5+AJJeGK39vpjB0OrRmkaLoSaStmAWrYGoLtYLYnELVoETS6DxxbKSEbg0xuAW9wELbgyKxRnMym90bsWe3QYAMcEpQI/fMBkHifYRIwHddMELIRD06Bt8Lp5hpZIjPnr23gi/QfCUPmkyVBDSGV3LPvO/VD3dEF1C1jzfb7hYNDvPtHOSg+BGeR0WibrLJph+3/VzH0jnjSg4DgTOGRYZ87uM6uspRaXXFQJhFmDlmEIEsmjQsXHSDzLtd8ISL+YjSumXntZ33kd4OJNJyqtGxVr0p/OoW+Zxny7cTJmgqWMYkxYrt/QkEiaimiuLILj5wpBzXALvhRfont1A1ykVYHfyuI1bbPFR6dlWwJz2avnvBYlWhzO6lO0udJ9ppOoZncDH5WZhOowaLbWrZxrTuT1Eesw6/0ZpIuBM4tEXXB8XvCHIrGo+4EL3zt8zYzukjRgpQhzpQKMF9+ckkoDVtsInvXhvIe6CdUgUJG8eqo/DK9mE/zKAu8lbOhb8oSM/uIVZVQz8b2rVilZ9I1q78iwtmMqrrbR9qOZKYdtQjeI8UYcDRSzuQiWJn9c4+gMMFLu5bYKm1C7rTNJyPmPFDi98z4lwog/feybwpXSBUEnr3ccYsvGk5oSB2YS44GzZLhiCN+dJR65dQeGxqYIC/WOS4rUwbfo7CqNsd4NtDcwkOOR7PiazRJnA9uQJoAXqLhioH854VVfBVfpPlnzotTyLUiw00gJXDOGHMbCIoiOLzVy1ZBqxqKU0a0F27yzF8aRY5hjaMiz6dbuuUd5p76
 XUZVy/y0
 2z0wrJYs1+GW73nz0uAW/ZyU5hZSKdnO2sOL4HGHAtH5gbedDiLpssoWUkTxT+FdrAC6J+GpHFuMLLw79tvXoLVK7UEAv/grUNQ1qfWE6af15mstgLHKbuPS1hLQozhBY26Pm2DhdrZOrUfh5N1k2N3J/933YCeeOOu2jiNY8Q/9nAFk6zn1yrcw152zg1BHM8MbSB3m4eas1wwYPRc1sFMjO1bMCjAnzODJ25Lq+bvObncKxvYDWoYf97tJrghUK7bhqx/r6nwSPZQgJIA+/kJ0ZHg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_get_folio() speculatively calls folio_test_lru() before
folio_try_get().  The folio can get freed and reallocated to a tail
page.  In the case, VM_BUG_ON_PGFLAGS() in const_folio_flags() can be
triggered.  Remove the speculative call.

Also do the folio_test_lru() check right after folio_try_get() success,
since it is more likely than folio realloc race.

The race should be rare.  Also the problem can happen only if the kernel
has enabled CONFIG_DEBUG_VM_PGFLAGS.  No real world report of this issue
has been made so far.  This fix is based on only theoretical analysis.
That said, a bug is a bug.  A similar issue was also fixed via commit
3203b3ab0fcf ("mm/filemap: don't call folio_test_locked() without a
reference in next_uptodate_folio()").  I don't expect this change will
make a meaningful impact to DAMON performance in the real world, though
I will be happy to be corrected from the real world reports.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260517234112.89245-1-sj@kernel.org

Fixes: 3f49584b262c ("mm/damon: implement primitives for the virtual memory address spaces")
Cc: <stable@vger.kernel.org> # 5.15.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/ops-common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
index 3a0ddc3ac7196..d3404615f9b75 100644
--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -32,9 +32,9 @@ struct folio *damon_get_folio(unsigned long pfn)
 		return NULL;
 
 	folio = page_folio(page);
-	if (!folio_test_lru(folio) || !folio_try_get(folio))
+	if (!folio_try_get(folio))
 		return NULL;
-	if (unlikely(page_folio(page) != folio || !folio_test_lru(folio))) {
+	if (!folio_test_lru(folio) || unlikely(page_folio(page) != folio)) {
 		folio_put(folio);
 		folio = NULL;
 	}

base-commit: a94d68c2dfd523cebb2755787fb01c08eef70c43
-- 
2.47.3

