Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93B39C44515
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 17:02:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11FB26B00C5; Fri, 17 Jul 2026 13:02:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 049AB6B00C9; Fri, 17 Jul 2026 13:02:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E04986B00C7; Fri, 17 Jul 2026 13:02:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AA8D96B00C4
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 13:02:44 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D1526A0134
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 14:34:56 +0000 (UTC)
X-FDA: 84998515392.14.D143639
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4E4E2A000F
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 14:34:55 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="eS/razpG";
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784298895;
	b=BX/TwM6/94dv0JfNgCSdOfA642+kSqk7tf/Zzbv9syhl7OUszn+Z8pAgnOxfbjOvjsBy3c
	n1tTxDDoi0b8criYBetanNCSa8uIHEHilHJHjwk52S1NeP67hSiMQFtGgtM3SoIVIyWU1t
	iZ7mGp+f1qwMYjL+sFm8o5S0oGvBH9M=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="eS/razpG";
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784298895;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cUz2au4OyIrV9kPXUAznd25PGFTMj7HneR6m36jCxn4=;
	b=0zkBK6+JtUJezusyYYS/hY6eC62L01WC/pPPylnIbqMiMcQsZDz9pqdYrT2Hr2ddepnHPa
	bU2dGU6tugUjWb7HZ3koRppFhiFq8vHIwxbolBtE0NAI3qsmYKEX6uFA1GamRbcbmddiVY
	L+HQXXHkPfC4CHIPJH40o46wZ36vvNo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C753560A71;
	Fri, 17 Jul 2026 14:34:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 516AD1F00ADB;
	Fri, 17 Jul 2026 14:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784298894;
	bh=cUz2au4OyIrV9kPXUAznd25PGFTMj7HneR6m36jCxn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eS/razpG6Ph1ZltnxIDbC+HYJ37YmUoFCG7DAoVLnZHEFU2EFWpXvcnJ0fFzkFZ2B
	 phd3vUyNk8S9JwshuluPwfJ2KNI/djoj4j3jT9PxC7c2W6HdhkNLE3TwoZ4vMFMtSp
	 JEOURclbt3SSvWi+Wd5cBGutyYtfIhUlox97uIHESs3HEb4MR8Zk5NOJjJ5vOZC96b
	 UVVtn6QAr2z2K2HCy/2pZdAx+W9sqRcKHBm3H3a5tURQPypgj7WrnWkZTLoRODTSQf
	 LxJtGzShZ7bMcrXjmvtxIVnoriJAVFN6FcQ46ctVn6/8XZ+U6ZzHDsP0QM2KSF4w3U
	 OlBYagyBFjkxA==
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
Subject: [RFC PATCH v1.1 4/7] mm/damon/core-kunit: handle region split failure in filter_out()
Date: Fri, 17 Jul 2026 07:34:41 -0700
Message-ID: <20260717143445.91207-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260717143445.91207-1-sj@kernel.org>
References: <20260717143445.91207-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4E4E2A000F
X-Stat-Signature: dqcph3b1o1g4ba7bo4dukq1s3ocnm3n7
X-HE-Tag: 1784298895-204897
X-HE-Meta: U2FsdGVkX1/SSThBKPNkt2OzE/NjhQP9lBWNxAeicSgQU/AjS39q8LaYgo0bqMkBKmA2R+2hl0oZSkak/AqEbka+ymxfGIQEpqOcpwfaVKGjXyB5Uu/Gwoirh/i38q6XMEeusGhzDUsUjg1uxZva3Nkf5JF97SLZg3B67tygT5wqCgwV4rDlvbNjwPHDwU65nV1rVugu/gWwSrjZ9MSvsd1iDjRLmTesuqcc/qSGUyKpBnGkPrZ8uoB6Ve3jk92ZJDOl/yTmQu+EYkxIjJ2Niz/guukLFPVv5YBvKwXqkGdcrx863uOWnpqxkAYVUVjknSGXYHgV97LKKzegnTwO4l6UZ3CPnx7yX1uLdJ5UUDpdkjbkwUL6YYQhAaCtokaAksBM6khtvMwC6FKw2dkNoKXJKWiyyl1/CAQ9Hn5jcWNIkjYKxUTgj1U6lvP/zadz7ClbdGzH+MltrBFvt4Pk/G9bqUqVDaosXtTZbIeRL56q7WdxP8splRJzPqUm0VH2LYdoh+AdBWb2Hrs4QBFeCjHkPKGM5RCxdJPu2DdOxKYAOVzkJIpfVqXilF2FvH6Yx60Nbrq9WbQXCjMbWHJvEJkrh3WD8BE+aTZZy+bhj4ySDPl9cV23STmo0fY8zIOExiERfKJUuHAnbVISejle0uQRCVCCwC3/KYr8L8DyDvup8CFdvG2AHs6VY+xm462vA7l1IUOWyPWcaHQq+EjAWQDOW1pYr7qRP0bJZrbyYHfi+KbglaeKwp9Ydv4FLSroBv96oydYxdS9cJyf2/Cm6Xv7DPsyOdIspV1kbVnamMdvQPS62TO+SPbyZ0NQPuABFwLs6pTHMJu58Pjk9sSm++UNbMasUwkDpCsIpfG9agxtmcMd9ivloyKWM26kPBxGXcoAvK9GRkXSf8Vs4166QaLCqdHajVIkgeWXUQ7rJMS1/6YkmpANKCmRiwqvevLffNBitDAnIFryxiskn43
 1HAfBlAY
 KBrQqLP3X0vRiPAL5eTcC/9S8rBycZYF2t5JhMvF7lYov3iGSVzOmBKUa3v0PORX0fvgCDPHzdVWU27sTdH10RRDhwWO5uLV8bxY/smSszSHgUABS8u+LxcUH65sKQQz9Sr9GE15/AM+erIqCRcMWXYHIFBF43qDm6wZlh/DZOrz1H9j4Rz68XIVwCRN0i9XHu2VWKwS5SpxOKRgqSVGU4Z3MjUcNicqqLJmh/ufLG/6FmRsVRA/kiJZsfNOE41uKhwXpvx+f9Zpml+8dtSeeDvFt0A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

dasmon_test_filter_out() test checks if damos_filter_match() of an
address filter splits the region as expected under a given condition.
But, the test continued regardless of the split successes.  As a result,
the later part of the test could dereference invalid pointers that
returned from damon_next_region().  Further, it could corrupt memory
from damon_destroy_region().

The consequent user impact (memory corruption) is quite bad.  The
realistic user impact would be limited, though.  It would affect only
test run setups.

Fix it by exiting early for the number of regions test failure.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260714142352.100478-1-sj@kernel.org

Fixes: 26713c890875 ("mm/damon/core-test: add a unit test for __damos_filter_out()")
Cc: <stable@vger.kernel.org> # 6.6.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 322a295ac2cec..eddf3a0484583 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -1365,6 +1365,8 @@ static void damos_test_filter_out(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, r->ar.start, 1);
 	KUNIT_EXPECT_EQ(test, r->ar.end, 2);
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 2);
+	if (damon_nr_regions(t) != 2)
+		goto out;
 	r2 = damon_next_region(r);
 	KUNIT_EXPECT_EQ(test, r2->ar.start, 2);
 	KUNIT_EXPECT_EQ(test, r2->ar.end, 4);
@@ -1379,11 +1381,14 @@ static void damos_test_filter_out(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, r->ar.start, 2);
 	KUNIT_EXPECT_EQ(test, r->ar.end, 6);
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 2);
+	if (damon_nr_regions(t) != 2)
+		goto out;
 	r2 = damon_next_region(r);
 	KUNIT_EXPECT_EQ(test, r2->ar.start, 6);
 	KUNIT_EXPECT_EQ(test, r2->ar.end, 8);
 	damon_destroy_region(r2, t);
 
+out:
 	damon_free_target(t);
 	damos_free_filter(f);
 }
-- 
2.47.3

