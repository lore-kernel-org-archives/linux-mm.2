Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD9C3C88E63
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 17:17:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B3666B00A4; Sun, 13 Sep 2026 13:17:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 017FF6B00A5; Sun, 13 Sep 2026 13:17:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6F106B00A6; Sun, 13 Sep 2026 13:17:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 86DAD6B00A4
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 13:17:19 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 95EB2A08FF
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 17:17:18 +0000 (UTC)
X-FDA: 85209394956.15.8C36E0C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 10F2D40008
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 17:17:16 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k0k86qgT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789319837;
	b=CFBqd5cVXEFFW7kBI9fhhVTtftI6CXr40FIDuCrSOIJ1G9//j1iW1D2mmaVMi3OL6bj/4K
	FHpVTpNeTkmcXoT6UJV/OilQuhmOTdCuiGnlRpRbIolgiAjVV1VC+7EbtiZt3DteAki6Kc
	58Qmkuq1Rt+CtYjvIZniCu1iBta14S4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k0k86qgT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789319837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SymGB/Aunbf5NpktH/MrAmxXwvCzvOB6NopidPvvPWo=;
	b=TxkEoG95UaedwMIoOtuJESmBsM2xhSn05iRa1sQUe6HojGLt48HCzkhb6WrgoeI7+iH7jQ
	LfGOA3+eENZG5eC0Qw9DpyPZ+RAt6SOCCNX1/iCeK1/PijDT4eXGGjQ4nnkQ3us6mBs0jP
	NbIXu1I0JXU5R7R4DTxrEmdHrG56eLo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A788660E97;
	Sun, 13 Sep 2026 17:17:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 386A21F000FF;
	Sun, 13 Sep 2026 17:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789319836;
	bh=SymGB/Aunbf5NpktH/MrAmxXwvCzvOB6NopidPvvPWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k0k86qgTdxcrL1TMu3BFfRdT5rho6ri0dpAB17vwosjSrW6Kf/EV9EfrTAHitpmI7
	 2ssuYPLAyQ+hcc2Drmq1omyEDdueVowfnLlCpaIwu3V0X3prCI8exkKB//W0aqsHyS
	 FSk8mUb8vlrX2ra47BQIZeXI1lb1XxKsSYqj7UVk8taj3jkIop/n6zswfR2G9ItFj/
	 pQPQ1cQs0pvS8wdyF42jPHSbX2DsymaJCO05KDHU34kFKtgYqHD/+k+LJY+DG/d58n
	 qcrTjiQnE8VWVLssKq4UBWKEIzeFib5SFkV2al5VTeSZ9AWLMW1rT14P8LL8NAoQqx
	 u6g2GmwXQOMqA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 5/8] mm/damon/sysfs-schemes: drop centralized filter range arg validations
Date: Sun, 13 Sep 2026 10:17:02 -0700
Message-ID: <20260913171706.103052-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260913171706.103052-1-sj@kernel.org>
References: <20260913171706.103052-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 10F2D40008
X-Stat-Signature: wyob1yog9r89s7pz4y4m81ubg7htquez
X-HE-Tag: 1789319836-320282
X-HE-Meta: U2FsdGVkX19B0qYbZuDHjJf43oEG2L2vSecx65fMlRGlhTgLjUCC2dVbqoGfrDS+HUku7oPWvGGBSfUng7mCGXZ6WPGSNS68kufW8ou/hx/I+GcPA5shmr5iZhjcTDIPZe8rKi9cqVvsvslPucVaU6GARCqH37p/w+lCB7QEI5Ppf/P/hytXkFLfKL3l61Z/dlCyW+3A1tgDBNzws50EPoxNEMgZOtr8yVVVrpkqwyKC6KsffEgklRmKv45my9hD+HznAxZVDPOU00ALtG1EA5nF7ZBC1fR7LI7TVN23ySY14OYcyqxsy+9dnpnifrF9vozqYXpWatfOu50jOE/yNGPLnkTz30EKUJ4QILROlBUm7bl5HQ3RQ4wpCtVpdu2Lm1IMOlG+6A34CsHgxJgCoPLe4NhyY846PXEjvKXtN+dpBU5j9N+QXEsDuVcIULb2WP2+M/dIf3bixJ7jtCfhIdJkkrPrYi7N30vJZVwt97r9P7VQO6hR8335XJMEZmyV7e3m2QZLRguoCwNM4jaa+qSNvOqyiyru1x0+Np7D/aUFEGlS5O9ot6pPmxvC2bP1Nq4Zg5WYT0sNf6soJQb7fiuYDz+SQVo8QOb0WsZI91dQtXYh0Yi2LvSxO33okbZ/oZ+9JzBRqw1ZtPvZDUl7vtH4pXhAClyV0FIDeqPPPG9gyaZOvE85oTZ40QuvzNEjSfIQSzQ4oTbyrdehiGQU3zFa/JoHIXFL3p6g6tvQqcDk9HO8stiSa+A1XD+RF3N/01/Nn5iy7BjrYYbPIK16JeZnord6saZ3nkRgLnOI9iTTOIb7spMNPoQ7hxGnK+2jg+doTHZl+OkUAlfUak5uslooEkp4KI3ZlIUGC8E657TeNB5Zug4ZoCNUZMmcYhTPQGFmNma/tNPecKjcfWlmfEviSi7G7lC1FJ3fIjo9KeYV3z+X90Bihj33GnKRckY1BCOEspysrHzOvKS8XRo
 R3Ygt/ga
 zRMzrp5P1zeftIvYBUXmR00v8zJ2ByBBHmRlzRe//eJgrXDG9QNyNaZ1BFgO6/sSzvB1nuAEEjlAv5IirutQQdFI9aB5+B/K+8pylZoguyB+yG5HZOG4OoCvHfDOcz2xuIBmQDxNOA3p7G0NI7GdAWUvzrcRCIA/baCkUkvEDHYEkmhf2gCLjUK5x9ptdvJPvFMPxyuSlPQbKrH7mKV/S3IAsRWWSqC8P1XbbvgdbKI7L4IY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON sysfs interface is validating wrong range arguments for DAMOS
filters.  Now the core layer is doing the same validation.  Drop the
duplicated validation in DAMON sysfs interface.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 8c8ab82c8facc..a4ec5d54cfbd1 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -2832,27 +2832,14 @@ static int damon_sysfs_add_scheme_filters(struct damos *scheme,
 			}
 		} else if (filter->type == DAMOS_FILTER_TYPE_ADDR) {
 			filter->addr_range = sysfs_filter->addr_range;
-			if (filter->addr_range.end <
-					filter->addr_range.start) {
-				damos_destroy_filter(filter);
-				return -EINVAL;
-			}
 		} else if (filter->type == DAMOS_FILTER_TYPE_TARGET) {
 			filter->target_idx = sysfs_filter->target_idx;
 		} else if (filter->type == DAMOS_FILTER_TYPE_HUGEPAGE_SIZE) {
 			filter->sz_range.min = sysfs_filter->range_min;
 			filter->sz_range.max = sysfs_filter->range_max;
-			if (filter->range_min > filter->range_max) {
-				damos_destroy_filter(filter);
-				return -EINVAL;
-			}
 		} else if (filter->type == DAMOS_FILTER_TYPE_PROBE_HITS_WSUM) {
 			filter->range_min = sysfs_filter->range_min;
 			filter->range_max = sysfs_filter->range_max;
-			if (filter->range_min > filter->range_max) {
-				damos_destroy_filter(filter);
-				return -EINVAL;
-			}
 		}
 
 		damos_add_filter(scheme, filter);
-- 
2.47.3

