Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71C1ECD5BB3
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 15:40:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60BB66B00B1; Fri, 22 May 2026 11:40:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BCEB6B00B2; Fri, 22 May 2026 11:40:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AD016B00B3; Fri, 22 May 2026 11:40:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 35BE56B00B1
	for <linux-mm@kvack.org>; Fri, 22 May 2026 11:40:40 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E4ED71404B7
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:40:39 +0000 (UTC)
X-FDA: 84795468198.20.D981DDF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6241816000A
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:40:38 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PRCm+J+m;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779464438;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rlDrTS/qDNMBtSrkkbpm6odK2sEC/p6nHvamOoXHSXU=;
	b=Ybhruftc3O5hEDGM009+5vWqekKngRNqzIef9nx3TA6SJAfSL41xwPl0ubkWd8apT0tfTN
	tEFk00NOxubnvtL+GLJhQwLVujc+pZymyLry+RhsBAec8Zvusdjazqf33Svnh6PnyYSib0
	JnTiI6G5Qq+tkKQFM9sI5MEqilhipwg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PRCm+J+m;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779464438; a=rsa-sha256;
	cv=none;
	b=yNxGsUMfrxBk5L4TtMMe2MSS1AkJe/8GCzKgwx+7XPKkza6pE659pSBLzqxNKTp8H258m2
	0fGvmZQyGkScS441deauOZaAuXD7UXVYWHsJTj/CDtinJeji4Qt+GHLijd2IgAIOCi9L70
	jxQ3jmMqXf+9X2vUMe5jrRKWnZSjAEg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 06C2D60213;
	Fri, 22 May 2026 15:40:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A5FA1F00A3D;
	Fri, 22 May 2026 15:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779464437;
	bh=rlDrTS/qDNMBtSrkkbpm6odK2sEC/p6nHvamOoXHSXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PRCm+J+mZl77Sc1wSkhjFvMo6gfXN2YkuIeCJ2pHOE8X0WlwQ5pbBuOyF3jt4nZRH
	 ben/v8RpD9Pd9a0vOPWvv/7KDogs4XMbaVgxOaUBnBEBsAYLYfxu2ZzvDwzz7gPfgB
	 Wbemfq7GP0Zvv9mudLM58kVzCVUJrZfRXcwA+KgZCQ8VNMS6PcrhiKXoF7eEDdnZh3
	 KeDyvyuO1x6tv8oXAa9KaW+Ju/0vxydczqLPpjzU9kn60SWU1dqC2p1uaRNfbQG9EU
	 Hgo8plxdJhtTC3ANO7HrR39qRyGH9uagAnkV304IxGfM7N2D6x1iSepAYmeWRyflMy
	 p0Of15I8kFNig==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 09/14] mm/damon/core: remove damon_verify_nr_regions()
Date: Fri, 22 May 2026 08:40:20 -0700
Message-ID: <20260522154026.80546-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260522154026.80546-1-sj@kernel.org>
References: <20260522154026.80546-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nbtd89mhjws7ebexaekhm3ezji7aqwi7
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6241816000A
X-Rspam-User: 
X-HE-Tag: 1779464438-430771
X-HE-Meta: U2FsdGVkX18HY0V5pq/zgppwPSPis5EJRcah270vk+c3v9lDBjYFEKn/lE0okfwwf9+ssgbDVkpV4p8WE+OtW+mBz9ubxun8JYrAoS4byNKOy/2T8UWS+OTGOMnfdAFuORSXbD2dLpaWlxD7WH3ehqDIWVzInBWXWPeQMHOSdl9t7thpveuyKPllr8a7yAxXek1k3oc3PD1B+4zSI4MdMRjifOPvAp4JE515/14rqlD7K9Cv/lhzYTVPf14hNr1QwG43mAeO7asOZL9KOX1RxZrZE2SK8QlYMFsNNIexWHlOECLOAChTrguyh7uNswNiza2gpIxHja51oETOh1bPRvkoGyvCXgsL4nDl6SB0oNQo1olR2pMNY0Drq7B5Rmottj/n5kIZLVyZ3Kk4HD6rLDdkIxdbdLg29i5ASh2evlw0Y9ydJ9TrIXYGfrF+JyKF0yEQDlkrMcCtIZmjN/AtWUZXftE2U5V9tRcDob6TsvaSDmktMm6aekoBNWuonT1ALcaupUXiEGgRD3fXV/DUSVYgqfm2oa6u+0WiFhs90dBy5uhvhdlNqLGQ7I5GpUTQm95FMiIGzGvBlLL3iRj/osR/qC4xQXdO7BOR5kkP7C20JVWGek0hRQYwpR0bV0aNEp5CY48hi9so+3oeeQt7YGIUAV4zqNv/QinSTb0lgz9dJDaq4+BJKo8r3lxtaCG+rZ7i7QWqqzIuslFkdUUQPiHWbScVQ9Fk+/IWdhgB5rP+rb2pWI5EvH8bdqM3583Po6f7HbLmY9kz+5ENQjOmoJKEvc2VUPTBftPcZ4C6yCJ5dQXOYeMooG3sBAIkWofJ3G88AyLKm4owRZPWQBa0ShiznQKt5zce4d1Cm+5A+YpZSv45YEtcFaUMIesV7U5eME6WPwTrW9Zmx85GpFCtkXfLwj0JdOjU4h5/HjflbLeCjowVlfZ/+2X6xM6lfztXwlDvn1nfTtKFv/shg7+
 WnbuCF+q
 Y+0V3DqplDap2Rw0wvnU76kDeKm4f2qixg0bckrYKwfLZKXP9M8JlI+zI/5ugSevjP4uPdGz2FOTogx9jgHzE/NF6feiS9K+lBfyE3z9t23lY3ZmEHCO8T+BVPplvdef/7l0gq5MSSzRnXGVQ/OIvxXHY8uPHjY5Aj2ZuC6fN+LoGW1B2QNP7DCiN2N5Afb0jaecirxTMggYtVkg636O4JOaobGfgIQEOWE0S/s0uKLo8FCRQtU9MJ/821QthY0HquCGLcir8fPuOluNwCj/7d+Qf8Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When CONFIG_DAMON_DEBUG_SANITY is enabled, damon_verify_nr_regions() is
called for each damon_nr_regions() invocation.  damon_veify_nr_regions()
iterates all regions.  damon_nr_regions() is called for each region in
kdamond_reset_aggregated() and damos_apply_scheme().  Hence it imposes
O(n**2) overhead where n is the number of regions.

Though the verification is enabled only under DAMON_DEBUG_SANITY, which
is not for production use cases, it could be too high overhead.
Meanwhile, damon_verify_ctx() is doing the damon_nr_regions() test.
Because damon_verify_ctx() is called for each kdamond_call(), the test
coverage from damon_verify_ctx() could be sufficient.  Remove
damon_nr_regions() verification.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 19 -------------------
 1 file changed, 19 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 9cde5b47b9585..265d51ade25bf 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -686,27 +686,8 @@ void damon_destroy_target(struct damon_target *t, struct damon_ctx *ctx)
 	damon_free_target(t);
 }
 
-#ifdef CONFIG_DAMON_DEBUG_SANITY
-static void damon_verify_nr_regions(struct damon_target *t)
-{
-	struct damon_region *r;
-	unsigned int count = 0;
-
-	damon_for_each_region(r, t)
-		count++;
-	WARN_ONCE(count != t->nr_regions, "t->nr_regions (%u) != count (%u)\n",
-			t->nr_regions, count);
-}
-#else
-static void damon_verify_nr_regions(struct damon_target *t)
-{
-}
-#endif
-
 unsigned int damon_nr_regions(struct damon_target *t)
 {
-	damon_verify_nr_regions(t);
-
 	return t->nr_regions;
 }
 
-- 
2.47.3

