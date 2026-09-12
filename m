Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6FE8C88E53
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 20:08:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 604D76B00B7; Sat, 12 Sep 2026 16:08:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B5CA6B00BC; Sat, 12 Sep 2026 16:08:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CB186B00BA; Sat, 12 Sep 2026 16:08:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 16F076B00BC
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 16:08:28 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9AC2A160575
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 20:08:27 +0000 (UTC)
X-FDA: 85206197454.30.C0F002B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 13CA980003
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 20:08:25 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fr2Ct0gj;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789243706;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lL1r3CUzqH0YyqVpSIiKQgN1c4eEo+XPmJg0bTQTEPY=;
	b=uODoU/0Ll1NjDmCoCO4z18AElHgSShinnwp7w9jTtv+Y5aBLgKvehumRxbOepw9BueFxBV
	xKIu06bOLXRG9UgtWacuKOZG3/cp8PBKlLpXppnR1M+6SsnYCS1vAsP0sh8M5DQMIY/Wrm
	FEhByAS6k+0ISu6qbKzdyMe/7qOAup8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789243706;
	b=lDqooCr6nidt3xSoateA4LZ1GmVdaAW4v7Jq2Abho4e/6yAgC2paUitnzsHK0Qm7kPxZuC
	xvcKuIxnhLyZ5j3OGyh4SXdV7GXUaclVwDp3aL2A8aIaPvByAyA/1CglYZlntVsSQotp/f
	KQFoTFTsgodYAJ13g7WOo54FEG/IBS4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fr2Ct0gj;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 62A3B447E6;
	Sat, 12 Sep 2026 20:08:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F41F11F00898;
	Sat, 12 Sep 2026 20:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789243705;
	bh=lL1r3CUzqH0YyqVpSIiKQgN1c4eEo+XPmJg0bTQTEPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fr2Ct0gjx4ey0HMKZepWjvvdEdapyTx2PkS66AnwV5UQk0uNr5wG1pgfCcUH3xCFR
	 qoVkZgJUj29+fIgDyZ0H61stEZv38yIKh/TXvgJGKs2ENWdJa7RYznv++695Hyddnc
	 1vue1U9ySEs44c8LZMnPE6p9wVc2MMGQVxtRBCEmW0mxROCJbTpYDxHZhmhwSJKD/J
	 9Oxc80N/4g4oybr2HskM5CEY+6wGN82O8fbsgsOKgpyPsG6eqgsCIGn+SAjwVGdruJ
	 fxkJ7oXlpSI0uDMWyzK/curlpqr9F4gBJRhdV68+h+mJuk0+dlWwTyzhve3jLIUIBm
	 0T0eV6xqNavDA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 8/9] mm/damon/tests/core-kunit: test eligible_mem_bp commitment
Date: Sat, 12 Sep 2026 13:08:09 -0700
Message-ID: <20260912200814.145612-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260912200814.145612-1-sj@kernel.org>
References: <20260912200814.145612-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 13CA980003
X-Stat-Signature: s5edueqcbt1dbh31xm7ohm5euwa8yar1
X-Rspam-User: 
X-HE-Tag: 1789243705-664129
X-HE-Meta: U2FsdGVkX18MqY92m+3opFydHHU4fGQWMsz7LsN2HVql4J0bn+DqFptE697LPoNLdLISgW7jYF9xVevNNxa/4SdqTV7II8cZaau6j/mM1T294g9UcwQli21gmCydvjkMkfPlSmFTV1nVcoS4gFXw049uH+npYFt7Cho48/YMpTS84zzoRhPav3UtH47xE2YFZoJXwghNkgi+/nSwg8sZf9itFZPJUYkZt2uAiSI0/uAzoyaT2jScjxgfc5nH/gEHGH4d1W5ROZ1hnkCGF8BIxsjICA7Rl3eJ2xZ7QTJyV1Pk6g0YslwL5LYSqn9gRjeOZIJGecG5NG/4UfP41OkJhG5rOmyfFzac/LoLm3AdYtgV510zB6Owd55XXcTPJijteP7UVmYDheZNxZz2R2Uo8ZyIl0nrO3w8Ufkko1OdhvBh+xNwpS451MHLaI0+J6UlQi/BDmH0R8+RQYyNpJCzT/zJ6e0Uj4JaXrOaG2vqhP9uoznriPhnhWBSppEWvEVmSGgwiJN9LsWDvUnDv3f4HfLxufm4PqeL7G/ju+tzbkwW++hB2G6lXIVikC9JtN+kOdGulJTYG0s7DqU4B+4mbCMR47TORBpRdiGDeinou9//u93fCiY1ySixI/12Z/5ud7BV3Yv6vrr5rx5J1QSmMok6+1XlcozMpKGMgWxXhs8pUhAIW//lw5n/0MFluSInITmUIwo7PvDDvtlWQySde+GNmISgRLxjPhq63RUhgbeDDgzJh2jXFgJa974wn+2GR3rC2fB+SEAd+rWbWJZtD9hC8Rq9RHtCLFqYdrawWCpg/Thu0ZyjH2Rb6T8wdZAGPmcL7bxRTnQ1Jt+qC/C8r8ZSBaKhW/w0Hky7X0HoeOH1+FffTEZJrKEYzgvrLgl9COCEO0WHRaRlYQkQZkIwZxNf+DGIM9aEkIPSdG3Qoex/wBBVmVlQMHHeHYI2bKon25V3dJKiMw5uhSbwYp/
 EICmgi+o
 9lzMREjREuh+fq4cNFhu3soMwM81fGA0V2y/3a6DRr14xmCwd/7vQ1x5WELsNtWgPn2A6YgA1PhDNWMZxKyHMjJFV4pkZfaa4UM2cI7GcDz7zGSj3yXgfQWw+Mlkcfq1kT3YAo1pUd0axG+pCbTUBjwhlhZrT9+mbgmbiskkEl3VED1UN6DbyB7t0BycgrLNrMBf7nUHOqrLuweoUkBjco2++0adCCCwTkeMrPbtiGgUN6cOYW4jmvJIUOZhSqKjEdMQJZ0yM4noa0Z1BRi4oboJJ3RtHKsQjYSvMQGcO7m4CM1H4KPOMCEglzoqesCgizmMvzH4V1QRsISPk70J4mvivkw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There was a DAMOS quota goal commit bug [1] that doesn't update the nid
field for DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP metric goal.  Add a kunit
test case for confirming nid commitment.

[1] https://lore.kkernel.org/20260827045035.94611-1-sj@kernel.org

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 5e8ead5ef8728..c2da4a3fbcafb 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -836,6 +836,9 @@ static void damos_test_commit_quota_goal_for(struct kunit *test,
 		KUNIT_EXPECT_EQ(test, dst->nid, src->nid);
 		KUNIT_EXPECT_EQ(test, dst->memcg_id, src->memcg_id);
 		break;
+	case DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP:
+		KUNIT_EXPECT_EQ(test, dst->nid, src->nid);
+		break;
 	default:
 		break;
 	}
@@ -900,6 +903,13 @@ static void damos_test_commit_quota_goal(struct kunit *test)
 			.current_value = 345,
 			.last_psi_total = 567,
 			});
+	damos_test_commit_quota_goal_for(test, &dst,
+			&(struct damos_quota_goal){
+			.metric = DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP,
+			.target_value = 12,
+			.current_value = 345,
+			.nid = 6,
+			});
 }
 
 static void damos_test_commit_quota_goals_for(struct kunit *test,
-- 
2.47.3

