Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40D17C624DB
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 20:27:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D38966B00A5; Sat,  5 Sep 2026 16:26:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D05496B00AB; Sat,  5 Sep 2026 16:26:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABC166B00A6; Sat,  5 Sep 2026 16:26:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7B7DC6B00A7
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 16:26:47 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 103D4A03D0
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 20:26:47 +0000 (UTC)
X-FDA: 85180842054.07.1890ACC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 806A1C0007
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 20:26:45 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XELRf4FU;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788640005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ljZqDnomsr/PzAJ3OgMACOqJ7QipPXHSesCap1Ut72A=;
	b=lQgZQKSFuDKhj3c5b70++iiJza9jy035v5iKMI9gJKR2qAstd5FAu5M1ez5rxmmVtHsjw5
	0z90Ur8lRjoW2MnWx3nZ9BonAyZwP/S6wy0tUilVPDiT3WSoI7T6bW7qTfIL+RMuweI+rQ
	vBwQVT0Y8h1WfsgDiBYf73YDzPr8SKU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788640005;
	b=VbuphD/c9N0/b/9Fi16fL+fqchrksJk9ZKlWjwfu3XQ8GDO04xecjKElIyYO79egZLUhAW
	Q49oz+SSemtexl9PxUMt9KO5YO5wxQTm5eDyRR8qedyq3/wAJpEYECyfl1WL8+/CtokNjB
	BB4P2aGxZ7G3wO+bUCSvCnqMCQNcXTw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XELRf4FU;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D829D440A5;
	Sat,  5 Sep 2026 20:26:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96B591F00A3D;
	Sat,  5 Sep 2026 20:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788640004;
	bh=ljZqDnomsr/PzAJ3OgMACOqJ7QipPXHSesCap1Ut72A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XELRf4FUAPre6yzEWl2c6/aeh5N/93qZx0vzARRXYRzgW4uThZBQHwN8ykfTwn/Ed
	 6sf+5Walh50v4Ew0nnhwoRDh7bFlp+OeLpYtIl1nSGIYaRU5UFGNZs7sUntx12/BZG
	 Iv8pO3SkeL/2XjeJQSa5/wnr34PKCbu/PMsJw8L0f4wmY0q4O2dJ0R6limZ2d4kgaj
	 ksbdHFPI6PZkUHbWca4XE+QhhqMro5iuvLAMhlMNqhwlxUfzSte3XSh9uQ3280GYBz
	 g6PLd5YDXIYeBxd0woGysm21P5Kz1vHxwO5LfYScELTGrCbjLVZQYMXx5dGQoHHzy9
	 gF7uC82LlAv6w==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 4/5] mm/damon/vaddr: extend apply_probes() for hugetlb
Date: Sat,  5 Sep 2026 13:26:26 -0700
Message-ID: <20260905202634.88102-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260905202634.88102-1-sj@kernel.org>
References: <20260905202634.88102-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 806A1C0007
X-Stat-Signature: upbm3zizutrtfpo7rcufd7i6u5e8bby1
X-HE-Tag: 1788640005-273662
X-HE-Meta: U2FsdGVkX18OclpEOe2n/BHToAVAlb5CjtmVfIuPFAX6Pwh2r6inHFT7Q2dp8X4XyoNXIahyjkNP9v3Bsia0AOFHxkIF4bxbP4fOOiP/2rdhBX4s5z2Dxk0R7gzMKEmQdUsmKuKwqx4TnVU/N80cWGwKQOkfc6lHpCeggc3vaP/LWF6H8u+A4q/do/DIAmqiXdI+9eRDJGP1Mm+XAUJYmrGf1F+cV8oZSf0yDOD5uNW0AyHAaXM0IdrSkabx8RgK0pEi3Y5kVnMXXuKSBPZ28Adsm/mkuS7qTlzb/vZr5grHSwVTvUPGQH0wWv9j1WFvyU2Jy/FVEEiH7z4fA8w0Li4iSndGJhKUb8tzvbq+oBunWcvrecS4/DR+n1wo3Js7kG3dzIjdbGf0UNTg99NhPFOa4GhfKJTydcozdGSXTE5y2rxHTJ5ljIJj/+NDZEvYJDbLATTWvyw1X3M28g/4hmJXdBUjDC5ogZq3r93B8boMqq0DG4F3aWLg/vvwGLbtO7bTqcUGlxoJ9T5V+Nt0Ioq26ie8/2nMZRK5d4KeznIXVcXsA/qcFDS+wj8ihxnhRTBe5/VtPc1ODwpk7yN7Je1jrMD9p/QVwHZ2DP6pit9FKX48Dpx2V2dwZ0QVHljSRydrA1XF6w7VwKpe9owrh7wZ4LAyjzhRdPaI5NWtSFnWxacUe4OMKvGkkQV83fGH5LT15mzpUDcjB+SHfft6Vk6wRjQXe/8uiFjx1NoMDCNkEygSwVx+1nM8xAnBnDxf9PZdp2kbmhqjxbbvmEaIImxJF8htcuRw0qRdUIS80aIBhIp3QF5OObbkJ26wZRft0Bo5rk4S4z+uQsJntE5axh7+DlbWYllVDxgIbFRm7PQfB+cexhF3sIXBgnDpHBZqSDRW/vJrfBoO9eFbWJOoiFpFoG6h7Nex5Ls/SAggGTAZIDUfhbg5jBlziZnzTn0umQH7qZvJiS97XwsfhQp
 xD3pGiyv
 bDnjMYCAEZqWl29rV7KECGx0NwKVgPeUqEPwkgBm1JFz/5qfRSvhpBsC4PeelpgDhRlA/fQmte+wltWpXLR+lkPt8TJ6LbBoSadWwYYQbOpmiQD2L2bnl/YZJIicYaPGRH7VtMARUNKEt0Ho7pcUfJgIzQH3pfXZUXZ2z0mPf60PcTh79k/pViNuuACXpU0WbaKGLnuXZ2G6CqX1MfdQ5H0wJ6x8D40fiobGviRlqMGDM88RecvdQOoroorGza9JqNqk+05Mb5cvXmSpIZSSGH1pOLQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON virtual address space operation set(vaddr) does not support
hugetlb pages in apply_probes.  Extend it for hugetlb pages.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/vaddr.c | 30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index 7c548ec0cf6b5..45239f05e113b 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -598,6 +598,34 @@ static int damon_va_probe_pmd_entry(pmd_t *pmd, unsigned long addr,
 	return 0;
 }
 
+#ifdef CONFIG_HUGETLB_PAGE
+static int damon_va_probe_hugetlb_entry(pte_t *pte, unsigned long hmask,
+		unsigned long addr, unsigned long end, struct mm_walk *walk)
+{
+	struct damon_va_probe_walk_private *priv = walk->private;
+	struct hstate *h = hstate_vma(walk->vma);
+	struct folio *folio;
+	spinlock_t *ptl;
+	pte_t entry;
+
+	ptl = huge_pte_lock(h, walk->mm, pte);
+	entry = huge_ptep_get(walk->mm, addr, pte);
+	if (!pte_present(entry))
+		goto out;
+
+	folio = pfn_folio(pte_pfn(entry));
+	folio_get(folio);
+	damon_va_probe_folio(priv->ctx, priv->r, folio);
+	folio_put(folio);
+
+out:
+	spin_unlock(ptl);
+	return 0;
+}
+#else
+#define damon_va_probe_hugetlb_entry NULL
+#endif /* CONFIG_HUGETLB_PAGE */
+
 static void __damon_va_apply_probes(struct damon_ctx *ctx,
 		struct mm_struct *mm,  struct damon_region *r)
 {
@@ -607,7 +635,7 @@ static void __damon_va_apply_probes(struct damon_ctx *ctx,
 	};
 	struct mm_walk_ops damon_probe_walk_ops = {
 		.pmd_entry = damon_va_probe_pmd_entry,
-		.hugetlb_entry = NULL,
+		.hugetlb_entry = damon_va_probe_hugetlb_entry,
 	};
 	unsigned long addr = r->sampling_addr;
 
-- 
2.47.3

