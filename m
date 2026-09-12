Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD914C88E53
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 20:08:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14BD06B00BD; Sat, 12 Sep 2026 16:08:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2C046B00BA; Sat, 12 Sep 2026 16:08:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D08C26B00B8; Sat, 12 Sep 2026 16:08:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 852E16B00BA
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 16:08:27 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C3B94140525
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 20:08:26 +0000 (UTC)
X-FDA: 85206197412.14.CD72B04
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3609E180006
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 20:08:25 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mXJjU9Xu;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789243705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3HzbqHqjQymjaA7BsBDU1/xd02tq5ixlWdlSiDNtUtY=;
	b=j8fHoeXydBXal56j+Ot5dKK8Ps8PuJhtNhRJAJNcQR9i/PWHz/UYHJkdM4ABbXh5Fwvmqp
	ipL35rgdj/874wIzmO/0BvZo9aVJa/z/Ch751d3CTt2rARqIho4nWt/2t/IpvA35ww2Wqk
	/fnkvnjsC6jwv0vNn7geQUdm26u1CRY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mXJjU9Xu;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789243705;
	b=tibO2nXQALUu/ESeP5q0+Qzn5p8xh9K37Y1tRX6606e297PPNnAMGgzfdAgs38FXtPuZmE
	y3zRDPTrN2T9APB0YFhFQ4xR6J6c39LixbXrhqdriOpV9V5EbjFHwYBUVqkNfRgOmy3FaV
	4aa6nPdDD4vYPh/VaIeMwiVh9vjXQs8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C2BB560239;
	Sat, 12 Sep 2026 20:08:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 533011F00893;
	Sat, 12 Sep 2026 20:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789243704;
	bh=3HzbqHqjQymjaA7BsBDU1/xd02tq5ixlWdlSiDNtUtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mXJjU9XusbyGGP+L97Elho25w2Vif+86AiBhcfys3oRgA/4vaaPbrlscSM1GfVy/u
	 2NiL8feZotARccyzksZQN1i89yIAXTqCHbMDiD7wJJaMVIdzJSL5pVkN1k4hlpaeV5
	 bwpy1EJr7gJl8GQ+5VWyNN+czryKWySw2hcy3BMXhe+Qg0vLapXFHqovUWulPApluT
	 FmZzCxX4SaU3NIAG/g5lgOUhZzGVSaPrE3tISnWSXacVlU764YIrr+Kpk2pFjZxFJM
	 vtud5+SvbblJdVrepIpBCZj8+ScGtxf4NuBcVNjU1PwEt20BAEo4vf6DgOVf1hO3y5
	 HqZLykgMnvgoA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 6/9] mm/damon/paddr: remove pa parameter from damon_pa_filter_pass()
Date: Sat, 12 Sep 2026 13:08:07 -0700
Message-ID: <20260912200814.145612-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260912200814.145612-1-sj@kernel.org>
References: <20260912200814.145612-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3609E180006
X-Stat-Signature: zx5sea6wc5jkr88xrns8xugsei49ypd5
X-Rspam-User: 
X-HE-Tag: 1789243705-680188
X-HE-Meta: U2FsdGVkX18XDYWDY+YICTCHQ0dYN/PbwEcpkKuRzvONFkITF8f/rjn3grPI0htaSoLRBTfa5M40uRf8dqPfbv817Ti3M39fQiumIc1Wmp+1+w5YkcdSqi0d7Bv/GdDOtx2sDqTsYfJBp2QvOPPR10qNutLgC+Z+TsZuBhDUG22z+6wIAqTaCK3Jr9TeJNm+nIyH2saAYbqjJpwJDlQQQSUm7aqTnrl+66tcahH3rnUvei6aPpHBgECQI48gFeKTepPo8ts6//NVpHH1hgYFLhlxxE0RPv6AlCIiRzjch2dYze93ZzxVdwqbO0D3ds2I7p1eI9BKpubm/kTuKeDfiR1KEsIv+Tzsr9xVlne7WZRI8zjIFTfYCmMf3ONbMaA68+tIV5lf0GikanSIQyuAhe+zrF3W3FNwdCF8XRgczkPHINZITPgHD32OBUh1x+fYgIec+qUVnJSkZiKQ4vzJaNs3ZRCm8iA/34OW6UF7uXLsgTAD8lG6yu4EwtuugheuUCi7fqdM3dU6dpSl+uOL4R1irHYBkGQjMAPjxRNw4q1+COThvSLoGRvQF/YHgx+DJMb1D9IDI4dgJ9jwxnGeJul/ZK7XYzuZ3MY3PsvTusYDGiQBD7ks96Ad9bYSKOohc7YD3KhBrWSVhN51a9ClVUfN49TbsoYeeB0dnC70Bn1BJXeiiQi/P/8axfHcFTm3rp28gSrCPiOO9cp0iS+1ot22f85SnovV1UzgOcxWPGq5rsH8aXSCmdQWh87ow1Fka74omd4TSqhtNE4p5xvgtI+1v98gq/pUSnFD1JdTOUl7WQfmH/vENhazU3JBVg4srHf63lLNLqoyouEPuRpJkQGmgPZxE/YfE3hs83ClW1Ts0z6BecyeBN26KLPGh0Eq2fOBaoBTo/c6r0GBn6KNagM/fLjE9grvPgJuRE1Pm3fGqNTNMhi8bSnq0pCXWFrbg9VilUgjM67/MdeIvSE
 aCkYnR6l
 2oa26TzUofVj4upBpobUkR7tszc9By5SVB+2Vdt61x3w4Tu+t+A7zZORcSG2uzI54WM4tCGtTleD3BlLnCNV3boivVtVm13w4eDCSBJzYeaZl1i9ZaFlWygry/xGOpoFUNRhAnN1idbO16UeDMqtbK9XBBzQxnp4t9RwTxmpG54RWTtDGXncP6gfbyPyhfuH4qbtpsU527abuJdbrCZEQ0zsgdTboBo9ywH787hYNmJJtco6YBe9Jnuzh2VsRZMKSQBuqBo8xnLBstRAhvSPy0Mwouw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_pa_filter_pass() receives the 'pa' parameter, but doesn't use it.
Remove the parameter from the function signature.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/paddr.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 5abfabaa339e0..2cfdc356b4157 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -163,8 +163,7 @@ static bool damon_pa_filter_match(struct damon_filter *filter,
 	return matched == filter->matching;
 }
 
-static bool damon_pa_filter_pass(phys_addr_t pa, struct folio *folio,
-		struct damon_probe *p)
+static bool damon_pa_filter_pass(struct folio *folio, struct damon_probe *p)
 {
 	struct damon_filter *f;
 	bool pass = true;
@@ -200,7 +199,7 @@ static unsigned int damon_pa_apply_probes(struct damon_ctx *ctx,
 					ctx->addr_unit);
 			folio = damon_get_folio(PHYS_PFN(pa));
 			damon_for_each_probe(p, ctx) {
-				if (damon_pa_filter_pass(pa, folio, p))
+				if (damon_pa_filter_pass(folio, p))
 					r->probe_hits[i]++;
 				i++;
 			}
-- 
2.47.3

