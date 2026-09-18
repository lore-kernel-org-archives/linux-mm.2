Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 138B4C982D8
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 14:29:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B39F16B0099; Fri, 18 Sep 2026 10:28:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEA7E6B009B; Fri, 18 Sep 2026 10:28:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D8906B009D; Fri, 18 Sep 2026 10:28:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7B45B6B0099
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:28:41 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 822F7A06E9
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 14:28:39 +0000 (UTC)
X-FDA: 85227113958.02.374E214
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id E28F440004
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 14:28:37 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U3UKdxmk;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789741717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yRWBrRHzXRD4yV6zK3pssB5trIwz9nJ/p0K/bKugcGc=;
	b=x9iZwzMAKLWpJO6933N88mOgCa5EXzSaeF5j7Pmm4CVHRMfHF8sWnR/eiuSQeIIv6nB7PV
	QJ1oW0kwP4blN3JHvsDEMTQ4F53/6ZVCKGqLWmT0FeMat0KKVWOLyMsROr3au9frtp5OqK
	Q2MPeT3JJSVu9Drd11kjFgUdrkrR2zc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U3UKdxmk;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789741717;
	b=WTVWb/EQQR9dm4hU8jZ6QdmBX0GIhaNN5z2oy2/TsYQ6MF7ob0S6Vs1qt2MueE13GCucb8
	5gLtjKYt95YpFxDP8jmHSbeG9iAJY798KRhNsVQOd+DtsIDQuF6lBo0HR3nbXL/MZ2p3C0
	PakUdaZaq3LlHtacyCQIZYKxpPVkzd8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 488BF6022B;
	Fri, 18 Sep 2026 14:28:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B28071F0089A;
	Fri, 18 Sep 2026 14:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789741717;
	bh=yRWBrRHzXRD4yV6zK3pssB5trIwz9nJ/p0K/bKugcGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U3UKdxmkO5xWdreA65UuGBv1dqMomRvgd54gkrZ8RGNPAlQjZAq+HKNGLEcYZQdbE
	 7FlyQwK7gtWLhJdK+doRYKhEDNLUliIW6k7PyptSPoUO0cuxoq+Fme7pGTKaxWfBSL
	 gHas31tt1h9X4+SvaTrHq9RL8a35T82XKwc0oj6+Tep7ja5PVwwdhwXFIadaRuQ7tt
	 knun83sYAYvGf4A+FOw8JMPrtT6Pz+/iN+j5GrXLKzVQoTjnFEa6vXE5FS5Zl2RwN1
	 zf03kLTVzXa6oPA87qFQqd2OEkjZ61EV+erS0KYZKfnzaFcYg04rXISNChyqAb2eWf
	 Nl19yQJQ3PYHA==
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
Subject: [RFC PATCH 4/7] mm/damon/tests/core-kunit: test quota_goal->complement commit
Date: Fri, 18 Sep 2026 07:28:23 -0700
Message-ID: <20260918142827.85303-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260918142827.85303-1-sj@kernel.org>
References: <20260918142827.85303-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: hbegq7baiuoeajc68cspjxdwmwaqhsok
X-Rspamd-Queue-Id: E28F440004
X-Rspamd-Server: rspam07
X-HE-Tag: 1789741717-820919
X-HE-Meta: U2FsdGVkX19/IPY+B6RZyG7ioIVuPkH8VBkxoeEZLnXt1tCWj0yUyS/Y3Cf8XrD+y/i8gaPbzsQz+TiZdNd9aOGL3gsitpF1Za6BG7HGDnDJfNqBDk+U9KlhvRLTmcB9yjtOVmpNmYbkRENo6YgKqMonYiAgbn/2GVJhYh17m094NAwiYndLWBxeIJBMlVABTGLjw3JdeCDzUAOnklYXeUMyHIE36keILZWW7tGxpubLpwSWBAbvq/sHLaGvyV4EBIJyr5bk68iRPh25hRm6pZIm+pUBLrzETx5HSnlssKpxOsQR1sFiSHfXWFdwWu+PyltQEh7StlBm1272VHV3zrqyHepk+Oj9i7j74qtEUgG8vvol0O9LzlJYPF9b/XuojmfIQfovpkvPSth4QoXt8CBWxzS/Zi05N9J+ZFy+wHCU+ND4NEzzImE5UHzVfDkH4bQinjiIFml2BT3f3lhCsdsIuh0gYY6Cn5dgmDH3yIXudr9PHT175trSQqB9Ghw1TxCTAJ6VEfe4vr13L3moBP3yOj/huymQzINDevXPSQ0VkT5VnYRU//yvlSvNUKNvpBQ2avinqdsE5HGfJX7HTFszmqpn54C9iDf0Xao1RApTBtVBWhqSyl4vjOqW7SRBHsktzExQEgLUqdBn8ODceMXDVkvW2iVuPGovh8cCe2wavubgT0VJIrP86W+Qt1xdPo8MV+fMOeSSZQbFQ/6VvRBOuB41GfqhSKTiVLM2vujBFDPjrwhl8gTQcvZAiQ7pTuu76GxJ5bRFtAXYTUlfiOQ6JZDVv7J+HqbGMxK+MbzjfWB89cwij42x+oAoRZMXz8AbG+GSBU+6x3zd1xP0QjrQol0f/aRHyRKaD8BQlZU4xov46npoJBTRJrP1gfD/wElWwtvChCpKeblV5x9CcCWxwLw+Or6xO3+xvz2MNn3/2Adw1NpR/ZFdtdu53Vlj+LVCQAEXWo86FzlS4Iw
 Ask9/pjA
 p7B+yW880H+faHuX506CM+pFEQBM2rv3xg+xPbaNEYJwiHit7skGrVSK79wvRobA5/QLmwczpElITtAEkunS0IgFzJCzTnAJ5f84buU5GigOgQWp42drAyl0TTTln+0ReQ2A6ZSItESUMLr4L7/X3bT6UGo/SOg7Y8NIxr52rH8aH7+Z0w92fzew2hBkkf6FZFlHLG8P61zD2FHFcM9P4gXdbui0QXDLGxWk6qGGytwMlJ9la1fV9Zb5j+IhKHFgCCT+2TazIVZUwoxNWLAaRnXSRMw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend existing DAMOS quota goal commit unit test to test the complement
flag.  Set the source complement flag and confirm the destination is
updated to the given input.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index e8290a2c6f343..a2504e96954f7 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -819,6 +819,7 @@ static void damos_test_commit_quota_goal_for(struct kunit *test,
 	damos_commit_quota_goal(dst, src);
 
 	KUNIT_EXPECT_EQ(test, dst->metric, src->metric);
+	KUNIT_EXPECT_EQ(test, dst->complement, src->complement);
 	KUNIT_EXPECT_EQ(test, dst->target_value, src->target_value);
 	if (src->metric == DAMOS_QUOTA_USER_INPUT)
 		KUNIT_EXPECT_EQ(test, dst->current_value, src->current_value);
@@ -862,6 +863,7 @@ static void damos_test_commit_quota_goal(struct kunit *test)
 	damos_test_commit_quota_goal_for(test, &dst,
 			&(struct damos_quota_goal){
 			.metric = DAMOS_QUOTA_USER_INPUT,
+			.complement = true,
 			.target_value = 789,
 			.current_value = 12});
 	damos_test_commit_quota_goal_for(test, &dst,
-- 
2.47.3

