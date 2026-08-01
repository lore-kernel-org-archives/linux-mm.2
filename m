Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57F63C55173
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 17:36:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55EBB6B0093; Sat,  1 Aug 2026 13:36:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50CDB6B0095; Sat,  1 Aug 2026 13:36:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D71A6B0096; Sat,  1 Aug 2026 13:36:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1ECB66B0093
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 13:36:09 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B4EB1A0342
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 17:36:08 +0000 (UTC)
X-FDA: 85053404016.24.41D92CF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2E01F1C0009
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 17:36:07 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e4PRMLtq;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785605767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7ZB1yfEGzN5K33ID0e3bcOFkHhvifJ8hhhrNtAvrugg=;
	b=vra+Drasmeo0SNC8YTLoVsZA2pUjDLRNyh9o6ehASaLFLPTwXcYobP6ZXpQQhSOR0Tokoe
	OH1mBeqqMALCB1cmHHFVNRhv896OHwecl2AsHXQnpBJ2oCzSxNFTZq7rzYAOI8/2QK5Wbp
	O9tauXPSLpgsHfqZlKZIZBDq4DidPic=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e4PRMLtq;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785605767;
	b=m3Q7Qrn8rjayMOlYyJyWuuUOyeggP7AZ/hZT2Zz0JC4c3okjRaB00Ik6Xakkk3Ji+rde/W
	viNtMIFnXQc/bHIYHCO3uU5+4o3thY8qrUr2838PrFxkGZLgWWUHG2g4I6toGMcHSEUEbN
	5g8qPFItVV//OlNmNwD8ePhsui2AW6M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 80EC44377B;
	Sat,  1 Aug 2026 17:36:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D4A51F00ADB;
	Sat,  1 Aug 2026 17:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785605765;
	bh=7ZB1yfEGzN5K33ID0e3bcOFkHhvifJ8hhhrNtAvrugg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e4PRMLtqTAjfRRZxmbsgvWw8e5lXePPUxbbTmhN0W/gAIwMdFP2qf6r4/oc/MmsOV
	 WQWLRvTzQUmxzXrDyf+QtyI+FASDmSsCeP5EeP4O9QlBWh8QPhCXwjgmii5PZqIF8c
	 H/gD72ItYDDgLlpeuaI7gkUal4HYI7fGs335IzK+IHJIWyC1scK7i4p/BUUl4gN7m6
	 +oeDBpmtrTOxWCnRUIpWE54a4LAo31ZKjGDnijQU1azkSyuFcQJi+GQZc7eAVOlI7G
	 G2gkp/WjlkAbPyTrt7hhVgfNRGj7IemSXr+IqRmw3zoXc7vmBrLbdqzgcE2rB8ccO2
	 4nw3NH3ZZb5hA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usamaarif642@gmail.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 3/9] mm/damon/paddr: respect folio end for DAMOS_STAT
Date: Sat,  1 Aug 2026 10:35:46 -0700
Message-ID: <20260801173554.94710-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260801173554.94710-1-sj@kernel.org>
References: <20260801173554.94710-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2E01F1C0009
X-Rspam-User: 
X-Stat-Signature: h8rezfdkgnw5i6fxpok8cwmdygn5iwbf
X-Rspamd-Server: rspam04
X-HE-Tag: 1785605767-118802
X-HE-Meta: U2FsdGVkX1+sggYRHOUulPWI6FP2XBRLrmTEd2QuSHrPVVz93D5MqyabX2bwUsekwwFktB6vOKanvISkirHiNVnM6xxPJfDIRVbPmGd2O37Yw7va1DwNpnDcxxS21+qctaM7GAbdQdOSzVGD3XY6iXXJ7JnQgRFyM8cb2n/vZFo7Zdamz/CW/vGQbakxHQtIhCeUBd3y0HiL66SC9XFSWq2g26VUjjpLHh8Q3idfl8wo006YpP8mbSuY+x7klVI7BNYuWHB/cJB5TJJ9Chc1rTT15rkrCgNNCo6IQwiC5t5Z8FGNNLNyqayEHGsqwaz0Uq+w+6c3eJSSStkGGw+34KXlXNNgOoh46XzE42nzJO8znIfAVia/D3g2likHDcVBtlNlDmd3ChP7bnZl0NoAVYxP2acvNN4yVCxfByApUIJjMP8mAOfSrCajXfBygAwiCRSeUp0+B/apfcARvnohJfVdaGgu7os5YL1Q7XSOIur3hVQjYd48BPwyoXjiXnX9mIH2N1p7j9lZaALQOq0tP3txI1rpz/+SO2Alx/jmkeIWzOXGADcTJpXWLZSC3eaiT447dLpeqoTNHQ/ghoeZ725rNBZrGJO8MrPpSgvsxnxgNY1hGpe3x8I6Opql1MichxypUIeHsMGCamjPgqzfSqZ8oxsngd1C7CtGqG7Say9C7Ru440BB1PVexvIbCCwx1Qv6Yn5m6Eg2EJzHvlB3q01MjweyY7b0XTnmDArO+iTp7sHGetP3lK119izvvC0Xf1BOoZRhCGXSLK1Zs18peFCDUKiQsr8KGCte9WaLgL9tC5DZfazYceNcrzBDEzpdIv8cnyk152A0KHfPiIISvKH0ILvCHcxP90uqHgRKbO6OF6b++Yt++hYmSLT96mwap4+c9W4qhXzJeqfAWz8ovbG62vha258VKub1jCCEZZpXedW8JLhhxmMKn3s/iZn4EKbh6OFeMxuAlVoKdAb
 nLW5HtMf
 UdoC1nfDOoL5TsvwOwtd2ZbnvcQZbbQd3Gq6/ZfjBmp/rkr/TceLSOsrSte5HMvsCUBdAsu3ePVgk5uNgXNRUQa9JWCQrLBGFCWCLXhBDFlSPHTzkajhCbWkz+tOFoUggzdkzz/4BxPjdOEJimjoOQuyffa/SNfl7xiCo6EAMXPcgU1E9dANFxOK+/4iFE1H8ihyxOvnTQbZC0r5XGWLyxtqCr7Irsun9hB8g0UjkgBs4HG3OdciejF0NNJRJHa+zHdSZpgVRTbKqrorCkQ6sLtaefg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The function for applying DAMOS_STAT in DAMON physical address space
operation set (paddr), namely damon_pa_stat(), applies DAMOS filters to
folios of the given region.  For that, it gets folios of addresses in
the region.  It starts from the region start address and advances the
address by the size of the folio of the address until it goes out of the
region.  If the start address is in the middle of a large folio, and if
the next folios are small, some of the next folios could be skipped. Fix
the issue by advancing the address to exactly the start address of the
next folio.

The user impact is that the DAMOS_STAT-based page level monitoring
results become inaccurate.  Since the page level monitoring is supposed
to provide relatively high precision, this is definitely a problem.  It
is arguably not critical since it is only monitoring quality
degradation.

Fixes: bdbe1d7bc325 ("mm/damon/paddr: increment pa_stat damon address range by folio size")
Cc: <stable@vger.kernel.org> # 6.14.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/paddr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 5c6c3a597fd0b..2ab7b3842701e 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -379,7 +379,7 @@ static unsigned long damon_pa_stat(struct damon_region *r,
 
 		if (!damos_pa_filter_out(s, folio))
 			*sz_filter_passed += folio_size(folio) / addr_unit;
-		addr += folio_size(folio);
+		addr = PFN_PHYS(folio_pfn(folio)) + folio_size(folio);
 		folio_put(folio);
 	}
 	s->last_applied = folio;
-- 
2.47.3

