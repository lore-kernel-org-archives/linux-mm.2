Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B3BFCD343F
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 03:54:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C4496B0092; Wed, 20 May 2026 23:54:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 954726B0093; Wed, 20 May 2026 23:54:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C7FA6B0095; Wed, 20 May 2026 23:54:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6351B6B0093
	for <linux-mm@kvack.org>; Wed, 20 May 2026 23:54:03 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1C43A1204C4
	for <linux-mm@kvack.org>; Thu, 21 May 2026 03:54:03 +0000 (UTC)
X-FDA: 84790058766.04.8ADFBEF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8ADBA160006
	for <linux-mm@kvack.org>; Thu, 21 May 2026 03:54:01 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dlwjjmAN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779335641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CRNoWJlEPylYeAv7EKMrmhsVza1n4tj76p/bqvx4fJA=;
	b=Wh7xx5OkxztHug2X33mLhUpRWJkUyfbea5St1oC6ZZiLQNHbdQqUH1OmGgLlskYnC3Cwwh
	VmnpJiUKfdw84zlH1aOAxXdKYOIiwzWLRzQJDnp4+ozLue+j0WBdFMI0QrGlGHosPloflf
	4qaDr2heEa5mCr8itVYaH5Gxt9YIXiQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779335641; a=rsa-sha256;
	cv=none;
	b=qtiFnYerps1ff2ImdRDa2Z8gf5+hV+Pt6joiB0QP0wRW9ft1ypjOm/IV3YciUJNIxaeE0q
	B9dEF1sH1LPXKAyfRhDq75PrkJG/fedWeDB/8stowz4OgTwgxOeo9TJ0HTOsn8NyX9bTKN
	L1pkxe6lewZAlwVeAo+ieSRubJYwCNM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dlwjjmAN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1C3E5600FF
	for <linux-mm@kvack.org>; Thu, 21 May 2026 03:54:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1E561F00A3B;
	Thu, 21 May 2026 03:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779335640;
	bh=CRNoWJlEPylYeAv7EKMrmhsVza1n4tj76p/bqvx4fJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dlwjjmAN5exUXxKzSr7aztzw1rqe/edAluNaa+H+ezpC15TEu0GqGdqUy8XYKqgdP
	 PZUYAzbZDo7IdEabFTcFJyZJUbMKynuFtEsMOAnPn1Q1qqiggl8cVHjYYZlserVIyK
	 OZRkOKRbDTAarYHDj7f5HANnhoigVurCbNnMSVB68inIcJmFNiykQ50AedJFDPTKBX
	 3v7amtV5PxRbKqS7AJrVF/pRDr9GA3z/X5indIio/MQ10oqWYACopnjaflhWau2ctR
	 ZkS4sZ44xiL0P2t//jcELeaDmjsB7o3n0FWfJA1+BSnEfkYnMTGV5ht8dj7/3AQiWA
	 lslVsudX3oU8Q==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 03/14] samples/damon/mtier: replace damon_add_region() with damon_set_regions()
Date: Wed, 20 May 2026 20:53:37 -0700
Message-ID: <20260521035349.87565-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260521035349.87565-1-sj@kernel.org>
References: <20260521035349.87565-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 8ADBA160006
X-Rspamd-Server: rspam04
X-Stat-Signature: iy5eqotenc77e34o5soba8cbkf3fhgs9
X-HE-Tag: 1779335641-952795
X-HE-Meta: U2FsdGVkX19MfXtGXF/lxRMGh53YtyQcsZ/JUKzTp+SBSohUduq7jKohVgwsY3nkouxthpHEJy6HvtKyhbVsmc/nvIuhZNFxDOPqc0dwAUPaob2cO7qJmVmWT0w3xUOGGS1nlsjasP1RBcKmwRSn8I3/1rONXzihgCIfDo8NmFFvxlDUTGAgzZ2aJTitWPz2s8U9oheqmOQgIjd9zeMRzTA6OHlhvlv2fepbjFg+7ex7ujz+ILutmoF2aemH2zxH4li/kAktkQuB5gG9fKrzGtxeV3C9DfYplIizcK4cXp/9z2U6QYzX39/6RcTfJqM0ABhL0nTRjgMwKQVr99iQg6Ti0v44B1iAfgpYpxFMGKtOl1xXPc67gmkGf7Hjntk622vdPMsdiAEg64pLLhkKgo5LFjJUaQ5ITWZzBf88TjfcSKLhwOwOscXOyM4p8u8DVwpKt3u8Wys4EfzNyULVBM/zHNbodGJ5Zikob8ZBeKCgByiQNkb/geEq8eOII2xVtaKspiVYHzemDcMq8EMM2hcsqNcMvoIZ583UagfNxtvzSt0jndA7dbCSfsSSSqw8kkmiMgsR35tpfQIcNiT5lPENI+HNMftsAf+HtRijrG2hIkAMQ8gVQ8d2TNgOcTyPbNUHOb+CFcpWThPsDOuppfgIIihX4eXCqo/1OjzH46wGTgNsarNm8uBSE64DPNNV5HihUxF+99y7ycXwLZnoukcEFdZzNYYPauBLMrjw84u3CBgkv0J2EAyQIHNGN5BVvSyH2itY9RXf6tjlT7C2Ra8KLrS39xFvV5GFfSx39cuYS8KUfUlJ72EPukIq0LuyioiMEwZh1SK4cyOXLsYo2lm4sjdm05+g0IGfvATf9q4jCRKLIm6YqJx2tN0QDxBWbBPWmaJsohc049ZZM2+jm7L2tJU4AeHsxWA5nbrJDYGajZACXeCHkPo4Mdp2HCw0pkSPiQYbBbM3pJh6sNN
 xAzUTw0k
 1HPLWqW264tN4ebSoUXx4FB4vwyQD+4axSgVJCsxS4J7hjduWrwDEEfGOn9Rl/BGJ7aOodP/ncwk+L9EwyUXdD15NZpMruvaZ61O5bQm07Xop2MrDeBW4M52MHWp0RcUWZgWn4Yws2OFl7HkyHlzdcZv8HizkY8KJzjMyutjBdVMlXloCKik+HOLiImnMvCC45sggYn/R/1ya/E2BhcNeTOWXPjro1R1Xr7O8F2xTWoxeiTPrYBMCct56zASJ3lCZ570k4LSVI8NdddiGnqHG6LIQwI672PgCmMpETQXIoo9bmr9s1geTy00j/DW6O9UCnC5NAwOX1BcfdSNeWoeswhlv8w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mtier DAMON sample module and DAMON virtual address operation set
(vaddr) unit tests are using damon_add_region() for setup of DAMON
monitoring target region boundaries setup.  But, damon_set_regions() is
designed for exactly the purpose.  All other DAMON API callers use the
function for the purpose.  Replace damon_add_region() usage in mtier
sample module with damon_set_regions(), for unifying the use case and
reducing the maintenance cost.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 samples/damon/mtier.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/samples/damon/mtier.c b/samples/damon/mtier.c
index 775838a23d935..eb1143de8df17 100644
--- a/samples/damon/mtier.c
+++ b/samples/damon/mtier.c
@@ -75,11 +75,11 @@ static struct damon_ctx *damon_sample_mtier_build_ctx(bool promote)
 	struct damon_ctx *ctx;
 	struct damon_attrs attrs;
 	struct damon_target *target;
-	struct damon_region *region;
 	struct damos *scheme;
 	struct damos_quota_goal *quota_goal;
 	struct damos_filter *filter;
 	struct region_range addr;
+	struct damon_addr_range range;
 	int ret;
 
 	ctx = damon_new_ctx();
@@ -120,10 +120,12 @@ static struct damon_ctx *damon_sample_mtier_build_ctx(bool promote)
 		addr.end = promote ? node1_end_addr : node0_end_addr;
 	}
 
-	region = damon_new_region(addr.start, addr.end);
-	if (!region)
+	range.start = addr.start;
+	range.end = addr.end;
+
+	ret = damon_set_regions(target, &range, 1, DAMON_MIN_REGION_SZ);
+	if (ret)
 		goto free_out;
-	damon_add_region(region, target);
 
 	scheme = damon_new_scheme(
 			/* access pattern */
-- 
2.47.3

