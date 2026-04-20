Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45AB8F588E3
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 16:14:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DD496B008A; Mon, 20 Apr 2026 12:14:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58F8A6B008C; Mon, 20 Apr 2026 12:14:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47D446B0092; Mon, 20 Apr 2026 12:14:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 359256B008A
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 12:14:31 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DA7FFE4A59
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 16:14:30 +0000 (UTC)
X-FDA: 84679431900.16.4196404
Received: from pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.1.125])
	by imf18.hostedemail.com (Postfix) with ESMTP id 67AB61C0002
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 16:14:28 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b=GZtmEplY;
	dmarc=pass (policy=quarantine) header.from=amazon.it;
	spf=pass (imf18.hostedemail.com: domain of "prvs=563a806c7=dipiets@amazon.it" designates 44.246.1.125 as permitted sender) smtp.mailfrom="prvs=563a806c7=dipiets@amazon.it"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776701669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=4O++pW9Xbgus6i0sqISNyUGab6AsMHTSYNj1rQkW9es=;
	b=MEFxjPSX4yWmH+TgFEdSg1g2+4er2lCTlkVSnoxuJq+8rDzUtcD9fF04m9exdkGbvyRwaV
	oG0qtuZVllA3jlD5DG+pcF6hQ+IqC8dHbL1WAE9k1Eh8pfTah/KphS4zZBSmx8w6dWU8pL
	gIVAEEu6oqVj21Ew0LWudV3HQfZ2qhc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b=GZtmEplY;
	dmarc=pass (policy=quarantine) header.from=amazon.it;
	spf=pass (imf18.hostedemail.com: domain of "prvs=563a806c7=dipiets@amazon.it" designates 44.246.1.125 as permitted sender) smtp.mailfrom="prvs=563a806c7=dipiets@amazon.it"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776701669; a=rsa-sha256;
	cv=none;
	b=i+gLk0FV+ZnfNMVDeoRVZsIq7p/WXr/8lAos5CScqvHSq13dujBm68LewJ02kD7Q/mMtPE
	CBSLPch034toP38PdmMK9LO/jKrWAo0ZvTXlqddAYaJI2KWGlyL+KFgVrixA0Yc7QNZtpb
	8IZPnJuuH8EvsfooPBg1m0DWxinvYl0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.it; i=@amazon.it; q=dns/txt; s=amazoncorp2;
  t=1776701668; x=1808237668;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=4O++pW9Xbgus6i0sqISNyUGab6AsMHTSYNj1rQkW9es=;
  b=GZtmEplYTiUqSR/67Alc6QswG8+XPaso74GFQ/TLAc1P5YBhYWl3mNC4
   RGzHtcl4n3RWmXy6J1VWZudpCgaY3EYwh86xXS4gGm+xgTGIi1mu4ZFhX
   LMCtZTKlaD6vI77/7hKdsSZQBCwCf03cJ6cq0sv44IAsaQnRG6tsiOQT0
   sUFhlDyzJhlqdMvka0EiSAhmF6s5XolzAb8oFEizodzL9mfTkXu9qtIJZ
   UVlQXp5MTNtI1jjLCTnOiavTE+/63YjXvViRo3r6m7EhGrwVOuhB4Zx42
   NBlAibRmdiJHncihURseR4C/V8NzYPipyBOwatlXPpypY3u1FX6PZ2O7k
   w==;
X-CSE-ConnectionGUID: fItFHySZTnKCgGaNsgSP0w==
X-CSE-MsgGUID: M5YpE+EUQMKeBZiFi0AZ1Q==
X-IronPort-AV: E=Sophos;i="6.23,190,1770595200"; 
   d="scan'208";a="17744120"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2026 16:14:24 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.105:15252]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.54.92:2525] with esmtp (Farcaster)
 id 0fb7fa6e-3822-49ea-b8c0-62c3590e6f16; Mon, 20 Apr 2026 16:14:24 +0000 (UTC)
X-Farcaster-Flow-ID: 0fb7fa6e-3822-49ea-b8c0-62c3590e6f16
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Mon, 20 Apr 2026 16:14:24 +0000
Received: from dev-dsk-dipiets-2b-fa1865ee.us-west-2.amazon.com
 (172.22.139.101) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37; Mon, 20 Apr 2026
 16:14:23 +0000
From: Salvatore Dipietro <dipiets@amazon.it>
To: <linux-kernel@vger.kernel.org>
CC: <ritesh.list@gmail.com>, <abuehaze@amazon.com>, <alisaidi@amazon.com>,
	<blakgeof@amazon.com>, <brauner@kernel.org>, <dipietro.salvatore@gmail.com>,
	<dipiets@amazon.it>, <djwong@kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>, <stable@vger.kernel.org>,
	<willy@infradead.org>, Jan Kara <jack@suse.cz>, Andrew Morton
	<akpm@linux-foundation.org>
Subject: [PATCH v2] mm/filemap: avoid costly reclaim for high-order folio allocations
Date: Mon, 20 Apr 2026 16:14:03 +0000
Message-ID: <20260420161404.642-1-dipiets@amazon.it>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
X-Originating-IP: [172.22.139.101]
X-ClientProxiedBy: EX19D040UWB003.ant.amazon.com (10.13.138.8) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 67AB61C0002
X-Stat-Signature: tq44m1rtd6ywkfodwsbez7ud4cyo3n4s
X-Rspam-User: 
X-HE-Tag: 1776701668-237983
X-HE-Meta: U2FsdGVkX18TwYwjdRNeasnBY/mQ6VFOiBbxdmMA5nweC8jmYpkmDeXGRh9RTZdhP5IeFoBbt7oZ1WSHkKyd4uMK52z9dym2KJUYEuMsG/cPGxVDng+xA9hEIFjHMpB64hhp3JcqJBqXOluFyKt/JC2qxWoJMJ3HuDuC4wx9FKXoefMDvDYSSwetjPdMLEiYYL9IvqJncZ61Gl77MWT0Dkrgi927rCO+6YO7u2Z4TNiJK54TNw7l3qHhICHe4fkruOz0HD/24c5ffUFinGVMPA1BtFDyak87mYVqpJIu+KsIZLo1GLFGX0w3AUWYhWfAPgJRgM2814gteagff0LrAH8qv8Nz657rvRynS8yAtZkZYvSAPGClBmzQOmRaNbAoy50vsrJ0mbzRiJyxUkrwxeea7JGAlrwurv1R2bAcglRJEKkOkDLg54cPoEO1hYsa1NrTykTWJurZ5Lwwoa8asft9UtW0qgiJ6R9PqDnau/IBIk1+D7TEdpjkDscGL3q/SJqjUd/6aXHYgQCuUbyHXvkP6oxG0dfwjhlSWhHoUC89zgoLsth+mq8xtF+L7zftdx8m1M6t3j8xUCaZ2/rsdfmV/yUl9GN7T00hOIyQ7i8X5AsOmtGkhHUFMsJUML1VUB4adQnYIfRpG4ggBIX4PxWIYZY/d+pQ3z2p2Zm0VXa8prYtRahjjSEo2AcYfj3wssSKYxKeJZdgBrOXDAvT3M2IxMIEn2pqCXoEkqVs2koD3XWPr4bzFF+pGPUnT6QWT33fm8iFIF9IGglQPLp6O5N+hfQmw9YxAD8x3uX9OvqPk3csc6URCoLllaGnHsDOmDeVwNWJiotfQj81aLOdbGf7VQDWSarhMinLOAwKnEXpQx+vcCFckzn6PN2prEVpLygb73xY9BPxllSB7PpjMPv8ZeWqlyoFRWSfUVnWoEj3/HJjWibZCN7ldQNG7ZqoeaMdpwKPNTZzrRTJCSn
 mXEzQrwk
 sI2Sg7kGhQ4DHh0aAkp8r3bLbp1PDrzSAMd+BUZdBV2RSLoGhj4tcoZEznBNkyHHqFW02PXUxWR4JxJ9Qn3QQcn4HC3k8SesSf+qglPQLeHTRBvpc4uyOGkMhCeV2htevY8gd3bbJ/gcRFs3VbXRdeVui7BT2MrGIhm5EsA6sz/XJQEJPv0U9cCQRPhHZZW8Jr8kKSugGqWvdSnnX4wCgxVTwszcrfswyuq+ORKG3Pd0UDL0KZpgo4JzsD+V+jNHRlZV9BNTNuEqOY37CZ9qPu5z63VViPcY+ihFEcm01yL7h9N4Ed2YNMeawy2+Z1pKoa66oFAJQvpE1iKJcRaMU+fjGxidsC4IDLFg8To+jHVTaatiobaMVvgf0co4DImP/ZijNnNJ1K3aUJEYIbxWP5COOytv1Nps3RraKLjF7hZAPs9iGcEcFFcb+J9lpV7KfshgVPzOmNrU67zlSV4krXDpIy+rN+v3iiGpobAkXJvA8grXaXE5WglZTPUPIt6Ojbm2L5zKUj0JGyQXZm7GtX9faTg/axKCBMXPzp5p1c2F1jy6R8PfJIK6j8O5bWBQBwlUMEwZ0060uIjJpKIlPKji9B/+jdiTfqHE3TYw9/zTkBpGni3HL5/iY5Fwd56xXzwqtYUOuassvBnA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
introduced high-order folio allocations in the buffered write path.
When memory is fragmented, each failed allocation above
PAGE_ALLOC_COSTLY_ORDER triggers compaction and drain_all_pages() via
__alloc_pages_slowpath(), causing a 0.75x throughput drop on pgbench
(simple-update) with  1024 clients on a 96-vCPU arm64 system.

In __filemap_get_folio(), for orders above min_order, split the
allocation behavior by cost:

 - For orders above PAGE_ALLOC_COSTLY_ORDER: strip
   __GFP_DIRECT_RECLAIM, making them purely opportunistic. The
   allocator tries the freelists only and returns NULL immediately if
   pages are not available.

 - For non-costly orders (between min_order and
   PAGE_ALLOC_COSTLY_ORDER): use __GFP_NORETRY to allow lightweight
   direct reclaim without expensive compaction retries.

With this patch, pgbench throughput recovers to 148k TPS (+67% vs
regressed baseline), stable across all iterations.

v2: 
- strip __GFP_DIRECT_RECLAIM to avoid costly reclaim for high-order
  folio allocations
- Moved fix from iomap to mm/filemap layer

Fixes: 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
Cc: stable@vger.kernel.org
Signed-off-by: Salvatore Dipietro <dipiets@amazon.it>
---
 mm/filemap.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 4e636647100c..f2343c26dd63 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2007,8 +2007,13 @@ struct folio *__filemap_get_folio_mpol(struct address_space *mapping,
 			gfp_t alloc_gfp = gfp;
 
 			err = -ENOMEM;
-			if (order > min_order)
-				alloc_gfp |= __GFP_NORETRY | __GFP_NOWARN;
+			if (order > min_order) {
+				alloc_gfp |= __GFP_NOWARN;
+				if (order > PAGE_ALLOC_COSTLY_ORDER)
+					alloc_gfp &= ~__GFP_DIRECT_RECLAIM;
+				else
+					alloc_gfp |= __GFP_NORETRY;
+			}
 			folio = filemap_alloc_folio(alloc_gfp, order, policy);
 			if (!folio)
 				continue;

base-commit: c7275b05bc428c7373d97aa2da02d3a7fa6b9f66
-- 
2.47.3




AMAZON DEVELOPMENT CENTER ITALY SRL, viale Monte Grappa 3/5, 20124 Milano, Italia, Registro delle Imprese di Milano Monza Brianza Lodi REA n. 2504859, Capitale Sociale: 10.000 EUR i.v., Cod. Fisc. e P.IVA 10100050961, Societa con Socio Unico




