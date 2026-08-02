Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE4B9C55171
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 16:26:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 842646B0098; Sun,  2 Aug 2026 12:26:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A5606B0099; Sun,  2 Aug 2026 12:26:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 644E96B009B; Sun,  2 Aug 2026 12:26:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 41AAF6B0098
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 12:26:44 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AB9DB40509
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 16:26:43 +0000 (UTC)
X-FDA: 85056857886.14.728A33A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2C580140009
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 16:26:42 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="BHl/VqGk";
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785688002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7ZB1yfEGzN5K33ID0e3bcOFkHhvifJ8hhhrNtAvrugg=;
	b=jY+64Fee5fHNLuvCSTVC5P7kYtUCXz0xnbY8ycg+3bCAqUt3PjD2GkiSQqaI84un+Lfiq+
	tfa/w/ovQBfXZHqldIcSUIdVO+1aaRu/zn/m2OToGQXHpkAYYkt8HMPRdRDGWh4yStRPd3
	OjKqwBgyerSWoiF6zU6wFNDGp0rl/C4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785688002;
	b=xI6aDto46HihgjAaU+Kv+MfT8S+Y2g6QqbwDIz3k7ZNcj4f9Kck5QIu5bBMoiSB+voP/H0
	nJUfl6d5JH2+rh416KFGuINgMXFYZyplAZh+McKOjQ+XHdJMprMLEagsyg86o3ns7GAG1K
	V1jiX/hOW4z0oKem7urmIEKyp2Aj3u4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="BHl/VqGk";
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B6E9F60DE9;
	Sun,  2 Aug 2026 16:26:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ABC21F00A3F;
	Sun,  2 Aug 2026 16:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785688001;
	bh=7ZB1yfEGzN5K33ID0e3bcOFkHhvifJ8hhhrNtAvrugg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BHl/VqGkYNrEF4AO5DDxQ8DZfWi/AR93VaCva3l+Wy7MW7g4dJuamnqSK2IrNQR3d
	 mk+XX0FUD2ENVKg7Xw6ZxplyfcPHPOKLobCgogY++kAhAgerrD9ne0SefX2YyQ4Dfc
	 8mdlsVJk1k0ABP/qkua8MIV2pQlHi8vaAstL+T6m8ECNCbHoV9f9dPatlqFEU2XpXu
	 ZrmQrbKn8fxtBYcayBzu/pPO6EkhLsVvII8W6evH5M/zMUgtRaFb/1uPpN65lPN+tc
	 M5eK0YF5Bapurtf0gvcKTMe6UupNIEODebDhMu6bGLOyo0h6OllJIFgl1n7Ak0Xx6n
	 0bqbXqYgwZX7Q==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usamaarif642@gmail.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 3/9] mm/damon/paddr: respect folio end for DAMOS_STAT
Date: Sun,  2 Aug 2026 09:26:24 -0700
Message-ID: <20260802162631.90304-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260802162631.90304-1-sj@kernel.org>
References: <20260802162631.90304-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 2C580140009
X-Stat-Signature: 6495px19nmj9hbor657469fh35jtkq7j
X-Rspam-User: 
X-HE-Tag: 1785688002-432296
X-HE-Meta: U2FsdGVkX1/5sYzu08cnWvO+sJOi++KyqLEiTTn6o8g5iMOtVTYAMOcZJ06JVO8YcUAv536/VQX7CKgLHhpzMCNr2r7F07N+pFkFYwls7CE9C/741zGQ6rib3KHxWyL3UzzKo/ci+7s3Sd/758Gd1PtJwGav8vehZ1hhN9OVsuEbFJg6NH6ccsWJcJKFydCkraoAjUeqzd7r2/ApuByOOG2uoVCl3u9dmxX69O5k2M3iWntlI7H6THEnZxjjxC6uje9FmEqshtZMgCs3K+LwN4LAaQKuUpT7QdUv7KoWWxVADoSg2zj9L8KezzWGB7cfQ78Pi1NuyWjhyH8vcclaOT6WHB2wWhUkOV2cS0ODtLgH24UrAqC4s17hBWmsLzKHOPrcUiHWMAnB1qE2do9II0QQYGD3NgSDOC/AMYeX+bO3thv66zwjouAvKjQeORNHfKsdfrVROe0Gz5kyjgpNiG58g+5QUPIYvqPSkphrVVc3t8kbSmUcQmv+5qFqXuHqiSdkGa+ssFtazZmOg5AYtcPNbXnk61ZGGXdPH0vTQJA7Pjyz2QZq652WMWDrBBNGhiCMUJ4CqeVkvMdUmhsCUIguIyqoCFCx29kXfum/GL9oLREbhGLLBUpcjMbdsQh6Q/VwOLdBYdFDQV1cmoBS/MwgPym8xU5LxPN9Iq9npw28ey2hAyHL0Ou8QMuJ+vvShJHRBSHj5XvYHutWVQ1lOJuvXx8HPoCDCNYC9u6wYfIaxjdbSqFPeZuE3UAaEwDJv9CULr0BYqqFo4G7MTcCO7+smlUALhSu/QzsChW1lGoJi5aDYi/obTHPUnefECpuKh47GlGRaQ55yRQPzfZ7vwetIMSv3aC8tWlXn9OcStkfP+s9CAiHZTQ8bTkLQjQEuhao3nGVE2w09YC9j7BhiAR39LwWl+BcFQW9PvKkBnbl8cEKrEHjRjDCcwiyWgFOoUXTrKxlBTjtIutzA9c
 yEbEW+YY
 MKtClojXeJyN45BrlQCtiyJmOEMzOwV7DDc6PFFCsumED+DCo7md3fSOAT4lpbXrJM2mg8lGa2xCnuAG8GmUk4SYKqGuuW32hLV/cfhOueKlWSAzmrWJWcObigp5Nkt2U8XcXbFBYQw2/n5Zld03BnQyly93RLuu5E+BBLgN4vcVDfRR0bY64+1FTfqayxuy5qb9OvT8evVcByx640y1KPJVTSPsdvnYgHuDdvpfLSLouieH8w8mJqsBgpT9pwqdrFaUJ1hLvCoc4G8av7HjJt2BLwQ==
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

