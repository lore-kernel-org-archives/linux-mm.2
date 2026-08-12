Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84B71C5AD5A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 12:19:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8549C6B0126; Wed, 12 Aug 2026 08:19:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82E686B012A; Wed, 12 Aug 2026 08:19:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 768E26B012C; Wed, 12 Aug 2026 08:19:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4EF3E6B0126
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 08:19:07 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CB7E914036C
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 12:19:06 +0000 (UTC)
X-FDA: 85092521892.21.005F6E7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3F49140007
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 12:19:05 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=njo3WFSy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786537145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3bXsQJXJBgnmO/j5UVCnEEv0tpGrhoZfdxf5g4cVqXw=;
	b=Pba3sM4t2cEidQkpaH39N8+2NUIpVZmQ8rYNdIBa7+XhUweTTnwglxOF9yts+oJG4F1NKG
	amRuLQZsRLf3uJ3I2hBlJcUF25gpdKctq7qEBfh19F6FE0soGj9TjV8P9V5Dyzv/I4aTLX
	eK2nwxl3s91jnmAOS7n8O+uPFwmCpCI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=njo3WFSy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786537145;
	b=r0b2NHwx/X5hUz2RifN4aud7nR+GTtz3zP7xbo1fzUB0G2IjyORsOIIKyPjTs/3BNfT62c
	3jUIFmEpX2IIm+5rf05/Dh84tIkdVSOzsUFcHkTM7BiNRdWAn8uWyXbRMNjdo2yiwoPKjq
	LXDd46YSHXPrPrwrAgtlGwVHbbTUGSE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8348941917;
	Wed, 12 Aug 2026 12:19:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDE751F000E9;
	Wed, 12 Aug 2026 12:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786537144;
	bh=3bXsQJXJBgnmO/j5UVCnEEv0tpGrhoZfdxf5g4cVqXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=njo3WFSyGDaScgvd6IJHBjqnoSSXc8eHsmqYVtIT+z+kGiY32zHCIHLG1dZdKTzkf
	 WsZF140sZ7HXeZZVQtvkV1HLI/EkPJ83p2zLnENNBOMKYNJoq55pjYH7TDSVkmlZlj
	 Tl0wAonC52TwGwAIy/4hFNR0O554QLM2aGdnQcYe81OocBi8AUfRlATAaXVym5qxFs
	 OgaCK6kKvE4kxmUDINcInx3KnAkZF79yEGzDsgTzFDKJhmUlJkdQShEcuwmFoGe0Bm
	 BM8Ry2v+SmHs/ttJbHE6zToz9DjNEnXqjJ4Ze8a8gAp0gG0om5TAHkDywVs5qapZ3X
	 YKB018bfePxyw==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: axelrasmussen@google.com,
	chenridong@xiaomi.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	kasong@tencent.com,
	lianux.mm@gmail.com,
	linux-kernel@vger.kernel.org,
	ljs@kernel.org,
	lyugaofei@xiaomi.com,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	stevensd@chromium.org,
	wangzicheng@honor.com,
	weixugc@google.com,
	yuanchu@google.com,
	zhangbo56@xiaomi.com,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [RFC PATCH v4 15/16] mm/mglru: dynamically scale aging threshold in lru_gen_imbalanced()
Date: Wed, 12 Aug 2026 20:16:57 +0800
Message-Id: <20260812121658.69965-16-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260812121658.69965-1-baohua@kernel.org>
References: <20260812121658.69965-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: cg94bixppip6zjxftjwysh8urcwddwub
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3F49140007
X-HE-Tag: 1786537145-241365
X-HE-Meta: U2FsdGVkX18b6lhThfzEVtaiuFerMCf8zY2QoVHg8fKHY2rv0VeyETikFXqTjs59Xaxqa5IvdtIXYPKb5v4QeNNfcKWJJfs8smvX4CSvuc4r/KAPibA75J7+ZVA87xvB0SGvCHGB4AI6QlukCB8Fp4Sbhz3+TvWLNz/RN1estClqVUeWYYoUZcq9VqK3U6epUXgW9QvQ111ez5ik94bly8hI/Xfp7qjtA7rrYgAQPFZI3ZjGIjC3jBlrJxIlLPTL2UMF2n9Iunolc0XzZiTK7MHC7LbFZtrwER8kDbKpAv0s1WWTQzyZcJS4vOVWWaUVj6+uuMkQ8H2gyFDqhseOnBGXAb4yKLljZQuRx62Pgez4XyW3mJxFW8qddTKAgNnVqnWxsvgxKNuf8Oya11HGIst5IzNYFYA+k+FWMPA2p2i/tfzVmg3k0MwX/RsTue1JfyByfpI7MNibGeYqGfCgkhuanbYPVx/Gb9JaO8aXTB4qVIHZussV8vSpoUt+6E8eGiC+OT1+ZmYXqijztubtPk+v7d3cwf2TQ7lTn2dksc14AkFU1RRDOP/ofaeiWe2yjYuFWo5eDztSjGImyc59lRwpe5PYOpdL5eTSC7qU1r0aS6Sby19xLh+6k+JNcVbVWZ+vns9NT4NT/Pf6avsbrooHPeBkTaLH05yJMNCOdh3JHI0olEEr4kzm87j2dUZhCt7Q+lKkzVylL3F7a51ldc7wEsDZIPWwArbMUChvzPkGXKTsBN60Y9PDFuO/8DLm7B7SMqyHw37+ots7LIfiy0faGQPR8i7/Bfma7oH+1lfn8RKooneMANiCmmdowVA9wjwVP1mQbmk4Z7HSiqRKu/sXAA/VuryOHM/j7dPX0o5YhV9QVUn972eY9mITeuTQrEyI82Aopm7184+vwD4jhrwK2g5o9gRfYJe3KwgrSdUR6qf3pd7XxwJQ74lUCPuheOHsTNI6c+ofslc0Vjw
 SokLHN+7
 nNn1fZFemMMp8c1fSJf8cTDvM//kJGj3p2Onv3bpfV9xi4tAOEGqYhEqOF6T2MTjhhKgO2SNosx6rzkETaXiuN7iaA0wdz+Xzpg+ZyNepf/7deov0eUpkTTD5DvPMEzE/jSJ2zh/cZ1ysQG/v6R5x1qcXbPJagB5Hk7CMIibCj2FrNFiWi0PXb1H+CNIxLTTg59oJnmwUwZL9bnARUZPu26tR3g+RBtagLRfvHbOyjvUr86nFLYjyG/s3qMK48MUa4Gafn+kr82OB20Gh7ACAx9S5vC+WPWfjrNHMUZ6Fe1XUB7TUTMNgYSmiVa977sCG5R4DyI5y25xPfWRZD5rYR7sYzxz2OGAIwBA8X35/JNE+czKaOXt4CRPz8ux54uamtFarvrGJLDzBrvP2Vibf5DdOEseOPg9p8Sqo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, lru_gen_imbalanced() uses a fixed threshold (MAX_NR_GENS)
to determine whether the young-to-old folio ratio warrants aging the
preferred LRU type.

This fixed threshold may not scale well with large memory systems.
Borrow the adaptive ratio calculation from inactive_is_low() by
scaling the threshold with the square root of the memory size in GB.

Suggested-by: Zicheng Wang <wangzicheng@honor.com>
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/vmscan.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index d6fac5b91ac1..c0350a8b61d1 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -5105,6 +5105,7 @@ static bool lru_gen_imbalanced(struct lruvec *lruvec, unsigned long max_seq,
 {
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	unsigned long young = 0, old = 0, lag = 0;
+	unsigned long inactive_ratio, gb;
 	DEFINE_MIN_SEQ(lruvec);
 
 	/* we still have enough generations to reclaim */
@@ -5127,7 +5128,13 @@ static bool lru_gen_imbalanced(struct lruvec *lruvec, unsigned long max_seq,
 	if (min_seq[!type] + MAX_NR_GENS == max_seq + 1)
 		lag += lruvec_gen_size(lrugen, !type, min_seq[!type]);
 
-	return young > old * MAX_NR_GENS && (lag < MAX_LRU_BATCH ||
+	/*
+	 * Borrow the adaptive ratio from inactive_is_low(), and scale
+	 * it by sqrt(MAX_NR_GENS) to make aging less aggressive
+	 */
+	gb = (young + old) >> (30 - PAGE_SHIFT);
+	inactive_ratio = gb ? int_sqrt(10 * gb * MAX_NR_GENS) : MAX_NR_GENS;
+	return young > old * inactive_ratio && (lag < MAX_LRU_BATCH ||
 	       (is_extreme_swappiness(swappiness) && sc->priority > 2));
 }
 
-- 
2.34.1


