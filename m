Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F570CD4F5E
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 06:29:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 971296B00A3; Wed, 20 May 2026 02:29:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85CC46B009E; Wed, 20 May 2026 02:29:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 578436B009F; Wed, 20 May 2026 02:29:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 33F6D6B009E
	for <linux-mm@kvack.org>; Wed, 20 May 2026 02:29:14 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D0FF5A01B0
	for <linux-mm@kvack.org>; Wed, 20 May 2026 06:29:13 +0000 (UTC)
X-FDA: 84786820986.07.83F99EE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 08B8E140009
	for <linux-mm@kvack.org>; Wed, 20 May 2026 06:29:11 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fuR8I19F;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779258552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rIvjFu8eu4Q0A0nJgGFhpNwMfwikQRRw8RbElJURXJw=;
	b=fPYFlHFLO4VmTrZ9lQ5Uow+ksDAnLmmX8y6ZWW/VHXquPGhbCa+MfVnAOxArRa4mSIVPKy
	OByxXb6g4S50PixlQ54MRiKKCiiV0oPCD4jusE+fJZQCc3t88vvotbfJz0MshqODWh1T9P
	PEX7ivTXhddhfa7kDdO76VuYO+F8oPM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779258552; a=rsa-sha256;
	cv=none;
	b=qLxvfVUm8ZbW7h/pCv4k9sHD/Ozti8jh3A3bYhzWDzkPtCstifzuDjJ3L8+5EFpeU6nN/9
	ORVEFpUY4ixzSOZX6JLCxW4ixujHxlAhNGmTb505J1xPETUlWgHRm2qCJE5oLsZTNyaTUt
	ZNGFBIJSQcV3mlXVGr6s4mWr8TVSkJU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fuR8I19F;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 56BEB405C3;
	Wed, 20 May 2026 06:29:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E737D1F000E9;
	Wed, 20 May 2026 06:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779258551;
	bh=rIvjFu8eu4Q0A0nJgGFhpNwMfwikQRRw8RbElJURXJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fuR8I19F1m9pBdxloxt++oH3Cw/RfslMTjrJIuPFZPCkIA+ctzcY+cGkpx5BgZBrg
	 SsfHRXNgQ2wQGOboEng6sT+dzzIH3iTfN7rLr2Zatnz4OmZ8nfTqdhSofXgzqlH+/E
	 BKTAQ18k87VNeALftQYI3Ds5O76u/srhki9HGhROLzeOaad/S48bZRrTh14MwUnqkK
	 VM72nOzjZ4k+rYK7DvuymSf8eyjz9c/MUwajeAgVLR/sKHcRCQcEjMBFmaETD2g5SL
	 5GQPTVPsoYSYmUhjR2RcibfveEkxSfB8GoquGH8BndzDt0NiOrOGhCVHvVMBpAF2VJ
	 rFcsnwuMkpVfg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 10/14] mm/damon/tests/core-kunit: add damon_set_regions() test cases
Date: Tue, 19 May 2026 23:28:42 -0700
Message-ID: <20260520062858.167011-11-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260520062858.167011-1-sj@kernel.org>
References: <20260520062858.167011-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 08B8E140009
X-Rspam-User: 
X-Stat-Signature: fgt51moftd4po8odjkinstg5wunwbdtr
X-HE-Tag: 1779258551-880182
X-HE-Meta: U2FsdGVkX1/pIsK6vwsMUPa46o/vpDloqYglIYQgg+cCWhal7mGC4UU7hP2i7kb7hExWvRhTGXonojJkLpS/EYc6p9pYT+2mOSoP9CDkVsXOggHiQyI3jAn9+WJQxY55f40ldGTPmlUNxgOk1+ncspe2C+dz0tWoxsBcRGRu7Wbcs2wESQiobJf0v9E1v9EvyLYriAt5rkQ1A/KzhkuZmixUTqH4YfcCCwqnY3LZuRwoedIqfD+GuYSJfHInmHZhzIVIWdLNFyJnOXswdYu5w0nQsnQDdXkb0LRC5hjtPkr7H4VTRVaPWSoqgSSfDVHEDaE9UJDxPOlyOy3wIAOnfHNL4+GOs/63OpAMbSIrcKFN5wf7wbWkXYEzBYAjzNl57xglAV3ISws+6z9PV3YvlE3qyl5KsF7Dy5ntM75Zyu9KvWSB8QgBkoyKnWR+EgvWrjd54LgCY1i72f9pQ6d+G+E8Bccw6cRa/Jp9zjNa1u4NhVdrcqBmetPDAZKsAg4D9P4OUGgsrRovns5pOPuol2F7hXV6N8cAB2U59KNzYa72Jp68topw2Zl4uJ+iXbngPVDHT6Pjh/nampBpkcPOGLAQ92RGUtVb3RaTbr/j2aMxOFyvFSgdF1NO9mBNyx6bwEoZXtIKa4o5MdvPmSsH+JXOQROhwU/Mog5D5CDnkEWaIDXCPXjs3hbzV4JH9/9i28HJE6LVHdRQ2ZmF6lDq/b2l9B7REyjhv1Y5SfV+RXnT1WBE+zS4YTqVv9r7mEgX9GD5laPdtaaxKq6vm/vb3OTxKfwk/o/bkzIVB+C6OyImy8Isz04K/Rs5ykqPK5illZo8MEBMJUGKkrRtiwRVQqCHsRz18a7pj/7OOeqjp8T4rkHKhyEds1dBkiMbyU0f+c9lmMUdqkzwvfpe83RRZH8iCHLPjlICr8civMPChSYfS6fDK9R9ReRSiiP+9T/r/+V7QEiTQ1CNgvDEJ6n
 nwulHiO2
 PfME8m2phsdDw1mZH1tsOTeVnuZ631mW4f97NMc+nuiFLqxKxkBCU/OHrjEWXUClXSqurMTVJWG0e96OUvQNuQp/n8seEv7CgACmbOTxxeP31YfF4etG1X07u4AOLqrgvmazlQL0BVNntgwtnW3BzOGfJ1+GmINbTZi/q5GkR5Q2bZThO0JOcUiMEomxdguhdY6WPqqaCa8pCAzX3Gi5sqMt7tpsMhKT8w2yOfXkRt53bRX/eIJ917Pd30bOTENIhss6KrNkQfW43XKcn0Kng+A10Sw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_set_regions() is one of the main DAMON kernel API functions that
set up the monitoring target memory region boundaries.  Implement unit
tests for verifying its basic functionalities.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 142 ++++++++++++++++++++++++++++++------
 1 file changed, 120 insertions(+), 22 deletions(-)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 866f716e5760d..1cfb8c176b873 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -390,41 +390,139 @@ static void damon_test_ops_registration(struct kunit *test)
 	}
 }
 
-static void damon_test_set_regions(struct kunit *test)
+static void damon_test_set_regions_for(struct kunit *test,
+		struct damon_addr_range *old_ranges, int sz_old_ranges,
+		struct damon_addr_range *new_ranges, int sz_new_ranges,
+		unsigned long min_region_sz,
+		struct damon_addr_range *expect_ranges, int sz_expect_ranges)
 {
-	struct damon_target *t = damon_new_target();
-	struct damon_region *r1, *r2;
-	struct damon_addr_range range = {.start = 8, .end = 28};
-	unsigned long expects[] = {8, 16, 16, 24, 24, 28};
-	int expect_idx = 0;
+	struct damon_target *t;
 	struct damon_region *r;
+	int i;
 
+	t = damon_new_target();
 	if (!t)
 		kunit_skip(test, "target alloc fail");
-	r1 = damon_new_region(4, 16);
-	if (!r1) {
-		damon_free_target(t);
-		kunit_skip(test, "region alloc fail");
-	}
-	r2 = damon_new_region(24, 32);
-	if (!r2) {
-		damon_free_target(t);
-		damon_free_region(r1);
-		kunit_skip(test, "second region alloc fail");
+	for (i = 0; i < sz_old_ranges; i++) {
+		r = damon_new_region(old_ranges[i].start, old_ranges[i].end);
+		if (!r) {
+			damon_destroy_target(t, NULL);
+			kunit_skip(test, "%d-th r alloc fail\n", i);
+		}
+		damon_add_region(r, t);
 	}
 
-	damon_add_region(r1, t);
-	damon_add_region(r2, t);
-	damon_set_regions(t, &range, 1, 1);
+	damon_set_regions(t, new_ranges, sz_new_ranges, min_region_sz);
 
-	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 3);
+	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), sz_expect_ranges);
+	if (damon_nr_regions(t) != sz_expect_ranges) {
+		damon_destroy_target(t, NULL);
+		return;
+	}
+	i = 0;
 	damon_for_each_region(r, t) {
-		KUNIT_EXPECT_EQ(test, r->ar.start, expects[expect_idx++]);
-		KUNIT_EXPECT_EQ(test, r->ar.end, expects[expect_idx++]);
+		KUNIT_EXPECT_EQ(test, r->ar.start, expect_ranges[i].start);
+		KUNIT_EXPECT_EQ(test, r->ar.end, expect_ranges[i++].end);
 	}
+
 	damon_destroy_target(t, NULL);
 }
 
+static void damon_test_set_regions(struct kunit *test)
+{
+	/* Initial build up on empty target. */
+	damon_test_set_regions_for(test,
+			(struct damon_addr_range[]){}, 0,
+			(struct damon_addr_range[]){
+			{.start = 5, .end = 15},
+			{.start = 15, .end = 25},
+			}, 2,
+			1,
+			(struct damon_addr_range[]){
+			{.start = 5, .end = 15},
+			{.start = 15, .end = 25},
+			}, 2);
+	/* Un-intersecting regions should be removed. */
+	damon_test_set_regions_for(test,
+			(struct damon_addr_range[]){
+			{.start = 4, .end = 16},
+			{.start = 24, .end = 32},
+			}, 2,
+			(struct damon_addr_range[]){
+			{.start = 18, .end = 23},
+			}, 1,
+			1,
+			(struct damon_addr_range[]){
+			{.start = 18, .end = 23},
+			}, 1);
+	/*
+	 * Holes should be filled up with new regions.
+	 *
+	 * old:       [4,   16)        [24,     32)
+	 * new:         [8,                 28)
+	 * expect:      [8, 16)[16,24),[24, 28)
+	 */
+	damon_test_set_regions_for(test,
+			(struct damon_addr_range[]){
+			{.start = 4, .end = 16},
+			{.start = 24, .end = 32},
+			}, 2,
+			(struct damon_addr_range[]){
+			{.start = 8, .end = 28},
+			}, 1,
+			1,
+			(struct damon_addr_range[]){
+			{.start = 8, .end = 16},
+			{.start = 16, .end = 24},
+			{.start = 24, .end = 28},
+			}, 3);
+	/*
+	 * New regions should be able to be appended.
+	 *
+	 * old:       [0, 4)[4,    17)
+	 * new:       [0,       15)     [25, 40)
+	 * expect:    [0, 4)[4, 15)     [25, 40)
+	 */
+	damon_test_set_regions_for(test,
+			(struct damon_addr_range[]){
+			{.start = 0, .end = 4},
+			{.start = 4, .end = 17},
+			}, 2,
+			(struct damon_addr_range[]){
+			{.start = 0, .end = 15},
+			{.start = 25, .end = 40},
+			}, 2,
+			1,
+			(struct damon_addr_range[]){
+			{.start = 0, .end = 4},
+			{.start = 4, .end = 15},
+			{.start = 25, .end = 40},
+			}, 3);
+	/*
+	 * New regions should be able to be inserted.
+	 *
+	 * old:       [0, 4)                      [42,    52)
+	 * new:       [0,       15)     [25, 40)    [44, 50)
+	 * expect:    [0,       15)     [25, 40)    [44, 50)
+	 */
+	damon_test_set_regions_for(test,
+			(struct damon_addr_range[]){
+			{.start = 0, .end = 4},
+			{.start = 42, .end = 52},
+			}, 2,
+			(struct damon_addr_range[]){
+			{.start = 0, .end = 15},
+			{.start = 25, .end = 40},
+			{.start = 44, .end = 50},
+			}, 3,
+			1,
+			(struct damon_addr_range[]){
+			{.start = 0, .end = 15},
+			{.start = 25, .end = 40},
+			{.start = 44, .end = 50},
+			}, 3);
+}
+
 static void damon_test_nr_accesses_to_accesses_bp(struct kunit *test)
 {
 	struct damon_attrs attrs = {
-- 
2.47.3

