Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CCA5CD5BB1
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 16:23:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7568B6B008A; Mon, 25 May 2026 12:23:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7073B6B0095; Mon, 25 May 2026 12:23:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 644386B0096; Mon, 25 May 2026 12:23:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 559D06B008A
	for <linux-mm@kvack.org>; Mon, 25 May 2026 12:23:11 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A24921C0525
	for <linux-mm@kvack.org>; Mon, 25 May 2026 16:23:10 +0000 (UTC)
X-FDA: 84806461740.18.782CE73
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 24CD9C0008
	for <linux-mm@kvack.org>; Mon, 25 May 2026 16:23:09 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=epl3SeXk;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779726189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=syrlMagaAWzZj87W1TAgw6fED2o86tpCAUGW85ijOD0=;
	b=rZZiM43XetKik4qf2Nzh5WtJ7OUbwTibZdp93Hu4f1KJro/FzF+Tbz2VTyZnxjJytAY13Y
	TaY8CodsSW3MZgaB/mX6CuVbp+k2yn6yRYkv2WxdDdzhu6yFfbCe1qkQirI8Mp9bWmczsH
	NnP4RE9Hif8hhaTgWskofyEhF/dq7OE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779726189; a=rsa-sha256;
	cv=none;
	b=4IAdhGHl1cdAvdhoEn0iosMkmn8peGPzqArmwu2ZRHc41koG6sTsN8ES2f8Z2FtP/YQSag
	ewHpqf3+8HSOPjnCr9zFIzzu/dOhd/SQqPr/8l52PHv6/XJo2EjptG4oNfDRmGu4Fm1Q/6
	0yGmR6r2LKa7S/OSEnuZ19CBgiy6RXs=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=epl3SeXk;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 42698418A4;
	Mon, 25 May 2026 16:23:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D11661F000E9;
	Mon, 25 May 2026 16:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779726188;
	bh=syrlMagaAWzZj87W1TAgw6fED2o86tpCAUGW85ijOD0=;
	h=From:To:Cc:Subject:Date;
	b=epl3SeXkn4O51H4a+ydWW9elKLAVc6xYmuQfY5OcIILu9xbmW1rsWJUJcdyFbhrxm
	 FekQzkQdCTnQztYFCoFqoW9D+eNJdRQRi6MJW65zMLXDQkg734VtbTCRa1DRVgo7BZ
	 yhlcZmab7WfkDWrb51g3aqpaSKvtPRsk31HEknajolSZs4/qChdFn1II72DXpwrNGt
	 6giArn4QIcoDmbt7A1q6H9cGaVapUKi93VyHYTZ17u23Ao4KFWKrc8+Iqp6o78ZaRy
	 w4PG4hKA1K8OXkCw0ZlXHk6X/v77BAYHG9V2aeDuUE2/WPdIZWOsuE7phb9YSokrnN
	 qty9VQRf+md2A==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"# 5 . 15 . x" <stable@vger.kernel.org>,
	Fernand Sieber <sieberf@amazon.com>,
	Leonard Foerster <foersleo@amazon.de>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH] mm/damon/ops-common: call folio_test_lru() after folio_get()
Date: Mon, 25 May 2026 09:22:55 -0700
Message-ID: <20260525162256.8317-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: a8s1r5nr7w8zjxntwkwf75fgmcws5cr7
X-Rspamd-Queue-Id: 24CD9C0008
X-Rspam-User: 
X-HE-Tag: 1779726189-464438
X-HE-Meta: U2FsdGVkX18zMhoFQ4wLDnC51s+daUNMaWHdnSGE75nPUnH+Q2v2PKoRx43XUA6cHNALRdZ0hqGQzc/dEi5UIcA6pPiplx7UoAa3XG900wmGzhFUC8aANTRmAwm1znHVef1TuafSFAPcvCHt3ueFNghC0PPfyw04TLGHhyFx/gGoliAJTslEj54rL+mF1Vfk1HyIY1ens9ht6MlCv6cfRqUbSWR+YZKn2eBd1ye3BJZE7wmp8Ma8r3BQPnUQXYkD4Y94NqsubFsimkodU2F8yWFtZKzAA3AY1t3WjuRwacit5GLY376CwnWw/Pi+8jytmex600l1GfJYCVlnujPS3EqtJq68OkS9ucPFlaPCtEcCDi54TZW5oztlJXUNsEZqWzUFJWmKO9/87uVMsdjqxSxkJdVlFVYoJMzl/rUFe3+pEDVegfgDq6rJ2YFCheYcRKv5FizFGswMR/lnGPfOQ3gwzrcOo/TTt3eWCWfw+gFDpA7FT6WnAM9tfpJxVsZdiHkkojWr6hPSWvprUinTK0spV/tWWdh5PK025HZNa2Mz6Ah9zbv5j+Q/UKMPx8iCYIJkHy1pHRzc4fX4a0+YBlfy8zbS9Myu+HgxelpjuhRxkFFbOpQEU3JVxsV2K1yTNJe+rLODQEJquTT0Nij0YbiKEsdMXWHGYBSN00Fds0OfBWm9bg9Mhb6wuSyizpV93GXoYRGouHzuNka60AQTPOWS/JDhfJdkfYVvvlrOOk2OCv+o3YmTpr1KehtO1p65bQa+SRQ9/fVu4krUe4jAKXLnXHdGFfOKCHf/MZ2YPn+a4Recrf4TGuX1OOEoi3YeUcbYN3WvQFcoci1L4ZKubzIcadY6RXWoxBx3UdcZ7e5xKi2xDMe1hjipuDRMZojY6JeKbNAUtd6JxGN1oZHmqPFesXjSw7YPEGmgZfClHn0nutktn4lo33aPQfb3yrzlFnOr78Q4x0LSEskCFvh
 IofMX7Cx
 0QFmBaJQDWsEnmwqGqPJ7Ks6mgUwbMi5j9czvbiCUvdRRGiSxlLgMs2sZOJzhKOZpxaWhuls02406YzAkIt/ZVfXRWdIol5bA5tGZaKzTpbX0WrhC1XhSY5jBiyjGagJzhw5+l6wXybs3WGV2dSWX3rGp8ongFHOQkgkyVdplKHqlokX68Y6dJ7SxxfDoVolmLZjqGCbXVHd2sQ6B1OiaoLN6I+xbzgb3s6klU0DvMU4HE84A9N9w6zCkLHeap4K06cngRc3FABIw6WebHVPW/C11hw==
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

Also mark folio_test_lru() check right after folio_try_get() success as
no more unlikely.

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
Changes from RFC v1.1
- RFC v1.1: https://lore.kernel.org/20260524174608.81112-1-sj@kernel.org
- Drop RFC tag.
Changes from RFC v1
- RFC v1: https://lore.kernel.org/20260523194145.93122-1-sj@kernel.org
- Do not change post-folio_try_get() validation order.

 mm/damon/ops-common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
index 3a0ddc3ac7196..5c93ef2bb8a97 100644
--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -32,9 +32,9 @@ struct folio *damon_get_folio(unsigned long pfn)
 		return NULL;
 
 	folio = page_folio(page);
-	if (!folio_test_lru(folio) || !folio_try_get(folio))
+	if (!folio_try_get(folio))
 		return NULL;
-	if (unlikely(page_folio(page) != folio || !folio_test_lru(folio))) {
+	if (unlikely(page_folio(page) != folio) || !folio_test_lru(folio)) {
 		folio_put(folio);
 		folio = NULL;
 	}

base-commit: 4901db133abb670b369af93cba9af99c5be0eb0a
-- 
2.47.3

