Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC7ABCD6E43
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 00:01:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 681936B008A; Thu, 28 May 2026 20:01:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 658F46B008C; Thu, 28 May 2026 20:01:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 436AE6B0092; Thu, 28 May 2026 20:01:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3493F6B008A
	for <linux-mm@kvack.org>; Thu, 28 May 2026 20:01:19 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DE869140AA8
	for <linux-mm@kvack.org>; Fri, 29 May 2026 00:01:18 +0000 (UTC)
X-FDA: 84818502636.08.BA6CB5F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 382A01A0009
	for <linux-mm@kvack.org>; Fri, 29 May 2026 00:01:17 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iPGfiAZe;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780012877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8uMRK9tYWaXpNpaEqAhpqFf64f/zJybxf3IUBnmYDVU=;
	b=mjn64WuAgBL8RE1FK/KJ/MKU+2hg7NpEOo1uCMTRm0YYOXthntC6DUBaWlR8whvHF9nOlu
	m2aLkO79ZsOEgoh7nZurgs/FaKBDREZjwgGLhKID9kfkf+6NfWwBktUmmbGhMz+jMIefaI
	cfvXF6Rr0B3c72kWqoNGoSIZnVeraRg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iPGfiAZe;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780012877; a=rsa-sha256;
	cv=none;
	b=0jURbzWaqalbLAD0uhaCh/Q5Wp4PkucgBydLYv/OjhtzLi2kQSFt3radOYS4fdSyruxUH2
	w9cm41SAq6rxolQZhxU6JsklHgJYWbufY+slXy5CgM2w50Pxg+cmdd1RBeF1svUEBR0jip
	c2Nlu1DZolA8rRpq05XE+c4WqbKpzxg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5585A43AB7;
	Fri, 29 May 2026 00:01:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B77811F00A3F;
	Fri, 29 May 2026 00:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780012875;
	bh=8uMRK9tYWaXpNpaEqAhpqFf64f/zJybxf3IUBnmYDVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iPGfiAZeei+OnhXocD2OZunx4l+5LCfQHMl2Tu4l2ZueUilbE5jDRJwTepAYmTsgu
	 jqYfD44g0BH6qEPxlFmG37EQFxHWXhaA3X259qp0w7JODM99jw2LnBUgqtZs/elB3J
	 5/tkTkw/AJya4VBGQokkaJHizTsHCVqqgCCNimAn4DHNaj4b5tJfcCFDZJrPVjR3NL
	 fJaH4U7XULYv6xx0DvdG1stdgHdGaOUlDwTOUfbNJSji28RCO9dF+/KGaEXJcp1kBk
	 iUULj+RP99O/oAJqSQFrp2D2IRJlcDy24UYU6ndbWY1faNymfzGvCDDpN/3DTr9J/K
	 0hWQEDMzgd2fQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 18 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/2] mm/damonn/lru_sort: handle ctx allocation failure
Date: Thu, 28 May 2026 17:01:03 -0700
Message-ID: <20260529000104.7006-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260529000104.7006-1-sj@kernel.org>
References: <20260529000104.7006-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 382A01A0009
X-Stat-Signature: s1rjnd3t7mpiorxugsegyfs3nad64q6a
X-HE-Tag: 1780012877-134844
X-HE-Meta: U2FsdGVkX180viaYnFUKm3GquXbdWLtsRLtVeLiYe3tJxyn+lj0iNgCfov2h/DFVyjTKyRy4xFxFotgzkQ9Ncj2wuJnbodY67HEYS2Tg8KrxYr2X9KnERlrL0jyJFk3Lo+S5Neazt4/F7Pzq6YeLOI+bzdOLyXxHlo1pmSASWFgpeDcQ0q3VNM8zKPS91VFuok9PYQ3gKOgLKqwEAZEkHxxYWVZ+woUEUJ+8ky0GBsWwpuyZJdkDWEM8M4aePiflzaXe2gZ+/YvtzVCkk/cSyEmc4wYCr5qM2tkBdk7s7jTv0ozFLfvarFGuiiDuFNwNfZw0jWWRnUxvMNqNSW2JbWvYVu9ppK8v1pqr6QA4s/pUSvUmiI3slz5AJR/VDmMGsqC+z2jeQsE0jw87PtzN2PoAvBLvGksLLoohlwc0IzjVPKsZVG9BTa6UNAnnth7dENa0NogNJ0/aEjiayT1KJ6ID5drGGckt9U6x9ZqICn0Zcj4wnWMTPRQhicjJRSg/C2PJAjDb6vQ/omamMw+ShJdnZwCoe1SnGQWJxUjzdRF8vb7u2+6qODQ4A0DVQ76ipgmoopiekiQHa/vDUJzCLCZk09W+V0NfwEQb0cLNPNNISaZSXxJ0oNdjH2fFgsAx0BelM4iDhQAP9p/wSaAWe8BVpMauUxxm3vJhxPqAco2eULZy1hpQet6+FrzJN8D2ia8jNQVug33bSxGeWWf5sahMnKoiBMHlX86yGbaxa8gQW9HgSik3ecUfL8QRnCwqCwjuNBU6adBaIpw4PCK52zSlSnbO1U6kkcZuF7SLexRkfec0RcUuqp+9vKJv0tZi/F1+itmsqTi3cr++5o3K8HMIrUd+o+FoAYCyupVJJiSdBc/BsGvBMCpM6Th9BpSsnA/O1kOrpGERyXpBqU9+u2mtbZkcxasM6eAIuvA0OZGh2eZnVAYftSrbNXdDBBgRGYO/4iBjn7oQfC+fknG
 8p7eW/j3
 kYKnawYFBgvufjrlm/LtK7vK0FzsX99QWMVaH0IOMGlUT58SZbfwYOu87YB0qiyREvXsUY/WvW2QwSyv7ipzVXYIX79xOFfEb0xmAiAEwwCjxNjtvxAlr+9pAfR62GyW4qL8mc/Bp7FPCdhZuskmzTcmO6C4cC3aHxN2gda/r3zTbxDfB9EsAWTJdY/BMBD/8Fh7jirNSpTJDYhtn4R2Ob4YU/LndtVwJwTOFL9QHxK8mGPJ4kdLzqdSTt7f3o8hEp6EvgtQ0ULIIk95Hl58JWKDSZQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON_LRU_SORT allocates the damon_ctx object for its kdamond in its
init function.  damon_lru_sort_enabled_store() wrongly assumes the
allocation will always succeed once tried.  If the damon_ctx allocation
was failed, therefore, code execution reaches to damon_commit_ctx()
while 'ctx' is NULL.  As a result, it dereferences the NULL 'ctx'
pointer.  Avoid the NULL dereference  by returning -ENOMEM if 'ctx' is
NULL.

Fixes: c4a8e662c839 ("mm/damon/lru_sort: use damon_initialized()")
Cc: <stable@vger.kernel.org> # 6.18.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/lru_sort.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
index eca88ed941b32..8298c6001fd09 100644
--- a/mm/damon/lru_sort.c
+++ b/mm/damon/lru_sort.c
@@ -476,6 +476,10 @@ static int damon_lru_sort_enabled_store(const char *val,
 	if (!damon_initialized())
 		return 0;
 
+	/* damon_modules_new_paddr_ctx_target() in the init function failed. */
+	if (!ctx)
+		return -ENOMEM;
+
 	return damon_lru_sort_turn(enabled);
 }
 
-- 
2.47.3

