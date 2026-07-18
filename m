Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3636C44516
	for <linux-mm@archiver.kernel.org>; Sat, 18 Jul 2026 00:15:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D5AA6B009F; Fri, 17 Jul 2026 20:14:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 285A76B0101; Fri, 17 Jul 2026 20:14:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08A976B0103; Fri, 17 Jul 2026 20:14:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D218B6B0101
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 20:14:49 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 533031202A9
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 00:14:49 +0000 (UTC)
X-FDA: 84999976698.02.C258565
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id BF30540005
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 00:14:47 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eEiU48dQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784333687;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VuPFx8TTNBzLXDK2qKBdCiBzn3J3hO3HBSaJVXSFOsw=;
	b=xar8KICTe5F5sG/D5yN5V4B2Sryvhm/mVgHUu0unDtzqeRzZWnTmVsIF+xkcRCUnDwpRoO
	2MT5h8LBlDmcz5B2QyCeovunaeLxx+ZonfVhUxnPXH6mAZl4OLWyIZ9b+zorQX6NVX3NDi
	AMAMrONrItLr+oTdnOYDNvCq0MIg2vY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eEiU48dQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784333687;
	b=YMa+KCJ8Rc5UKVaoGXcG/hMLwJRuRGhxDroiFSqYAn7nI2WZ0DXFCiYRDLpMUCwVvnrtmC
	4gcgw0Qg67ugfXQ80QqHIN3gF69qXIpzfc+px+Epu6Tp00/TGtI6Yh2tovJQns9ep12Dtn
	iMhxd1dvvfxoP3NzUMpE2+Tw6x24TUk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 117E74516E;
	Sat, 18 Jul 2026 00:14:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E5D71F00A3D;
	Sat, 18 Jul 2026 00:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784333687;
	bh=VuPFx8TTNBzLXDK2qKBdCiBzn3J3hO3HBSaJVXSFOsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eEiU48dQasMg4plbYEWGNgKVXJ5EpuET9reLcOHgUZc/673efrBRai0hWabxe9XhO
	 A6jsgZ9ZXiEFpmf8ku/81CuxtgTVkf00XX8dF2vZRV61SJuqfYbhzL4r7Jt6rk806i
	 miduKUOtGaIMwB+rY8c8DRkQKoTIDASZ7RlRZkaGgVAl8XkUOhvl+M98n2J3pKEmdB
	 1HAeQUfI5xAOZiL4dhbW/6oUq2CzsRrb8RCcwcxrBYfdjyIZqT0m8o0VHquzWxFwi8
	 v3s/cTEElQySXsW+N5kft/xyq0LX8WjmSgbiC9oRm3yP1J4WgluIovftrTz19V7Usg
	 AtBsEX8sXX+ng==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 5/7] mm/damon/core-kunit: skip wrong dest walk in commit_dests_for()
Date: Fri, 17 Jul 2026 17:14:39 -0700
Message-ID: <20260718001442.87129-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260718001442.87129-1-sj@kernel.org>
References: <20260718001442.87129-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BF30540005
X-Stat-Signature: p1owfm8i5k8agfrkfzgttthfg3b1zrru
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784333687-687394
X-HE-Meta: U2FsdGVkX1+HMWkaW8c+S0rKTwmB2bWPKa9woCWYYg1DjudXEg+YlKzPSk3eqCaEfBw9dxEdbvzCh1LiMOYjXDOPl9VmhLDIZYseK/4FARYGl+D0xItaR/FGJS1Oj7yb9j6CC6/xGGDSlR01lFZg6RN9vuQogU8r3UP6MQGjT7tBy4Lc2ibg/TRXxrwWIM8JFIOvMbSu7cYX7ck294BKJXWvMZG4+wuPPJl/g+wqLTFHrz0+nYpW+Dwvppcio6Z1o6hjFiAzIE0p1s/DlLxyPFnhwKkTairtmenkfnbZY6zTDOmMoP4EnNw7T7wJgDQRU9V2NaRF2WUmnXmZ3uCw8QriwpgKQmZ3wD+heAvfHmFaVE9wqffUqzLFMrxkbxYlQJVaT9ei6skqla++Esq6rGY6Cues1qd+FH5GItqvxLaE+VpLW8S3fMoepc8qZF5oOZfoTpQMB96lLD5YNBZdVM3n+r2JnmIj7Cj6/yBToLA35SlzVBVpt710cHkvGszOCDZNYUCvmHyQi+7Ez4Y5CyP6aJEQAOxd2xN/ssE5ROGwvrvXpvnKomU0rxMq4KK5TZFeQYM5AUdLqk8GkIYc6pJGuUMQsgBKRk3Oi+yU/0UG3MTQlmhWBuN4rGNJAdW3xop1GUjklaHduNVSgCvJu+b9VGkXSbGJDGUgztFp6zHrZj7fwDhbLFj+L+dukMJLLqCDc5HW9PRjjaDZydpxRXGrMr46qQIIT2SKiPAdpWj+AdyDGxNXX0byC1yxffbuv85OmeWTiAFVJpPaL7lwdER0NJR7/iRxuGb7RBhU1RWdOeWqDemSEiCvhEEtgvpzPiR67dUHrKpF4Yx4OCvISTW2uxGKQD72U9D41eaAwL38XndFut7PuFthUinwDGKs4lyCVCbHw3xUvsZdj4bLylBSz/yrplQYO9N/oXklDnF+7yBPbN8kzqDZsGkwfLYQAtfnvHF/SjjQHDa9khY
 L9msYKi+
 UrUFNJPLg20PMqn2s6YYMVR7iYHohOw1VFoRi/RzkdD4nNzL6tchqa8enavVRyTV4Qhst7yXP9v89V8JJiMZ2kv3yt/lge9k6D4H8xcYXc1sRo9vjkPPdiLPI+BVlXwn4U3ZTdAOenhl1+IrtOJLk+w2EgVjZNgZFzVv/e+FpIy57HIxpNCJTeVXOJdRKPYw9Pi06xIoQrbjOZ4yuZhRSfm6NBB+jp8dcHTV6xqT3oETXje6eODsb/m0prud1kSp5c4Dbo5Amipn9OwC/PDKBLwcjrQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damos_test_commit_dests_for() traverse damos action destinations after
damos_commit_dests().  It assumes damos_commit_dests() made expected
numbers of destinations for source and destination structures.  It might
not.  Because the traversal is made based on destination struct length,
it could do out of bounds access for source value expectation.

The consequent user impact (out-of-bound access ) is quite bad.  The
realistic user impact would be limited, though.  It would affect only
test run setups.

Fix it by exiting early for the number of regions test failure.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260713144757.39740-1-sj@kernel.org

Fixes: eec573b8dd65 ("mm/damon/tests/core-kunit: add damos_commit_dests() test")
Cc: <stable@vger.kernel.org> # 6.19.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index eddf3a0484583..9b8c20a50ad53 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -1008,6 +1008,8 @@ static void damos_test_commit_dests_for(struct kunit *test,
 	skip = false;
 
 	KUNIT_EXPECT_EQ(test, dst.nr_dests, src_nr_dests);
+	if (dst.nr_dests != src_nr_dests)
+		goto out;
 	for (i = 0; i < dst.nr_dests; i++) {
 		KUNIT_EXPECT_EQ(test, dst.node_id_arr[i], src_node_id_arr[i]);
 		KUNIT_EXPECT_EQ(test, dst.weight_arr[i], src_weight_arr[i]);
-- 
2.47.3

