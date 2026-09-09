Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B45AC79FBB
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 14:04:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 985D76B00A5; Wed,  9 Sep 2026 10:04:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93B496B00A6; Wed,  9 Sep 2026 10:04:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D8556B00A9; Wed,  9 Sep 2026 10:04:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4878E6B00A4
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:04:20 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7BE8D1A0224
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:04:19 +0000 (UTC)
X-FDA: 85194393438.16.50BCBFA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id CBF7CC000E
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:04:17 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L2y1dlMu;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788962657;
	b=IPnvTN5x4otbaN+YRlNZ95qDgcOPRi1RPHw96jbtPhtIAoOmkI77WoFdDfT+XMnoUS+OiG
	Y9aTJhdqHupbRtb4W8ioXWxEt0Hg2f7IORvo2YQg7gzjH7P4vn9r0dhe/QPP+3s0pixMkJ
	/EwPGELcfWfSREWSJ48n/yEigBMCTpc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L2y1dlMu;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788962657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ljZqDnomsr/PzAJ3OgMACOqJ7QipPXHSesCap1Ut72A=;
	b=ewck9dJMEu2Kde1CpLCzHtD5JaQoUe3JSPDz0ze9Y5HgE2ry7xYr/jKfZj/PeK6dXVPd/8
	1yiNX4VTYUYeQ7mZJyz/M5yolGMTqq4UjD8XyKZMOHGNUTEvYKXSCjBsWnAazR5uAZTWHi
	h6myowqo5yMge2l1mvLPQOtzbrdI6hY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 61EC360214;
	Wed,  9 Sep 2026 14:04:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E3EC1F00ADF;
	Wed,  9 Sep 2026 14:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788962657;
	bh=ljZqDnomsr/PzAJ3OgMACOqJ7QipPXHSesCap1Ut72A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L2y1dlMuE1ixFnYJgeWuEsNa0dHmIaaRkNfYW4OozjKIFHFiLRMh/P1LhSWsqnfns
	 bMnpWg+MZ6hPnCLw3TLsTaIqAW0Ek3iPAcHqrz2r7SX7uEljBcquT53jY2ZbkGX3Wt
	 4haLBzVPRGdcmA1JFJ4ZxcJkX6ULPYWFF4BeW9scwBUJknirN1KDkhdmQwN4jkBjK+
	 sl69H66rhyAvRFtivWso31yMuxp4UwoSUcTbKa5VURMN8+WgV1jKiT7bV6eaXHfpDD
	 MGdhFnZqLPt9yCUnr4ov4Z9d4OJbluXNWBpoWh1XBcsnzvKxsrFzbBdjJ0RxKsv+wd
	 nVW+Y+BCH3Piw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH REPOST 4/5] mm/damon/vaddr: extend apply_probes() for hugetlb
Date: Wed,  9 Sep 2026 07:04:06 -0700
Message-ID: <20260909140408.104699-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260909140408.104699-1-sj@kernel.org>
References: <20260909140408.104699-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CBF7CC000E
X-Rspam-User: 
X-Stat-Signature: 1oyfjfnuzqspjyephaoz6zdgde16k95p
X-HE-Tag: 1788962657-875001
X-HE-Meta: U2FsdGVkX19kgxyp3RooPL6nHZjwVXkKuvzBlol9XcgsHMJymBUeiXSsyqRP3JZwro7BhhRaz+82T4y+SHS9s+Z+HN8ogXVATupnnknkQQ1r/MsclE4Hli0wGaAHX7wqRXzqhoodFfEtYpUDI/VBglrzQsBZZ+5HiMQXqwdekp9WUfkLAwYlH3nw75vgM4GOMinzRAc6IIn6vb/djQS3QQj8qDbFqJ9RYDtgNWmjfSC9HATvGHr9eTgzX8YXTPNZ0nKG1JHrChAwLwyzlDZKYQHTkKMkGgK5NIKfKIBCfBOKpX019d3jMGWeAnVok2PovVEUtWGChcz2kZiOoO1uwY26mmIkn/kUgjsJbvjVCGENK2/iRoYVzGLHRdwJbWWt1yZ2fnVYkZ5L/3G8rEX/lrTJ+QZvg/FHz1izma/LQXs1cE7EB25nm6FSmfKAMqE+QCLF7vFlkhD+IfmKB0UvUn+3z4ChJphchMoCLWQFgnoIvcDlDhDYP2KDaqhOzyQNq1kIrjXolOmetNkJ88Mw94z+BHmE50YFbps5j0M5N8Iz/ROP5voIg5/IdfihJFqCGferP+lK2TcaCLWiiHBBZxg86qG6w/CXYiWgI97fxunCDMAMaoq9LQblVFSR18apAyA9PLeI/jhZ5hEDy3ESw6aGUFLHvlyxYPGNX6/t13Ol8TDHafOzqsDnD4fZu072itL+uVX/+3cbKBF3EsDPLWd7m+YF3NrmF15xmBV/20g9yzMsc9i37xi9kReBnpMXMM7kldQM24xavou6Xnc4X8BG/ERRtvqtfH625RgdjGKppEFHlOBPIcywaDrZUBy5JR8BMTWnd2JLcgt1ZzWEhs6g6uc35NoXpj1tDChMBZng9dhwtc4vxTfhXyJwjWTRay+PbTd8JmHAZesh7el8t2EJx0Ju3t35etRCFyOE9HItYScTcbpqZHfgdI5tSqKPdn1sClus9FZ9j2Kxv/B
 k+ycIyRw
 EJIr1Yzq5rOpqyEDvZNazxzs8pxbWxoy8v36XFZv3oCLB2caPp1aRUARCm6/AUmQAnp/y0QUfIXcPU/D66aciD1qVHQbTCEQfrZucOCj8c3FH5XdLMZmtNGjNJIgar7X8gp5D+SB4fy9oki0KZWtSDGnid67cB0kduCC+J1QIEmcncZGPi2HGrCsY1jyXASSbUYLvFBPRfcGclPekc/0BexQ59P7ks9JfmwLadkWi9HWK+iK52RpZBiYiztDmQUH/pmzzPx1iCXbMUY2D+V7we13aiQ==
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

