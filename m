Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21A94C9830E
	for <linux-mm@archiver.kernel.org>; Sun, 27 Sep 2026 12:06:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51EF46B0096; Sun, 27 Sep 2026 08:05:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A7A36B0098; Sun, 27 Sep 2026 08:05:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3218C6B0099; Sun, 27 Sep 2026 08:05:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0E64A6B0096
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 08:05:56 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8575D120A29
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 12:05:55 +0000 (UTC)
X-FDA: 85259413470.17.5C69B1F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id C0EA3180009
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 12:05:53 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XVfVx3q3;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790510753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2LAOr2VrxDMxvqQVVQdJq9DDAXVVY7pPMrYfBvs5+RI=;
	b=dQaTKurLZ9PL+tRtLi36ULBibF2iqaMtaa8WgE3P18K1qMd+uXr1EImKft27WElW8j18XV
	xo6JUJN1K0vkbP2F/sJCCWlv6/fSRt/wZs+GKPyso/W8rGPVRLonj5rHGrkyFb9XeJLs1C
	TcN82ZmKAyHM+6bgB88YyZYMFq9Xfr4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XVfVx3q3;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790510753;
	b=r+JXzOk4F6iWMsQZup0/dV+oDkhMH8GYGuXPh11cyIhY9j3Q4yJh/Zh/PyuKS7We+FRfKv
	++kzjRNIkMtGrS2fMSDd6BggPr/Ukw+lK069nxcqnc5kxq+Hkww0GB2kb4RwNqGw4PEIBn
	fljrwu+zwGP+CkxUNYHCmVw0UEfrlQg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5DE0C60D7F;
	Sun, 27 Sep 2026 12:05:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01CCA1F000FF;
	Sun, 27 Sep 2026 12:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790510753;
	bh=2LAOr2VrxDMxvqQVVQdJq9DDAXVVY7pPMrYfBvs5+RI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XVfVx3q3qHk+eJC7JbErH4YF5G90ayd/Xe4ajV0iC9bi8YpaoVAoy8LN0wbwIWqsL
	 PBKNLRSU5dlh/U/+WN6Cl9j4a53mtI4issK0ovHIBWpBt3/t5zst+WzitkykbKGsCm
	 c3u2DZwtiQmSSefgM9wUYitHEBoz9OWCCGyKhuqCNdjfm846PaqhJtMct0UfZsKQ7B
	 jVBLVHci3mA5bTHW1Ty0f9tURi3pFywzjMEYwUdqG2a0nD5ne2HxMI+OZjKqzDDvU9
	 H1gTW/15pweBAjLhcDcBgzqofgOXDkhJMkAFNkIRBkVmawQneoX/ewd2QozwrlwOrV
	 1gbR/69o8iDzA==
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
Subject: [RFC PATCH v4 4/7] mm/damon/tests/core-kunit: test quota_goal->complement commit
Date: Sun, 27 Sep 2026 05:05:28 -0700
Message-ID: <20260927120533.50484-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260927120533.50484-1-sj@kernel.org>
References: <20260927120533.50484-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C0EA3180009
X-Stat-Signature: 9w5ku73g4fp5tc75yjf8qgqptftp5uox
X-Rspam-User: 
X-HE-Tag: 1790510753-875358
X-HE-Meta: U2FsdGVkX1/fbe0B/SiJWqd7teJF0ikYXrKdcIciXsJfsbavA4UwrgEecRMHqebKElf8oPhZhD9yW/GszhXhsqzATyLMJMhdHwpgtzVG5q+8ukjbVnyDqh0i6L2eUbCi00fRtIerS2xPa4v0aUT2cLDJ4wLdkP0bA2+zdKAHXjR0CnebYpqPkgCVHeyb52sH4QkTQfGxt7ZSZODu/X06SwdAMwWuPSmcmL0M/5sqA5NjOKCRmhW3ncUTrsVhGeAfqSJ6b8NJ0L/OGlT7MEPkmTOzVA8ObfcVB4/07ICH58Gt4MoutYrM1NJU1TP2S0P1gYAdnjrxw/gUxfK7kWneIQ0gwtXBIzV/4pc44T96Uk0uPrYf3j+A3STGlHLPdCQtFBvIe3cOTKbUOq8Oe88LyatqSHI4XDno47FZf/xVJK2ybYnxZSI7/ooJ14tM1yzJR4qX18i/INgACtstCfFJVUDb2jXiq4skJXJQ8UtXWatP6L8d2WmnDV50YCFQlDCIPt6FXL2Fs4lS6J1njltS7BVfuyCuEzM9e+TanLg0mMji2IAMB6lG3oeX6qVHVjqkGse/Kq5HwoB7DmrddXKkX5DU1Cmh9UnbKM5ZnYwY6UXwM6Yx28J5H1weiuExzLR+w45ifEN4hrnxf8IOyWBbI6sjGf3t0R8bYD1Rvhi06zUqIDj/536puA7k4w8exlt8KggXZKp80GfGsMtwiI9/B7gZQJOYTlDXMPG16l3p3+KzelesbAmM2l60ywqfTxbNnPLc7ARHf32F+YRmCFCCvijIVwXgiqZPztbDQ2wArAXkpnOTIa7lD3hfjs6XtLk5ERSoIjpNZuB4f6SVMFSvJvcg0ZM66G1WDFw105eD4TyMuJ/35zo1yHStvDXr+CJeoas0lmKAC/Ipe/kTjdP4sDHs9RN0z/xrf1K99nshWjNxqvKI29DGrPhgwEfASwuS4BstqR6ivyjVdFM66yE
 +PCx2fhP
 kPu+li4CH+GKXC9/+0W2BdRmqDxOy66Hf7WUHWuIYZm+/LzxZISHtCH1wuHMtVNAN/qhZvXz8jPVabjZqiM0JQ1fU/7M15Oe0vn8uYUhsHC0YmPyfSj+ZqRkF376CTuprBXWm1JSQvIvf2tR2VtI10G+tfJ5439yK52qXXK3dVbEAFzKRNZo5eYnl5OE6EhC+THBkULTJA1FrX5AFNOAxWzsPUnHd/Btj945qSadEHk0L5BMsIQ9ifpaVrEC40GJd7WuxnzJWqyVlXz8WapAFdGvw/A==
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
index 20bba7421a40..6a13d9bd377c 100644
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

