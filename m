Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03DBAC4450A
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 00:31:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 410696B00B2; Thu, 16 Jul 2026 20:30:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C0FD6B00B3; Thu, 16 Jul 2026 20:30:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D72A6B00B4; Thu, 16 Jul 2026 20:30:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EA5A16B00B2
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 20:30:37 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 626FE1A02EE
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 00:30:37 +0000 (UTC)
X-FDA: 84996387714.02.14176B9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id C88C2100006
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 00:30:35 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mqolhtq3;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784248235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f7BiQZV1zrUqjFiVsCPj2Z4br9MeBNP7ID/eB73kzGI=;
	b=jR4U/MossIvQWzavydqgKyDztcoOLnbejf5XcQeCj48QQzxXxjrjRFj2U9ydhzdI5fRBkV
	zbytNBaaqpj8JtKELowc7kjjd7URlIMnw8MSl9RKAMl2IDw9HYcG0LqtdfRy2/EXP941Wx
	DOAgcH6BaQQ56rw3HndeqSk/TUY1x3c=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mqolhtq3;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784248235;
	b=b4S0wj79xsPMQJGAHePCsKSLtHTCue2vSOzwk/tZHeCxYJJdPwAkjVAejL+p+tz6lzSzXo
	B52qvrIfrrsFRgjscfY4fe1hP49FXTP4wnLPmx34nUyq/3sixcsPl2jZpaYRHha/YYyHZb
	NO4ldSukqtF6PYFLVGlpbWyawyyM8uE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6DD1D60A69;
	Fri, 17 Jul 2026 00:30:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C61691F00A3A;
	Fri, 17 Jul 2026 00:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784248235;
	bh=f7BiQZV1zrUqjFiVsCPj2Z4br9MeBNP7ID/eB73kzGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mqolhtq3pNMNCV6TzxvelK3yiflgKnSTGhs8DriQEmCP7BXbeP6k7IY1RXlfOhhIe
	 F1kIvO8YwVovdkAl/R0KGff+TwEU8nRp1e/xwnHYkhbt3lCZQPIOa6ZRHXuJ8beLD5
	 HExug7NiAVnfZ/Y65FhtLbbe4iwBHsdUDdKPvDHZ24vZ/X4WePwAzs+He7jTrfRHsc
	 5lKwSDxin7ncC41nAoxcJ3ZcsVKd8gd20s/Ratm+rLD4cupNU/NeywlQU0Hp1i6qH1
	 KhGlKZ8gD1Li5XDZGNwngrpG/lgXJC5lVop4aUWG7u3DV+olPmEZ2y5S1Fb5jkPo06
	 Kx6V/SfZ7wdug==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 7/7] mm/damon/core-kunit: skip wrong region walk in commit_target_regions()
Date: Thu, 16 Jul 2026 17:30:21 -0700
Message-ID: <20260717003022.119437-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260717003022.119437-1-sj@kernel.org>
References: <20260717003022.119437-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C88C2100006
X-Stat-Signature: 4wm89rw1mt6k1a1rydfnjt69q1x3q3jo
X-HE-Tag: 1784248235-772930
X-HE-Meta: U2FsdGVkX1+0WJoMu4X0ZSiKWgOtljBCb5EWIq11CAZDm9I+Po1KLEm1AFOzTN0fMU2Jq7OMbVJJ7czzb9vwkNxQqSqg2qt3z4D7y3KZL++GS6Ml4qtLBHgT6ANwA3xE1vup8XouxsA5AIpPVyYzS3I4V5APNZW0hFmOe0iRcGTZGp0uuAhi/0lp7JZbvogltrdiGdnM8V/EcxtxnPcJo+4zVK3IKKHf85NXt+fwZQWdLzaxH703vMQ45fxDMdPCEkQIul+EAubWI17D8/XKaGnafIMKFi1LI8fZErDAPmfXF2eZJtBfmV5TTWJbCs2DOlw4DYdyRBgDZbM4Z3iVmPyjqx3rpAOQXgD+dIjK1Kfhz/J71t6Lf2Z7pUgUxZ4icxO6Kb5+X6tmzWQZZY07N4oMlcUzITBxlatcx7wrJsZ2gQm6O+lxeAcyB0ozkzQLT1WUaP0h6VZa8+C1Z2IabzFnwhAT5Z/C9A9+kdDSOqDCkpG7+rLqA6R/tFYtF6oOHFU6qEmg1mVTc3p+qd8ze1hdjXl2JvsoH55k0lDp141KgYsBkXgJhxgmo8++d1cFISzlCsRzIhydx2aY9nYZYbfKu5LYUZfA6xr8/nCAoZE4/0RDlpe+sfKnjS8UKK2KgDtNVi78Gng+pWPQ6LAWsc6RzfCzwgqwwrl49Ij4PCV6pjeedrFzG8nSc3LiMh4K5UoUeJx9P+qBFO79mhaj0Eo10hKH87nfh1XHeaxplAkXuANYjSTK2uNHaxHGtpmQWTRZacEulrw5Pp4gkmTYgWWYoAj/W5qrVOP/TX2xGsVp0LnINg0x4UNDTi8w31IbNhUEVgov57ADheHLQ3clvcbFcWnylwyIoRvwLx4a3ipKo8STtUNcHTanM++Ym0txSXJ9/qPG1HVDC2xtNlDYexQ20Q4fqHleATfGTUSfMKsqLNUshM8CXeQ6x8juvNKmZUXeC5F5FvmvNdliYdX
 W+Rhn+Ou
 8m5Pm3wuLV1WAxdvUa75bhvRW4g9wsH87OssgvfJcWFrsRR0YKHELjbB/Yj3eElsOhr5kmSZDPxW8gQM1O1PHIpHBr3GR6+kOJwuSLczNNBb6zkgrMs8MGKvJ1epgLMMMV366ZfWZgkxU0qNKtCU9y0EDWpz8kWrOpfcaxMICEZ20dvDwm4FBSJtc1mW1k+mOqj1CuTkiekCqOrN69S+Tkz2c6CTokBRY4LMt0Ql+cbB1wGgQAZHiI4m/1HFaMXt5HHR2B7E8fmFkmABCF6uaSGE/2w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_test_commit_target_regions_for() traverses expected values array
after damon_commit_target_regions() call.  It assumes
damon_commit_target_regions() made expected number of regions.  It might
not.  Because the traversal is made based on the region count, it could
do out of bounds access to the expectation value array.

The consequent user impact (out-of-bound access) is quite bad.  The
realistic user impact would be limited, though.  It would affect only
test run setups.

Fix it by testing if the number of regions was also changed as expected
and exit early for the failure.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260713144757.39740-1-sj@kernel.org

Fixes: 603f67eb91e0 ("mm/damon/tests/core-kunit: add damon_commit_target_regions() test")
Cc: <stable@vger.kernel.org> # 6.19.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index c0fc903a6a259..805d15a64500d 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -1277,14 +1277,19 @@ static void damon_test_commit_target_regions_for(struct kunit *test,
 		kunit_skip(test, "src target setup fail");
 	}
 	damon_commit_target_regions(dst_target, src_target, 1);
+
+	KUNIT_EXPECT_EQ(test, damon_nr_regions(dst_target), nr_expect_regions);
+	if (damon_nr_regions(dst_target) != nr_expect_regions)
+		goto out;
+
 	i = 0;
 	damon_for_each_region(r, dst_target) {
 		KUNIT_EXPECT_EQ(test, r->ar.start, expect_start_end[i][0]);
 		KUNIT_EXPECT_EQ(test, r->ar.end, expect_start_end[i][1]);
 		i++;
 	}
-	KUNIT_EXPECT_EQ(test, damon_nr_regions(dst_target), nr_expect_regions);
-	KUNIT_EXPECT_EQ(test, i, nr_expect_regions);
+
+out:
 	damon_free_target(dst_target);
 	damon_free_target(src_target);
 }
-- 
2.47.3

