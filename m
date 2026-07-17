Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95A56C4450A
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 00:30:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5703E6B00B0; Thu, 16 Jul 2026 20:30:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 548726B00B1; Thu, 16 Jul 2026 20:30:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45DA26B00B2; Thu, 16 Jul 2026 20:30:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 21F326B00B0
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 20:30:37 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9DE921202F8
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 00:30:36 +0000 (UTC)
X-FDA: 84996387672.08.AA5596A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1490AC0006
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 00:30:34 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R0Vnqaj1;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784248235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=paS1pLTVHYJo6IMXrYXcRnVhCRmTb+pKMWKQvGTyqxI=;
	b=bSrUUpn8nNo05Kz2iNGwYg4zvZpeg83GHivAYz8WzFiRERtszFag+nQoUbVRoDrbLkSzdn
	oJ/NnxemqDiMalaAXGEnqt95LPfC46ZRznesvhRvNgw1wSzXZxvjc+BA1HwnSl9Soc9Ha6
	85EFrGUZ0GWRtNRO0n5SCKGhkWUOfao=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R0Vnqaj1;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784248235;
	b=bxdxj9VaqQU2OSblK/+XgNh2nJWpxbipyeKck+2ryC/Yt677mHVSFuSQ14OQBB1WGOSJ/+
	GDeLPx+UemRl+RZPzPzixmLIy9yB5pJwbOsWlMLdRWMLn1JNOPtUUMb/SFdoIwae8+i3ie
	m3GGdpWEl0z4KvksvChrr2EYndheqVQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3F93641952;
	Fri, 17 Jul 2026 00:30:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFB1A1F00A3F;
	Fri, 17 Jul 2026 00:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784248234;
	bh=paS1pLTVHYJo6IMXrYXcRnVhCRmTb+pKMWKQvGTyqxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R0Vnqaj1PiEaQ24gvhavkmJo45EQZ7Skd7tkOu3mi/0BMO48S0WkZ72qqvrTydCQr
	 paKVzrOFteVIBL6i1sWXUhMcDmVKJXO4ubKO8JuO5se4bQu7rivEa9KqvqhhOXTvYD
	 Rpe0Nr1SZkB5vZRXSJIvFLIjJu0KShDTgq+TXIeABAuSbF08xaZzJ2HxsPyTdhMdaJ
	 FY/wnx7r0ZT87Q6E1SbZwpk+0b5D0/wYeVVtfEJpH+NR7IEmaWbPJtt9InsiiSBBAV
	 igSb9YueJgSsXacLtaUDIcrRIaDYBmMJYpVUUb5hTNk5uri8flVCpA01F+FhAS39uD
	 7rCw9ylk2QANg==
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
Subject: [PATCH 5/7] mm/damon/core-kunit: skip wrong dest walk in commit_dests_for()
Date: Thu, 16 Jul 2026 17:30:19 -0700
Message-ID: <20260717003022.119437-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260717003022.119437-1-sj@kernel.org>
References: <20260717003022.119437-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1490AC0006
X-Stat-Signature: 975fya9ifuj47y6yt9pgi9e7475ng981
X-HE-Tag: 1784248234-144233
X-HE-Meta: U2FsdGVkX19J5vTgj1m2oCCdqrdBqF4Ga6ewJ1Tp5eWmyEHwTwefHK7eNSfzAhza13ZU4H2N7GUoTYbkqngB9SvuLkVqVt61SwONNVqsXEnOjkC8shd/dWpCrrk7aVoNZ2FfY9oGwMeNocKYdQc+tTdQUa7PLCBo+EWHVLPIf/4JLbFDEdNsl5sgLkyH+ij4k7nOxRhFwepojpw7DVgdflqFurDKmnPaP4opBJgE8KFX+H+kl1CT9G01p1GAgkt0q0bTe5gBn5sipqDU4pmCpGrIo/mTFraCrDcikqzDxrwME57zbXkA0RvfAY73bfi++E9HcXAsyiMb6zPbBV/G603cq3w+3CTD/30jVnmtxs77pRYkjBM10qkaaq0WWfcYSlOJn8vpTv1CWOhnSolDZKJWbRO+N0E6VauoBxIz2y6B2Rnk5DKe9wDj29YvDw4PirDU6yXOs+7OTBBCk+yXjxQJfvkuWD1sFPvJAdQ1+SEp6WlY1NNxnyOHX1tRgFK2JniE/d02BgA9vQLMBgR2w0qbZ4jjtVe1uhF/myoODvoCa615i+KP7uov/8FWk2CqEdkGuUN+Va7ThVMp7VtNXefcb1bUsYcFk4BhyIkUmxJzwy8PgRZs4V7JbR9UsW63ApAaGqAvq8HqZzl2KZ1hWJs+ad/eXVMG5Mx0RNFqzSy0SfuZh8iON9dZzingR4Fj/WjWyE2VTTxAeqZ2UHAUBpRq4GUrMyQdA01yvNVKeiBAdyOVAHyLQD30eIhfuSuI5ciMCPJnz1O9/WYEg6je90T/7pJiRf0k/Pl/FkaqhnSycUj8BkbDGeIoIEaJSEuncr6oj+VlEZhl2UiSmYOqY58gkxld0YWc9Fq7YgQeJkDNqAuGrIo+zpkx2aUu/t3LJMmfnOpHr4gqlEnjT8TrHaAvX3YO86wBs96wL2HoZ5dLeuQc1s0S9wdCCB26Fcrk5WgompwkU9XlVqz0VPB
 GMcAy/BZ
 w8BAhzur3Fz5d9dfymO5HneNWEpQV3Z6+8HqVhbUzSofV3CmM9FzitlJCNZS/xgqLekqnO9H0iFZr3tbtFDXrQnCbE9nXrfc6/gk3kEF09udHzHVYCeqD9QNUV9lT8IyXLvXvn+fxp7SxcJLg+IhgceM9U4ZHGU5uZwGahUt6sGGv0jNp9pCbb4J27wH4CY6MC7DO1qzS0jIVpQRjMX3vtgGgUk8vZPQCU51K/yvM9/8iIjHk+dNhZyAR+dt+1yMNTrnH3fMQFyZUYsORYsfB2Z/Q4w==
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
index bd3bbd421392f..ca6ac12a15b24 100644
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

