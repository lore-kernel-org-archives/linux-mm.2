Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6785C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 14:48:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 977F96B00BF; Wed,  1 Jul 2026 10:48:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9506B6B00C0; Wed,  1 Jul 2026 10:48:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 865D96B00C1; Wed,  1 Jul 2026 10:48:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5F3096B00BF
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 10:48:31 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DE9B1403BF
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 14:48:30 +0000 (UTC)
X-FDA: 84940488780.29.6C49727
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 42B614000B
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 14:48:29 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CfHMA57v;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782917309;
	b=bwFduu8BV2tx6+6hTSpkHq8RMT4LO1xcwmxyi5/aynnAaXJOu8rQmlgplpe68fsjAtSxDA
	LkemCrSpvxw0cq/pChCpYm4zS1MNf475nt8HKf4vMKGHLQUikch6uXpz3xasktKURkFE05
	PM54IMwov4AnhGEb3+LrkrOjM0R3YD0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782917309;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4VafhRbm8rnHMCZpEIBC3NAXIVyFpdQKn/cpt2JTi7U=;
	b=TdVm1br2CWCLDXo79lBOlmVfrZG+T/Ts6hP3E77Q99ZfrNI7UPxRbUywHiT1/wM0p0n2WR
	5TywZNnIfT8Xgug8mEcSx8hPpYV0LvrJYVunu2OrZHbJGpES3XrZeNfreQEUnQlLizcN3Y
	XQqEtWJSDTnmjsxrE6D96Fet2E9d4Kc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CfHMA57v;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8F23043FB0;
	Wed,  1 Jul 2026 14:48:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AAB61F00A3E;
	Wed,  1 Jul 2026 14:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782917308;
	bh=4VafhRbm8rnHMCZpEIBC3NAXIVyFpdQKn/cpt2JTi7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CfHMA57v/es7Bf6Eh48NbQYpsR1IkkJ+j14HygB2KVFBx6o7mM+KtPXG1lZWxmN/U
	 Pf9ZN9c7Q+WV7pcelUlpmQi/cTf/Ywfou7qiOMVwvTkubK3loe8DSiSbxUkhK1X2/S
	 ZAekMOpzQbN3Zs8yVaYlXa2rRmDhcDGtm6h3Jdr4o28FjuaM4hui82zuh4/Ku+mNxB
	 nKiGXJCmjDdIqlxQwQW07DDL/JMlXQqhZRhgvnvxVHMABM6X4yUYUcew8/IbX8DnNn
	 +v0pze6gHtm+vn6PgwLlhAaAs8IyeftrqVHqkg2g2ekt3IcLXmMidl2J3PMf3RO6IW
	 D3e3G/1JnLSRQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 8/8] mm/damon/sysfs: remove region size validation
Date: Wed,  1 Jul 2026 07:48:10 -0700
Message-ID: <20260701144815.113325-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260701144815.113325-1-sj@kernel.org>
References: <20260701144815.113325-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 42B614000B
X-Rspam-User: 
X-Stat-Signature: b8dutd57ha3zmbi8kne68jo96g1fn6yo
X-HE-Tag: 1782917309-872530
X-HE-Meta: U2FsdGVkX18qHkvBamBhVJpNwEOkPsQFt9Vfy3ccZPOVT1xH1Ch4H/U+tG/alXsOX5sAMkRfsjNFJo4q8Kuy+ouZBaP7hx6C7v8t3qmMgkR660ehIQUigDTjRISns0/a6r5xGoOFz1d8r8STLBOWAzoCban0j/Sz7ukX1+qGv7k2VqAJ58e70Gn30ol4yG3PctXFROEUK2cZmSbH6G8oAMVHE4iIVEkd110Ed+fkQ7eKMQbnZUTwLUP8GV9ZmIzPqZDi/Js3Q6M6PkzdGAL2qm48Yt9Ta0AM5qktWnceUC4SgYiLFE6D0LKZh5pQP9P2tM9KzHARA0+hx3fRX+BfmS+XcBKQQf4H5zw6bTAvaokAAzZwt1fOBMK67pw7nNP6xM5LQnQx3YhKy4rTwseGzRosAgS2Le3Xwvg7vnCV2lj0FJORdnGVUbZXXvvSufSbJA01M5woRrEruzGflgm4fOYWLJHii7JOZ/0QgyFWnkkh/x9Unce93fHDXpUTJCI3bxynRjXvqaxohkeioCJW6BAJvUc8ltv3/p7NaRiboz2sX6ZX1kZ9XH7LpQkjYy7MRqNHB8tNFnknvWLVkl/EoHP2yF7stIkl1/vXBYx5dJk+PVcYfE+dsKjB0SciPq6bHHts9O9b7x7LEFIUXeZq1dLhfqYXLTYYymCOsL8O+luHPvjfg8QpTeOHAkpaZnzc/LND2OncJzjQALXJsBatv7UVzmXtUI1SURTCRodNRr3Q0HWU6JpIQSx3vyGYAgn6BYDpi2FZa1ax4tN3HbI2P45tI7Fr33NZK1nkfs9i+QGPrKtxLNKD/8/JyxXJStMMuCY2DxxfIZjoBn8b7+kiFbcix0hvVkrw2ed4ft4kyOFTPbMTstp9CnDGDlHCZyHUwm55g06TCilVy8i46H1JFdVgm7/eBTct1Y3R28zRosip8rFonUhDrBRQsHXcEJktlZdY5PRRqGn49kXLvZk
 P72dlvn/
 /PRQLhmWbfMv1YUr2WJaQLZo+YKSuTVE8PeDhrj4HyaT2z8T/cgoKWBswI33NF+jnlbPoKe8eEpBeOyFrLpzZskyOs0UD1UlGd8aHoZOSRvMWfUjY6h+Bg2w8bYR245TkCtNpitnRoal7P6wihjTSGOFTNHl1QbKV4kdRpjR0OsT3xkzcpSem1Vc68lX4B83refRpTG6pBhEdPcNJwOyqbVhZC+tVETnRkinHpzWv/UV2/9o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON_SYSFS validates user inputs for monitoring target regions to
disallow negative size regions.  DAMON core assumes only positive size
regions, though.  The validation is incomplete.  Fortunately
damon_set_regions(), which is eventually used by DAMON_SYSFS, does the
complete validation.  Remove the incomplete and unnecessary validation.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index e666dddf1feba..b65651498e0d1 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1987,9 +1987,6 @@ static int damon_sysfs_set_regions(struct damon_target *t,
 		struct damon_sysfs_region *sys_region =
 			sysfs_regions->regions_arr[i];
 
-		if (sys_region->ar.start > sys_region->ar.end)
-			goto out;
-
 		ranges[i].start = sys_region->ar.start;
 		ranges[i].end = sys_region->ar.end;
 		if (i == 0)
-- 
2.47.3

