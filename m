Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91FBCC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 03:49:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 134646B00A6; Tue, 30 Jun 2026 23:49:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10B6D6B00A8; Tue, 30 Jun 2026 23:49:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04A2A6B00A9; Tue, 30 Jun 2026 23:49:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CF3B86B00A6
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 23:49:27 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2C1591201DA
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 03:49:27 +0000 (UTC)
X-FDA: 84938827974.21.50231D8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id A1887C0002
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 03:49:25 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m7UyyaqM;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782877765;
	b=6X18pdG08OAm/xzbdYTfleu2qSuOyTy6m/nhRmOH0cDt+iUY8O18k7JrZWGIt5AKof8vJb
	3bMeOPfIZ3Cf5mwlqva7c7Do85TVwb3Y4h7KVXAoSmK7u4qSE5q6weTQfnT1K/xbU1hXSS
	3wdeWhHkqGmq47VzrmPdairPmAVDG0g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782877765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=DSsNvKEhBE5WjxBTWWMLlI7db6DTdt9TNuLjxtRycHA=;
	b=P1vJFSllFdBRSDDZDTpLjHuKeZppiU16aCPV2h0Nl0vrxNRJZlja5jNEqcgwAgK2MwBm2e
	ee0sUkjKJxJawW9gi+QyIj6rI0ENCWkB5puXWu0sX++QPqC4TllXaaWxMRbYzfb3y0U2tk
	n8IAzVTa+KHLivLoilEgHPGj4xDnuGk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m7UyyaqM;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D1D584076D;
	Wed,  1 Jul 2026 03:49:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75D981F000E9;
	Wed,  1 Jul 2026 03:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782877764;
	bh=DSsNvKEhBE5WjxBTWWMLlI7db6DTdt9TNuLjxtRycHA=;
	h=From:To:Cc:Subject:Date;
	b=m7UyyaqMGmKsZsCAJyJQIIEUp67RIhDIq9y+b8ac8fOpQA5Qk0uxhOTa8cdStG01z
	 /1Tdb0AIOaZupv744SiazIjaDztqrQ2zGJ3PxkGL1c93AXu50nQt36EWsCkbB1h8y9
	 q4GwLsFj+XmGhSKW1eWE+z5Bv1RZKD6YBk/+8zHzhfovpNWLTZW3BDpf9vsofZcxUP
	 k/mdIcYiR3kAQon4kkcDeYF3gsMWqqXHYpir9Muy2eGe3V31w432OUZZlISooK5UIB
	 b9/wK++cYeuakV225wYzRCgQWKnbYrwjEMPQ4DZfjKWVtiUv+gtVKvYRQtdqwGp5zQ
	 YAFh32ZeTaarg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	"# 5 . 19 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH] mm/damon/core: disallow overlapping input ranges for damon_set_regions()
Date: Tue, 30 Jun 2026 20:49:18 -0700
Message-ID: <20260701034921.99179-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A1887C0002
X-Stat-Signature: ejf7eiuac93nqqoh7g3tgjwuzk6n5j49
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782877765-217040
X-HE-Meta: U2FsdGVkX1+UrK5QXzYsPXt7PhqY4x17i6GIQuFvkPxNRl74DVo641T0xKAQqrYP0G3QEic36Y9MwrY5dzoXdUsdizl8nZfmSwqkXSuaI7EgfvfHcdPnm81zO96a0UmRo/PgDZoGqJp47IKd2zXut5ilbnxPYC6lLhgLPnq5bIe0YIXp6nC1GrVb9LqAC1N2CqfEDZQIMhmSphx5G8c2k9BzD3yxpgdZ0CqEjt5RmPmoz2Hcki77pVebRh3TnAJiA5+jXE/vzi8CVS4H6MAONBSxn1j+LLbyvcfpag22mFsjeEgk1HLd9scxKVui8nrc6bAISbEZaFY4CbRTI+UnycEwGPvnMr4YS/TE0RCLgLPO91sl7SkES3MSzkV5MvpR4eHD3TSjHo/FGVqrsqkTakdM4WFjWkUZjL1IglRe++9BP6HpvjkUumN3mV2nicBEwUkKu9026CmNx/1TrNBIuH/h3mdXVpFEdreMopmBy+OMi3fbJ8dH8LZMMO3nDxTOs1583PIbGWezAyvXHE3fFvHuN0pWAxEr36btODLOQ+ABkcbH2jLPoDEjdjjZE/bI/3Sj3US74QKmVo5Fo5+m6Gvh2k63ocjpnT2ByL9bAA4EV2IMeWkzzUwBdvIGli5rLbnxrqz3TkG8B9DHazdR8aJS1hy9gyWEqWg+97Ud9IyezFicfKtf8ASSf1uc1QQdQRUa3A6FgIWGFi/HjtJ4LG1GQh2W1RRqOdlZvk2GlqMugj/gWUCn5XSt19PYAAnr1fTaUIAYNGFXa0XICrKC06ykXX+qW+ytNTmdOp/eqd2/v+gnueyll08p7EJHteWx3skPtN7KAnbLyUtHF8F6f980ZbxmCXOpYy8aMs8i00ZafL5P1iLwStVw8NBhmeEsyLoqAYkNDW7koWiJhS9oeVgrVI1Sqj7loNRI7B7lO3cPkyQ55pEYa851XQQ70g4nb7UDzczty0XB1OkoMe8
 +vKnbVXl
 g811jXPApKZtUpYpSsLvtelRs9wGDUPZEZJpEo5UH8uG73yJJeN6UM8wQen3SHGkzWv8ADcm8FWvowyFAzwTj/+Bwb2esHDMMKliAYXIfoe3BeNvJsW9Me07/Fi1QgSBC0k7DfTpetGg2wZmtVPIRnJEvxpZ+IPq5M9ZxHa1uCfhPRivA13Kvp6oR9I3EZdDqbPZNRDOCO1dx4VAAulNnaZTDfxLMKoIdxcHkCEQYE4V/347w5WshzTd0gmkPiV3cUAoE6y8eLTYFMd8ebybu1OYx5F6WxY8s+Jt8KYk1NuhqQ1syGkZopqIEPVKdBWHMXprV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_set_regions() assumes the input ranges are sorted by the address
and don't overlap each other.  Hence the assumption was initially to be
explicitly validated.  But commit 97d482f4592f ("mm/damon/sysfs: reuse
damon_set_regions() for regions setting") has mistakenly removed the
validation.

This can make DAMON behave in unexpected ways.  At the best, the
monitoring results snapshot will just look weird since there will be
overlapping regions.  DAMOS will also work weirdly, applying the same
action multiple times for overlapping regions, and make DAMOS quota
weird. More seriously, depending on the setup and regions updates
sequence, negative size regions can be made.  It will trigger
WARN_ONCE() if the kernel is built with CONFIG_DAMON_DEBUG_SANITY=y.
Depending on the monitoring results, the negative size region can
further trigger division by zero in damon_merge_two_regions().

Fix the problems by checking the assumption and returning an error if
the input ranges don't meet the assumption.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260630041806.151124-1-sj@kernel.org

Fixes: 97d482f4592f ("mm/damon/sysfs: reuse damon_set_regions() for regions setting")
Cc: <stable@vger.kernel.org> # 5.19.x
Signed-off-by: SJ Park <sj@kernel.org>
---
Note that some of the consequences including the WARN_ONCE() and the
divide by zero depend on commits that were introduced after the original
broken commit.

 mm/damon/core.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 972a19fcee3ec..a99458c578518 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -354,12 +354,19 @@ int damon_set_regions(struct damon_target *t, struct damon_addr_range *ranges,
 {
 	struct damon_region *r, *next;
 	unsigned int i;
+	unsigned long last_end;
 	int err;
 
 	for (i = 0; i < nr_ranges; i++) {
-		if (ALIGN_DOWN(ranges[i].start, min_region_sz) >=
-				ALIGN(ranges[i].end, min_region_sz))
+		unsigned long start, end;
+
+		start = ALIGN_DOWN(ranges[i].start, min_region_sz);
+		end = ALIGN(ranges[i].end, min_region_sz);
+		if (start >= end)
+			return -EINVAL;
+		if (i > 0 && last_end > start)
 			return -EINVAL;
+		last_end = end;
 	}
 
 	/* Remove regions which are not in the new ranges */

base-commit: 81c085116d080d3f35279353cdec773e02f43fe1
-- 
2.47.3

