Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 615EDC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 04:09:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 841A76B00B2; Tue, 30 Jun 2026 00:08:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CB576B00B4; Tue, 30 Jun 2026 00:08:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61DD26B00B5; Tue, 30 Jun 2026 00:08:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1D8446B00B2
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 00:08:31 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 74ECF167C54
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 04:08:30 +0000 (UTC)
X-FDA: 84935247180.28.4C5E420
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id E4CAD10000A
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 04:08:28 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="DY/EbHjP";
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782792508;
	b=Z0VfAInkLhrQs/47yoIrOQ3Yp+bSRft/KG430cEH6ftbsPo4kn9xyl+GzYnWJgEnKnWTxZ
	in9mhINI8I1FgKDfvUpSsEPgL4MxoeWmpNq3OhyDSTFdPNKX5YJrtpp5uvMc/LPs8dp/bB
	fU8jJbABoT0OUfvqmN7pzU0T9tF6Sdg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782792508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AeaX6kvkHlHkpOf8DnvsGxy9uMSNxNlGVRxbrbpMKQY=;
	b=UVkTcYi5TjhsYvVLmC62UAtJWcUsdF/cM+4soyLGhOz/F0haNe7MeGjzFM1LVSUlsQaBD/
	2osbJ1VMQIN4g8gsP0i4i3zT3gqBCZZE+S3UQxzcsHthGFRMK9yw/DH9AbR6cvWozYGLHO
	UYSFmqELK06510LXU2O80nFb0MbePAw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="DY/EbHjP";
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8DB6660008;
	Tue, 30 Jun 2026 04:08:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEB5C1F00ACA;
	Tue, 30 Jun 2026 04:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782792508;
	bh=AeaX6kvkHlHkpOf8DnvsGxy9uMSNxNlGVRxbrbpMKQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DY/EbHjPDTE17mIGg1SKxqLW7Sf+TwrTRwaQEHJdTfQ7Gh7cB5+hRBdoFBOpFgtOm
	 TNSE2lbhG5PCMyG7azKi7I2ANSfqVHqMMaz4YifHCCQbrJ2kKDArnRk96CsTLTo4To
	 3pjKH0+V8BQko6xXXGGeun3dTMdByJrIdTSc9YrFM/NwFTtl8yjNK5h81iANSokbUX
	 IdO4AGTJK5WFiolJutdOLGN3/HH0TsIGt2w8Iyy1KOgHbqXJcMpmrWoCXlU51Um2Dm
	 Kl1H3C0XSz3GLc5rVaQWqHK0Nj3hya7mK9C1bX9oRl8jUrfEWkOc+qHzyDIsjRV3p8
	 kVABhTWAHMj2g==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 10/18] mm/damon/core: remove damon_verify_merge_regions_of()
Date: Mon, 29 Jun 2026 21:08:03 -0700
Message-ID: <20260630040812.149729-11-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260630040812.149729-1-sj@kernel.org>
References: <20260630040812.149729-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E4CAD10000A
X-Stat-Signature: 6rjon5hm9sckncc1mj4okh7k3x6orc3t
X-HE-Tag: 1782792508-795808
X-HE-Meta: U2FsdGVkX1+zxwMnzWYX5Spi2I5Pk+YAbnTcm9Xk1ZDnZENd5GkSfZB80jHuXArZMys+9TobKTVwGYIsHHjrB9guntvv2BCXvpFpG0VFZd46XO6ChK/IQb7s/WMmqVb9y0n9gF2L9iNB9/XC/7Gd2/CeSqy0F4Mwq0FPDbqkh7IINyMI7z7Z2LIGDKSJR2QiJREApe0XNRTH72x658CtzFI0DLk40W58qoUVsrSyXKfbWvXSpYTSK4Zj73jU11EfB5npU9CxeRNMluyaTWZv7pIpguBuJn3WeF113KI5QYdafTjUMGl44VZ4k9TsXNL9Gyxfoh2XoMaAc8Th6CtpIjINIiQDD4u79cTI0uS6YGQ+prlWwdn0Bn8wzezAMgz4dx+N48y+yI9QpPxLgSscgx8jIgvKsNqKNUHZWQevwPDNqfiO4GJPXaOAPi5cI1Cw4w+5Qb/3paHQoWSjnR1y0Um37ad8KOrJ66uCk+i2T0ysGW+zP9Nsiwfomu9KE5ToINCEvRvx/osaP00tdoDm0rGo7/4XU06/XufAk4g+4/XY6EIoKnhhpNMCC3SWYflQvovst4WIi204oQGwuFxfaTyeNWFuWwnjfyNEcG6l0Ia8+wgx5qiIaXQoea5JJ+BfDUzsk9DpqukIkqiO+pz1miR81mRyVo59/DoZPNjJBGRn5TJie2yLTfv5s2emg2rT6W0mM6LBmIFt/vKvrBwRTzxFTVM+bQzQtgQd0XmluJfzzoYuXWd7d6tFsMZ1bNJT6QkWhUFbufLKpN/nJ+cad9iJWrVohgcmLFmM2byj5Q0+4bUv2SAM0q9uZyZ10UTX/2KQcIgUpq/brMqADuPduwE4HRnX9QjzuFhnq8GSYkno47jCQnV45QXcy8ao/UAnvhpMLHw915QJiuDr8cU6JBuNaAYBYy0ZOLmIpaR/ypCTlMGnQWiPe0DaFiwKh0T+wA7uvPpWfU7MzS/Hjqk
 NBOHqGjV
 gMDphfPcyvu5kQ+HGA8tEQBA+Y0bbwN4C+feibdd232Obzaw/brG5obnNpedxTHldDpL2HXBI91D2vfAUPtbs/LM/yer8fsVgOs60j3zZWr1HifrofoRv2L2l1zj8A+SCTuzijkZLgFavaQn4WUpt1GZlA26/TQk5IPMDyJCy/MKIjXF4C3O2XuJdtxY4vsFsnNqHH71uAd7qY+qUOEPl8cj+0KjQeflR7+Xzyx6jwNmzwSNQvsmqZ8f3u7hg8EUnOezjnwuUcX0OjNFw9qSOOJ2BXw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_verify_merge_regions_of() is only for nr_accesses_bp validation.
But nr_accesses_bp is no more being used for a real purpose.  Remove the
validation.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index bfef6a8556c8d..78c32ee45d28b 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3121,20 +3121,6 @@ static void damon_merge_two_regions(struct damon_target *t,
 	damon_destroy_region(r, t);
 }
 
-#ifdef CONFIG_DAMON_DEBUG_SANITY
-static void damon_verify_merge_regions_of(struct damon_region *r)
-{
-	WARN_ONCE(r->nr_accesses != r->nr_accesses_bp / 10000,
-			"nr_accesses (%u) != nr_accesses_bp (%u)\n",
-			r->nr_accesses, r->nr_accesses_bp);
-}
-#else
-static void damon_verify_merge_regions_of(struct damon_region *r)
-{
-}
-#endif
-
-
 /*
  * Merge adjacent regions having similar access frequencies
  *
@@ -3148,7 +3134,6 @@ static void damon_merge_regions_of(struct damon_target *t, unsigned int thres,
 	struct damon_region *r, *prev = NULL, *next;
 
 	damon_for_each_region_safe(r, next, t) {
-		damon_verify_merge_regions_of(r);
 		if (abs(r->nr_accesses - r->last_nr_accesses) > thres)
 			r->age = 0;
 		else if ((r->nr_accesses == 0) != (r->last_nr_accesses == 0))
-- 
2.47.3

