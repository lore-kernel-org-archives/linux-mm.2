Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E959ACD3427
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 21:05:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E3F46B00A6; Fri,  1 May 2026 17:04:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BBF96B00A8; Fri,  1 May 2026 17:04:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 395F46B00AA; Fri,  1 May 2026 17:04:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1997B6B00A6
	for <linux-mm@kvack.org>; Fri,  1 May 2026 17:04:21 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D89DB1202B5
	for <linux-mm@kvack.org>; Fri,  1 May 2026 21:04:20 +0000 (UTC)
X-FDA: 84720079080.23.5E212E5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id D474A40004
	for <linux-mm@kvack.org>; Fri,  1 May 2026 21:04:18 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dGP598je;
	spf=pass (imf12.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777669459;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jN+8TZbaEMey9SrXVc3rXYxw6y94JJQCSWTR8U1Gb4Y=;
	b=Ugrtuv2EGBlwS7weZXlITDhnXmyjX8rZsK1tdYJWD9Xh3HmSXDOjs8pVuj7ovEfLP4u4vR
	5d/PZ4q1iORhJnJ6R3nwibRCfCGi4B8qicX9sBSuIcKYWArp5jPbWK+GcyMq9a7PJFvg+c
	7yi8D4EOWqCBAyfei3RsQlCafo1YB5g=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dGP598je;
	spf=pass (imf12.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777669459; a=rsa-sha256;
	cv=none;
	b=R2QUoarkrf893HXn2vYF8xcnK/nqQyjaL4xMAQFZYswxchHVTUTb/HuWayfDk3sSl/YBx7
	uOi8qj0vqyBJFml4P8Gd2hhHMMEJWps0o4Wa02h5OaXtG5fryWDJMrPcEfrO5vJZFR147/
	OyBgvSrXclgg07UijXYN8RDWcdHRabM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 76EC44455A;
	Fri,  1 May 2026 21:04:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5727FC2BCC7;
	Fri,  1 May 2026 21:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777669453;
	bh=QmJnoJw3TwuGtbylrumLElnsij6ui3k2H3ZChDmHvxE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=dGP598jexZOuQRzxnUGrd6SKnlQjrYLkhnamtJXYN+oGlkhGUCoglNSvzZEl8uhB1
	 ozz9EnMoQ/TdeCFQSVg5nO6ESun/vEXNtUUnnupEq3jviqEbux/OpTxkrjEpxIWwmS
	 ikAYymnXoxW6VE4J/WwBUTWinOrtOuihalLyGqrXqCAzedycFP+vJyBLadvNRuFEMq
	 kGzBeYZ2e5BHBbMpqfEGcoIQZlaei5+fRvjslN9X9yQl54yARJ9sDNiYQldOCuyCqL
	 EMvwd3WMAyj6TSF2eElBpasIl+6H7YEavrYswrqZ6Y6VdrRs9A1QJDUszWhzBA/28K
	 JBiuTMumIdptQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F731CD3427;
	Fri,  1 May 2026 21:04:13 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sat, 02 May 2026 05:04:04 +0800
Subject: [PATCH RFC 18/32] mm/vmscan: convert to new bitwise identical
 helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260502-mglru-fg-v1-18-913619b014d9@tencent.com>
References: <20260502-mglru-fg-v1-0-913619b014d9@tencent.com>
In-Reply-To: <20260502-mglru-fg-v1-0-913619b014d9@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Youngjun Park <youngjun.park@lge.com>, 
 Zi Yan <ziy@nvidia.com>, Gregory Price <gourry@gourry.net>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
 SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, 
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
 Zicheng Wang <wangzicheng@honor.com>, 
 Chen Ridong <chenridong@huaweicloud.com>, Tal Zussman <tz2294@columbia.edu>, 
 Kairui Song <ryncsn@gmail.com>, linux-kernel@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777669448; l=1005;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=g0CjYTRIe9ngM5FeeFowlBKRaYV4naFyb1v+5e6oewY=;
 b=1O08Fjuv7dDsUSN65/Nh/EKQX5Zn+CfMlt8A8CHIlb4oXMYvuDZNoL/N8ajhstsKC7eU8DLsw
 Xvzd7PgG+K0BufVemZT87auAAygwRgKn3y6d7OMjSqe/ca16Fjp1BzM
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D474A40004
X-Stat-Signature: ooge89kizkheu8zpa4e6expybsybh5nj
X-HE-Tag: 1777669458-781739
X-HE-Meta: U2FsdGVkX1+wNJb6IIOnYyxpzZdYcE+eB6zTcfaAy5H3mZI9+6XyADuM91aPB7+Pvi8TtfPnvB96YcknY7Ft3Nottd5ozi+aqKFudxS4YbL2g+gtdntS0BDJLztsyOZjkuW9M3F5YKSfPJP2f1vva9qqZDHTVk6kWYhw+2wN3d1SbNuKZfF7uUieOJmkhznuhdWicUFre+wddRNHMyYVwTBZm9umoPLBT5Dsb5Z3HDN9SQuyDJgidE8sb94yl92tPAo7Z8RdTsKLgN99uQmT4QzEiOpTGPIKX9MEq0bvzPi4rV6KisoVWpkST8RcHl38AXJSuW/180XgW100bhELqs9+BrYSKHlInmOJb5PdVwDQ3c66QTyJbxLWmfkZub0Jo7D6KXochlSHOszugMnWPT5ai88w26b50K781opmqO61TfLLbG3M9nHst2dCPtIMBgCJtt7A3L9KwiIekIi/6LlCTb5P3DBYOT9ng8hBZg57rQBFzomQ4KQs+d2BZm0MSuS2/EYDkp0w6H/RhjkmAv2L5PSNhUaC/otyJTR799DPwjybSSRQoC57yGNg83sLo2iZb1lnkzEJlcMmIOYAsBagvCX7OvwRgSpGzSlRTeIyDN9POafHNzLC5hnXy02sXKz2tith+LC1MnP4o0NYLjsI32cmifVgu3R5ZC4gh2ZoTVIXF58+4CASHdZPyRGpx+IirrYyCsWl0zTp9+fQXX4YO9gyrwXU9tn5nn+rKR+A88frMaIsCbdZScowGnIIsN0SiQH5S9YZNQqQKh7EvRtYfmDBPjGHz3j18irLeO/CI8Do7IxJwnTK7+1jLeZR/Dtss3hzxePjczGxDD+7U5sJNRjFgaBnXQibEq58oVm0qr+k/IPCaFw18BSEMvMmR9DLFGdVfbQFZuCLLgEX5EFJvbq6KjkzmGaq//x0waDgKShDipI5x/WG1bjKZlliJkPGehKZ1eG6fJyWMEE
 ooZb2bmq
 4sJFsBs1ph5zV7d39JLLbHQRIYRsAZmCQpp5+NgmnX8L9v+bqBEpLlfX40iVXloLE++0ndsovs2eC0nGlVBOVKbFEzrY5I2ImtpvFp/0A3mC0iHsNhcTxB0lXxtuBse8Z0qyqc8+WoQNFOHaHYd+G7o+nC2pgvPAavvcYdCIlJLbTy/vU9FlY9yggYiuq8arb3hsGn3iIh4Fs/Vwvzo3tp3/z8qepMx4c6xrGK8vDK2wCILkyQOVuYOZr0AHJTEvmq7uF3/ZWC2kwU6Wq779lyGnAbxZdvPXP+YjajOtBgPAN7TmrFeUmmGEdP4KrIHKE9VC07v4P0iSD60wJgCtgCN0VuJgZ11ErI/nwqubeR9HLxSL0cxpV4Ct5UlKbbzIF7us6bgdGMYtysE0Y6PDLlbjNiA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

No feature change, just prepare for removal of PG_referenced.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 2fd62d02a83a..a3200020b9c2 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -901,7 +901,7 @@ static enum folio_references folio_check_references(struct folio *folio,
 		return folio_promote_lru_refs(folio) ? FOLIOREF_ACTIVATE : FOLIOREF_KEEP;
 	}
 
-	referenced_folio = folio_test_clear_referenced(folio);
+	referenced_folio = folio_test_clear_referenced_bit(folio);
 
 	if (referenced_ptes) {
 		/*
@@ -918,7 +918,7 @@ static enum folio_references folio_check_references(struct folio *folio,
 		 * so that recently deactivated but used folios are
 		 * quickly recovered.
 		 */
-		folio_set_referenced(folio);
+		folio_mark_referenced_by_bit(folio);
 
 		if (referenced_folio || referenced_ptes > 1)
 			return FOLIOREF_ACTIVATE;

-- 
2.54.0



