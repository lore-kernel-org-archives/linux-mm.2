Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36755C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 14:06:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 042406B0092; Thu,  9 Jul 2026 10:06:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F31836B0098; Thu,  9 Jul 2026 10:06:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5E236B009B; Thu,  9 Jul 2026 10:06:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AE6DF6B0092
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 10:06:08 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3DE108BE9D
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:06:08 +0000 (UTC)
X-FDA: 84969412416.29.084C3F0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9BF481A0004
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:06:06 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cVhAT7hU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783605966;
	b=FFwtvlc5fN6zbrHVGEwbVRUrTA4ztA5acnVeVDyS8j10tDg8SS+5QMOYgJkoo7+E65I8y8
	H5VlUirsT2Oq7AAfawF5IzB7Qgewk1eTGIKqcDoHlecV1P4f3h4vILAvM5Cd3uqaEeeaQD
	KazSOrpjC5WyxK3+3w2jcDx0dCETrW0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cVhAT7hU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783605966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HWM9ulbAfG9bosKr1Xo0BbZMoQtsvPUcnEqaGbAY52s=;
	b=xZ0UNob9cGeIJ2Yru0VvnRzagi3GMKYL1UecFwxcMcN9ULk51QsNvv8SgbcrWahenTlXrT
	/tI7tIr9yeFk28AOnhkokvFWR9TRJ1a0UpkxPj0ppudw4Rfdt1FlQ/Ci8ol6j6Np21DAmj
	FxR2gahLIi46zMnTo6meSMDDPscjejM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3545D61384;
	Thu,  9 Jul 2026 14:06:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE0631F00AC4;
	Thu,  9 Jul 2026 14:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783605965;
	bh=HWM9ulbAfG9bosKr1Xo0BbZMoQtsvPUcnEqaGbAY52s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cVhAT7hUdkosfNwbP8UnavLeo0F9t+WLJHfUYu0JxwhIRPAv5fwgn0iRcsJFWlo6e
	 rSe1Ehge/90Sw1ZgkeTwMy/oTwetyRP1yM+J3YobvZdjpqzvQB8zw+hJx/IVLi/Jx7
	 KKyBc1gp2Mg8p+uVuToQKUoJ5aPafYWl1lCWCRF+/J+C/bCnwR6IAbGCf4qV23Za/g
	 42KnUlrbKnxkUqqAeMOUAnpzC8cyZ8iKdpyC1eNgQcxi+/jAXgXg1M1kGJOC5OUFYU
	 d0B8l6fM12hgkvgltNY3Fi71nOLtsU+yJwbY38lzLGeyQTnmvZ83vAVbXxQLmgRIs6
	 hIOD2qxSwJEGQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 06/19] mm/damon/paddr: respect return_max_wsum
Date: Thu,  9 Jul 2026 07:05:44 -0700
Message-ID: <20260709140600.90950-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260709140600.90950-1-sj@kernel.org>
References: <20260709140600.90950-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9BF481A0004
X-Rspam-User: 
X-Stat-Signature: oeq7m3tpwgr7x7ofhgg6zb1c3qbx83oe
X-Rspamd-Server: rspam03
X-HE-Tag: 1783605966-280505
X-HE-Meta: U2FsdGVkX1+YcSQs0JF+iSOq/5iyhKBawqZvXZyzpXhDI1CFeeGJhGvkvNLoEu9ct/sjghE8TgSGl6ef671HUZaKTFoxMhNVs3n8Ug0rlEUNPN5uqJP2ff6xAxDAahz6/D8JVZ+Xj5k9YmMzFnlsRNK/Kptw/QYaMvDvA0d5DTuFoq3Y5LUa02ED75lQZfCDteVQPwK4tb0bl3bQDfCQLO2Hgp4Fu/y8kPbXwuVAyz7DNbkhdyvr8UbK2y5H8o35LIxiZK2ztmbcx40bBd25uJ23UOXX+k42Q/PezaskQrJeutiMz9zNNNX+E9pKMHRkWxf+4iDxIGNnDrLZklWSR1ZryvkdFxgqH52W17vHIf+35/jCVmLytNj2lcNnSTceI60M78CAwGNSMKpS3UoeZmsRca1bYvIcLAI9keax58OYZ0BoS8yKUuhKeY9DiS2RD7yL2WtvB5sKvw0AyJCC3wjLLx29dycN4mNzt0cGZcIA40zGnpAu1OaS1357ELE4pXTthPxCKvsVVdRAd7dxF4/+TDhtg53wqE3e78LBBIeWqLr2eFFKrHNf2YAGIdLUuRM8S7u6b9glFviJm9CqALEkVByHJQC4JOtiVC6+wjVLZEy/3B7r80uxfIXVpN4xXLqueN5qIspIaxtDZYq5uCb2VEdlsloHxVcty3u3oWiSiO+5sN0wFaaMVWJpNwQdBI0LOL2MynA15/FV82sbM7ti/TaSoros7RPA+aLB7EKQuKnT7+zI95Yfi9TiSHa7jRsdC2fkrEXMCMRbQJBLbJMIP0F9ToNkNY5i3bHzqB0pYBmab3MjgS/MJgtw7rJDYHFGV0eyaHzzp/BVF+P21suLRkfKx+4kyxQARnUvnyiz0ATFMa+JBN9gLmF9fy7krHqY+rrTSbgh/Zk3vHrMRsZMIn7ECy7edgAraR4qopgeqMxJp5yxSBSiDfK8Bz/u2MD/4XUUCDFkDHc8Tuo
 qGeNRTHD
 3PnSkd+hCF2D6mbP609P6UXYeMjIKMe+oDC8ntV9pv2cBtuPK3si+7r0uML3CaE9pl8lSyo1hrsucTuYT1x2YYZ+litwHp8sDDPawUVtPtBrJ3TxCXRjvD0kvaBxiZ/5Z9ody0Mb2foirrAbdFB6TZM6hCwsX/r+wHS5+ABR4V6l+KBDmiiOyDQ9QkHl1NhziacvhM0XK2cUF5S0vH5QrPhz1dutCH7gu7JItfYvKuXr18e01P/o0UN/M8BrEROYWVhcf7Ntu7yEYAF87n+mSI0CdJQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

apply_probes() ops implementation in DAMON_PADDR is ignoring
return_max_wsum.  Respect it.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/paddr.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 3eba3564a31fc..b85f88a7a38f4 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -172,6 +172,7 @@ static unsigned int damon_pa_apply_probes(struct damon_ctx *ctx,
 	struct damon_target *t;
 	struct damon_region *r;
 	struct damon_probe *p;
+	unsigned int max_wsum = 0;
 
 	damon_for_each_target(t, ctx) {
 		damon_for_each_region(r, t) {
@@ -182,7 +183,6 @@ static unsigned int damon_pa_apply_probes(struct damon_ctx *ctx,
 			if (set_samples)
 				r->sampling_addr = damon_rand(ctx, r->ar.start,
 						r->ar.end);
-
 			pa = damon_pa_phys_addr(r->sampling_addr,
 					ctx->addr_unit);
 			folio = damon_get_folio(PHYS_PFN(pa));
@@ -193,9 +193,12 @@ static unsigned int damon_pa_apply_probes(struct damon_ctx *ctx,
 			}
 			if (folio)
 				folio_put(folio);
+			if (return_max_wsum)
+				max_wsum = max(damon_probe_hits_wsum(r, false,
+							ctx), max_wsum);
 		}
 	}
-	return 0;
+	return max_wsum;
 }
 
 /*
-- 
2.47.3

