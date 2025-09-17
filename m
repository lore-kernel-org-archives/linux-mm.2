Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87856CAC598
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 06:38:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D00908E000E; Wed, 17 Sep 2025 02:38:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD6F68E0001; Wed, 17 Sep 2025 02:38:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C15808E000E; Wed, 17 Sep 2025 02:38:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B01868E0001
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 02:38:23 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 85D7AC0402
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 06:38:23 +0000 (UTC)
X-FDA: 83897788086.07.0131C2C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 30B771A000C
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 06:38:22 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IuQW4qLP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758091102; a=rsa-sha256;
	cv=none;
	b=vnzhJkJAW58aRSFjYZso99o08N2w6WCTGddhs0oCrP4upnrdIcP+NUUNmik9tjBN0LtGA/
	8cB4iEgLUtu2Q7TLeblCzYA3XgQ7yoya8Un+c+GE+mWGltRZNb/fectrbZv/mlWk2p57bA
	dfqE3dni9oDgxAs5139vN98tAlHgmPk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IuQW4qLP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758091102;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=MVI3HAtab8kNZWveLBryTVR4KMrizuFaCRKQXr1wpU8=;
	b=rsFFvJyXzpbEk1FbR2vZxRTBvD8KgKy1N35qNw1dPH+hB0Wlc4v2DEYRzTfoauIH/UJYDT
	Si6gpJzENWSvV2UqG5pAFKxqgLJ0fusrtddRscdeFyhBZ8pTzDgNvF0DcOisFktE6KW88k
	XMqXf5ftoAh7+aNBCQPdLWoI19afHo8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4DB69601DA;
	Wed, 17 Sep 2025 06:38:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B8E9C4CEF0;
	Wed, 17 Sep 2025 06:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758091101;
	bh=g4jg0vl01ohbktl2H6dnucsiLrW8s2K5DSNeN3Lf91U=;
	h=From:To:Cc:Subject:Date:From;
	b=IuQW4qLPsFkRszg2kSSi5NdGwbaBG49bGgFUl/r7P/Ps3YoEmJV2NTNpA7d7BWuDh
	 TIlwRuNUD9CRYG6/EboCCHFz98RwDmn9mUsgKKI4DTDks4O5I5Uj3EQxqTVD1MvoyG
	 BuynuVeox5/msXJbB5HXx5M52uroNNBIw39jpTKLA92yriAJ/PTScqGZ7yIEa8dEq2
	 l6djHoCt13YPfKrU0CaKGbyW37/Hfd93Lm1pHC6ZctsIH64zPau2SPK0ZUE7BAAxb+
	 GuKt1MKRNJ0bJQADM2B5TpfzAE3toWwRtBCWkcbVcqOvzKAcyHpBIRM+KROjlMELOj
	 70nQzGLona92Q==
From: Leon Romanovsky <leon@kernel.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	kasan-dev@googlegroups.com,
	kernel test robot <lkp@intel.com>,
	linux-mm@kvack.org
Subject: [PATCH] kmsan: fix missed kmsan_handle_dma() signature conversion
Date: Wed, 17 Sep 2025 09:37:36 +0300
Message-ID: <4b2d7d0175b30177733bbbd42bf979d77eb73c29.1758090947.git.leon@kernel.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 30B771A000C
X-Stat-Signature: hsafgejwhoi673cuticnsp6hozjbqmyn
X-Rspam-User: 
X-HE-Tag: 1758091102-435035
X-HE-Meta: U2FsdGVkX1/aTXIJtiI/Wom6UZVelAxxD20wKIBtldaYzYF+Dzb8Zg+reAwhLolpcVPX5XIOkNIUEJ+2M0iBYqbzlKC5VDKL3ob7lxEkHNdCTNy+vMVXSTVDMGQ2I1VxluoCzKK77X1Jm4ESwjXnGAdPbGIv+Cs4v70xU1a65RzFoIG/t8YfiF9rvWFzgbYJbt5cBV3yx+IrB+q6xY5naYX1SfcHMruL48gVluh9e/7xtZaKBCqfbsXabqUqqeXPFfdiYzsasSmuLQVGEvBjHvev8f2gDV96EpU7Go1/agw3MZT7gdwtL+zEeH0P2ymIg+xGfPlVlsaJlzH3wsy8w9wISa58I1zgxoYTu34FCHspwWHdoKTpqxA2eXkrwTnEdBWdK0fIcSN/nPuC940kLRb1WD7ZLpEl+Ea5jC4BlR2tl8DbHP1UXUMtJ2GBZkqlFXcIeKGpHPZlDw/OFRnBI6C3kVipHzAEfAzzy1UP1hIVMBYw8utYVpUurK7LMPOhDZYpra8407DAfLAsAAiCdcpPal1kewYzvlUfzX+geR1oefQcdj2QVzY+gYeqDEfQ2hMmnQT9hljU3gWZOken5tP5E0+UQFJrorwI7Uu7zO+Y5IG5p5Xpvhv089O4hAtd2EJdcUpm9hrqd9sxsejkMk2By7CISfehE5/ZveiUabG/6prrshvZjH8V4d9313r6cQ1XBPiDNcEc3pt6ACtPBrwPiTZCU6f9AqC+Obks13oHQMX7V5hw9li9xehsPnXZGewRB5yN6sODguKPzX2RNOhn7fJ8sxm2lJFPf4zbXTLp8CRqEBzCF6aOF4rqGBtVgFzVKYDGpgEW0+qrXF+UWjepdMrP5mjvM5vfQoEBoUU+/Gi4klT9Ot3vV9Yiy86dUWej2wiDhBT6lRo+P0oFzBZn2lrkgUOHHZ7/K/JPB4YpqJ2396Xl+n+TwYye8zrGUxI+miXB+nVkuFL7jSV
 uvL1uVDA
 tpcpF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Leon Romanovsky <leonro@nvidia.com>

kmsan_handle_dma_sg() has call to kmsan_handle_dma() function which was
missed during conversion to physical addresses. Update that caller too
and fix the following compilation error:

mm/kmsan/hooks.c:372:6: error: too many arguments to function call, expected 3, have 4
  371 |                 kmsan_handle_dma(sg_page(item), item->offset, item->length,
      |                 ~~~~~~~~~~~~~~~~
  372 |                                  dir);
      |                                  ^~~
mm/kmsan/hooks.c:362:19: note: 'kmsan_handle_dma' declared here
  362 | EXPORT_SYMBOL_GPL(kmsan_handle_dma);

Fixes: 6eb1e769b2c1 ("kmsan: convert kmsan_handle_dma to use physical addresses")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202509170638.AMGNCMEE-lkp@intel.com/
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 mm/kmsan/hooks.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/kmsan/hooks.c b/mm/kmsan/hooks.c
index fa9475e5ec4e9..90bee565b9bc2 100644
--- a/mm/kmsan/hooks.c
+++ b/mm/kmsan/hooks.c
@@ -368,8 +368,7 @@ void kmsan_handle_dma_sg(struct scatterlist *sg, int nents,
 	int i;
 
 	for_each_sg(sg, item, nents, i)
-		kmsan_handle_dma(sg_page(item), item->offset, item->length,
-				 dir);
+		kmsan_handle_dma(sg_phys(item), item->length, dir);
 }
 
 /* Functions from kmsan-checks.h follow. */
-- 
2.51.0


