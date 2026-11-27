Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81F0F606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 22:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JWvDTCqy
Received: by kanga.kvack.org (Postfix)
	id 263266B05B6; Fri, 27 Nov 2026 17:27:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C96B6B05B9; Fri, 27 Nov 2026 17:27:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4AC56B05B9; Fri, 27 Nov 2026 17:27:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B39CC6B05B7
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 17:27:31 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3E13A404F7
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 22:27:31 +0000 (UTC)
X-FDA: 85482336702.25.78652FE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id A08AB80007
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 22:27:29 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JWvDTCqy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795818449;
	b=QrtZXmkJY+GWvbt/Bn09LaB1pJK9UXFukQLLrPil9RIPtUsSW7IGQ0XUkPZIIi/flNwWKk
	66jB6ZIwrsWvarGRIEIWjASkUJlyqFOclCWDONhEc6ekAgBGTZOSNvzp+xc4Fpru2ymFT3
	aqCOaxqTHPwWFxanyzcGbNwiuUjQ0ZQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795818449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pr59TfKsEQXmZYB8xZ9SJvEMJ1RSajI/gLHtLxiB0n0=;
	b=RjNUpA505pxMoVJQhFezq2ApdqlyVDc4aPb5QSKeHg22ozff7azADAJJtpIlaWcJPkJ1m7
	W6Lb6hBPoC9TOu2dtcIyDJxPPBVqzq/3Dr1v2JzXyiNcpeUEYZ6xsoFdtWd6X/qW88KDU2
	G1krXvp/wUkKqu1DpLmd/EtfRsvCn6g=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JWvDTCqy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 49E7444627;
	Fri, 27 Nov 2026 22:27:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 120871F00893;
	Fri, 27 Nov 2026 22:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795818448;
	bh=Pr59TfKsEQXmZYB8xZ9SJvEMJ1RSajI/gLHtLxiB0n0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JWvDTCqydCbTjeSN9O0anTQmaBtZ9IcQJ+9yOLRzeUQYgMpEIXb5b8tu3nD5dyEBY
	 f2VaOYCuHDrMDYBuMvm7aL/xqvNcyozA+e++GFy6nuZamj4NuYsfh/rU5G1Y3QGrjI
	 lIeC3oxSrQsteyiMa1hRTjVuSO2DzSHhElnIqJzBl9vzgi5nZiqkGIzRpBSGeEZVuP
	 aPvOwFJE9PB/DBdBut/xoZyFPuWwAehnpQH6I2OTHOhi4vqmm4Rpf+HPaci8SkNOOr
	 rbcCuzi64pWp2HHX+10jbG3LTcKjhr4pKVICm2y8tKUOubjINz86I7zwNOdAOUzifQ
	 PVLNz01dqysNQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 3/7] mm/damon/vaddr: implement sz_filter_passed for migrate_{hot,cold} action
Date: Fri, 27 Nov 2026 14:27:14 -0800
Message-ID: <20261127222719.105510-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261127222719.105510-1-sj@kernel.org>
References: <20261127222719.105510-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qe9n5r838ggp37jrcnr918bxpufus4mm
X-Rspamd-Queue-Id: A08AB80007
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795818449-755289
X-HE-Meta: U2FsdGVkX1+tRcNV/i+xpkbQwIZURMQXKRHHfM31sIvtXZFUmGvbK6VP6sxwcgjv7meKTSphL7CZ+hiBdPJIH3xcFT4EWXn7u521oCKGUGPGJtZdX2xCT0UiuCNsWug2yMlv+dWzI09EI9KLQVwJbzZrueIaEBYR7VJcGhX8WP5BFUGVOnvLOwHo7S+dxXwZZyEZNziwwq9uLCb3kHlYxU/83HpQYz5KYUdSzBTDSe51jDXtq2nSUIMln18GAK0eeOfy0GAReUmAXk/uMXnSjcaLiNyAQXJ62uerJugzw1EzbOG0X2SamFa3LfdjVLwbAvOxePpMxHkav9ST9RExezqjfNa+yeP3HlSAtSncpGHcRW6sdPGI9FwN8k1xUoh3S83zvma7F3cr01Q/9Yw3DOS/kKSt1Sxb2Eek1VdDfBdN1daFAWffIS3fDGIw9TX1zTQttC5mmKgclRlsz/vc7Cz25d5jVj6qjuA+lItdrPXTmYV+IDk09UFiKAurw42QtE1teW8xx704d0HZAUMbUNxnMoZlkdMeaE6cs9iB9BMp4WkSn8KPeeSLJgEtgPaBhTVO0uRoVWD2m74YoY+xw5bNYLHgFTWXFQmFTL2WmMyEqrbfVgrB5MNcdFhpv0Cf3NuRdr9rZsLfaWLRfCzvLolG5avMc9UcWBXw7pqga9nitVFsg22xPNwgZ/qVqti5FxIsAhDUhNc8ZGMlqdL6PX7ZrT9hP2RdZMah9MueULHm3D7F/DvvlbDZK/qunRcHRglwtrwMXGNvlu7b5Y2XrP1OOOuHKkq668a955ESITUGJPHUihFBPkEmHPpbv7eW/MGmRPqv7TCPVqoJokJE5HsqYD147cNVlPQ4ZsTVhWEJQTei7+qICl/zbqKMu9lAcsdVYBcWhaV3plb78r6rWxlDdH7fpIfM82x98uMxqZHEmo7GNTFp+iuWaz4KnuNYJA17YqYA/6gn6topiPI
 NwwSx/lc
 1jkS0w/E+QgeB95LONFw/Xhh3lsufpoYitdv/SeLtVG18ovnJbCVxAY1vJOkkWd5C8V3OdFzaoN9WthTYZSvI6u0vq+UlVZb8KROcH638hJKgsFj8FCY1/1VYUAEPrRVvcRZWCj3DETSa4o0hBpR5LQFDxCJs8udoeX37iZ6E8+HIe2aRvLxjnXGw3tUZAP4aP+rzO8MAA6kLKTy8H183NLSxW3qFudB1AbUZfNWRgR3sNITe4zUYAY1MFWXzaEvx9HXFwsyWrATlxLlIZdUW1f23YzWrGdSw4BXtMrIY7unHb6QqNi8VY4HorUKUgNwSS7TRd5cG6HNTmG0hZmoKjY54x7Esj4f2Itj233zLZ3LwUupfDMh16YJwI8aHZobU9Pu5Q/fm5xijf8uPnzpfv58QFJc58QGz23dNa0quDZeXR+ckoWYpaEFM59RSItpnhfrWb+QAU7WnOytNC159gQOR7TB+wbJIL418vgoC9m5fHwJwavFCZk406sX4O9kfhWrpdNFJ79BATfnCiKSiWxp0LtmM8Q8NZxvUJMMy/U3ymMkQjskJYFd4Og==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Support of DAMOS ops filter and sz_filter_passed support is up to each
operation set.  DAMON_VADDR supports both for only damos_stat action.
It intentionally does not support those for madvise-based actions
because applying filters could make it unnecessarily complicated and
expensive.  The vaddr implementation of migrate_{hot,cold} action does
support DAMOS ops filters but sz_filter_passed.  There is no real reason
to not support sz_filter_passed.  Add the support.

Pass the sz_filter_passed pointer to the filter applying logic and
accumulate the number.

Closes: https://sashiko.dev/#/bug/linux-986e8b64-8e65-4e32-970f-4d3ebdf8206e
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/vaddr.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index c8f93a19c840..721a23856ee1 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -776,6 +776,7 @@ static bool damos_va_filter_out(struct damos *scheme, struct folio *folio,
 struct damos_va_migrate_private {
 	struct list_head *migration_lists;
 	struct damos *scheme;
+	unsigned long *sz_filter_passed;
 };
 
 /*
@@ -849,6 +850,7 @@ static int damos_va_migrate_pmd_entry(pmd_t *pmd, unsigned long addr,
 	struct damos_va_migrate_private *priv = walk->private;
 	struct list_head *migration_lists = priv->migration_lists;
 	struct damos *s = priv->scheme;
+	unsigned long *sz_filter_passed = priv->sz_filter_passed;
 	struct folio *folio;
 	spinlock_t *ptl;
 	pte_t *start_pte, *pte, ptent;
@@ -867,6 +869,7 @@ static int damos_va_migrate_pmd_entry(pmd_t *pmd, unsigned long addr,
 		s->last_applied = folio;
 		if (damos_va_filter_out(s, folio, walk->vma, addr, NULL, pmd))
 			goto huge_out;
+		*sz_filter_passed += folio_size(folio);
 		damos_va_migrate_dests_add(folio, walk->vma, addr, s,
 				migration_lists);
 huge_out:
@@ -895,6 +898,7 @@ static int damos_va_migrate_pmd_entry(pmd_t *pmd, unsigned long addr,
 		s->last_applied = folio;
 		if (damos_va_filter_out(s, folio, walk->vma, addr, pte, NULL))
 			continue;
+		*sz_filter_passed += folio_size(folio);
 		damos_va_migrate_dests_add(folio, walk->vma, addr, s,
 				migration_lists);
 	}
@@ -973,6 +977,7 @@ static unsigned long damos_va_migrate(struct damon_target *target,
 	priv.migration_lists = kmalloc_objs(*priv.migration_lists, nr_dests);
 	if (!priv.migration_lists)
 		return 0;
+	priv.sz_filter_passed = sz_filter_passed;
 
 	for (int i = 0; i < nr_dests; i++)
 		INIT_LIST_HEAD(&priv.migration_lists[i]);
-- 
2.47.3

