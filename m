Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4DC1FCC9A4
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 01:05:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 666626B009D; Mon,  9 Mar 2026 21:05:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FBD86B00A0; Mon,  9 Mar 2026 21:05:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35DC06B009D; Mon,  9 Mar 2026 21:05:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 173156B0095
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 21:05:44 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D0FE61B7EC3
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 01:05:43 +0000 (UTC)
X-FDA: 84528360966.30.0DE32F9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4592640005
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 01:05:42 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UlaywHj+;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773104742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nXQwFia5MUkSWEbq+GlksNthoUI5oeUzVAVQRJujAQc=;
	b=e9sNB1t9cl5nAbV8TrSRZc5LL4GYGlGPqZ/TkPo8KkCKHYUYaa+s/IAA+VJKGuPrOYr8iA
	nfIIoqk55AsfNs2D5ISxdhKBypXoYFlcwzyz8r5r7Ho52nH67InDPH7JolOyOCAqLBs9QW
	ZzHongqY70aSDDii5/70h/gEvAB5Ksc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773104742; a=rsa-sha256;
	cv=none;
	b=7pG6Rd3pR08jXDLFXj1IZYSleWcNNT8ypPFYP0l4plmqtWX+n9MmJnzkAhkQ0zZxzj7HXU
	Vy9ZOUqI8f+VVIVIW1tCGbcMFP3ITbyeuzIr6k0ObcNrAf9xwhg6E+rpB/rlayVpAwENay
	O2GuQ+B7HdkX0h6LV2043RGQAznulAQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UlaywHj+;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0A1D844164;
	Tue, 10 Mar 2026 01:05:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7DA2C2BCAF;
	Tue, 10 Mar 2026 01:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773104740;
	bh=RnZI/MXRpMMVI21PH3lD5eWdT2CRwxGrwP2sFfAnvFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UlaywHj+K9Zz2qhj7I/fWERoGNXH/0LTgb4PdowthXyd5FwlOhmslyFIZVF6MfnW4
	 lu6sAjCygck1yJ50owxWPe+2ogZEGybivoRQTi6jwkZUegDx2Om42qstvvTRxM1xnk
	 w/p/ek4mLghJswoGvuTMoekqXnrVUougnaKYcrJOMUojXiqCK4TKOwYi3CB3GkhJcX
	 OtfWIviJ5z0K5CTEaqw1J4sGw8ECJsbAQPg6W1wS3uKfb0+HpPI//zFwSgE3LhNbn4
	 KvkR2hPivPaKl7ELQZRIXpC19bxZUrkQ9eFqm/hfxdIQCeMORQkeelINdGfu6uE0Gv
	 0nfdGv4YoRJ5w==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 08/11] mm/damon/tests/core-kunit: test goal_tuner commit
Date: Mon,  9 Mar 2026 18:05:24 -0700
Message-ID: <20260310010529.91162-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260310010529.91162-1-sj@kernel.org>
References: <20260310010529.91162-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4592640005
X-Stat-Signature: 6yaiycjcobqy3ogfusfubg98dm3dtsj4
X-Rspam-User: 
X-HE-Tag: 1773104742-397857
X-HE-Meta: U2FsdGVkX1+l25TKwBvPUOq68LV9keKTorFTkn29CsqmLZAgpOc+Vk8J8BXaayYCoFooTTrStQHTrOIDatNo/EWqE6jTRBlnlg47bVeZ+ftcdUOyYJ+qJT3Q+jsE/oJQ5UMHCcoNxi4ryOIAO8j+MNBclxCjBh5Voj99K5AVCq4ENPwRscTJBiy0CuzUoLxS2/LshsvKSBzoW6HadNseby2hi5AXY1OI4a955mNymzRpMR4LxG/CE0a8IEZLafyjdPQ2tIANN3Wv8wH8cnYeB4P1WeHFdY2ZiO0aetQfrbkudb6ICZJs1/+5/yQd5jyQTmlF3hTyW7bv4lU82ay/pVPXd00oJnDJs2NFiMr1Msn1C5U1Dw3h7I0o0qTJx8kCNER+ZjFHD+KGPmiLORMbiNd2hlWNHubNEaT8b2G+2tPNUY7gOLMYWmJBbNXPT/6R1QCe9qEocyH1yyARVZ91FLrjg7uIzPZsZwYe1UDFDztFByWFfG3Kz6lFWKqDZzaEDGQsiXoOE6Xfg8mRSWyZrTnVu9kT4NwgwwQ6pCdmwf5YzdBMO8JDWYomc4qTCNdwH2C14PiYg85kxk4JADlHz30ARHRVuKFV4wL1zpMt5nB9D9igZ08/DS/9VLtbv4R/nRxui366gUht8uUoKleAGFsWrmPOFWipwFoPYBXAgjXPxGxe0+oFvqjKvqT7cWfaS7LAY74gA5Nj9Ig6D0yDtk89G7htjYXvzi2M2SgV5Gh3VBuEe8Eavj2ftIdvAwDiWglbOlsIcdNPIdDZgdLmhCXC3afcnP6bX4llW1lw+ay4VCRZUIaW4ppI0eljvlNYfrIP12WJconzOHs5Q/Wo42WmoQQ+2Es4rWQwiKItZj4uafOloy5kTzzCw9HrGGMUGnKk2Y43fZDhgxcoHkiyZoNFGRGjeAyeCGzfOqv9sTkn7LQZkvkTrkau2j38J6a2qMhDH2IrhdOZwZRpdLo
 d/vhnFys
 wv+waEzNp6SJae/vgkk74hKjFRit+a6vh+1bF7RAzD7PqTCFiTYbal04sACtsJ4w1FTGO2rqKTIpTM9QLkFjgOnKPH1Sk5aqau/5eq2we6q06f9JXwfBy5qoLfONUzZVuG3qfglbJmBMGynvjdLcYizZNN6KaugkWj00n05Xk6ECE7Ub77Srk4aVXqKdvY8f10lOewkcWyKBdg2f6y/LbHH6t4JKHmaheW9JIXz9ojmMfrzXegDWgW4nRBHqwNX0K+GstTHieOy8kpegJA/qpNEJiwQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend damos_commit_quota() kunit test for the newly added goal_tuner
parameter.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index e86d4f4fe261a..9e5904c2beeb2 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -693,6 +693,7 @@ static void damos_test_commit_quota(struct kunit *test)
 		.reset_interval = 1,
 		.ms = 2,
 		.sz = 3,
+		.goal_tuner = DAMOS_QUOTA_GOAL_TUNER_CONSIST,
 		.weight_sz = 4,
 		.weight_nr_accesses = 5,
 		.weight_age = 6,
@@ -701,6 +702,7 @@ static void damos_test_commit_quota(struct kunit *test)
 		.reset_interval = 7,
 		.ms = 8,
 		.sz = 9,
+		.goal_tuner = DAMOS_QUOTA_GOAL_TUNER_TEMPORAL,
 		.weight_sz = 10,
 		.weight_nr_accesses = 11,
 		.weight_age = 12,
@@ -714,6 +716,7 @@ static void damos_test_commit_quota(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, dst.reset_interval, src.reset_interval);
 	KUNIT_EXPECT_EQ(test, dst.ms, src.ms);
 	KUNIT_EXPECT_EQ(test, dst.sz, src.sz);
+	KUNIT_EXPECT_EQ(test, dst.goal_tuner, src.goal_tuner);
 	KUNIT_EXPECT_EQ(test, dst.weight_sz, src.weight_sz);
 	KUNIT_EXPECT_EQ(test, dst.weight_nr_accesses, src.weight_nr_accesses);
 	KUNIT_EXPECT_EQ(test, dst.weight_age, src.weight_age);
-- 
2.47.3

