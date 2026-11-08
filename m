Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DACAF606A326
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 19:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bCCmMKr9
Received: by kanga.kvack.org (Postfix)
	id 47ED86B05B6; Sun,  8 Nov 2026 14:51:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40F8D6B05B8; Sun,  8 Nov 2026 14:51:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F7D26B05B9; Sun,  8 Nov 2026 14:51:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 000806B05B6
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 14:51:57 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 81F7F1C3CFC
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 19:51:57 +0000 (UTC)
X-FDA: 85412997474.28.762CC47
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id CAE7F80005
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 19:51:55 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bCCmMKr9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794167516;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nyCIxBA5mJ06vHi0FAU5PamOp23wz03gHLUhBxnc4Z0=;
	b=wZfhkoL/dUQoz5q+cOXNIJ6dhJueQZTdkBZR9+mT3/eMEoxNsz9Vo7EKceg+XiAzg4chTD
	QnWxPQncCMf2nvLjl7Cgm2Hse6t+Oer9l51w18Wyn9EX1oK36ZY9lY2tRmPVSryo29Tdzs
	MyXrMRyWvapTMPvbs3TJcy+HF51Lsqg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bCCmMKr9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794167516;
	b=ief2JsqlvAceyJuj1SYbH+Sd56p1chfPWV2bJDtFEdyfyuUGGxtA+cnP9RVKBbCRPqjlff
	TOCDR1IO/fKiRKSXki2AXYdVITIRnkGvUdKGsxJCJtI2MSShxheSQCTBa+JZAj+OXx7Qw8
	9YunhzEQhwYLaZmbD30N65QK5T3wQ2U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 28917448BC;
	Sun,  8 Nov 2026 19:51:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1E731F0089F;
	Sun,  8 Nov 2026 19:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794167515;
	bh=nyCIxBA5mJ06vHi0FAU5PamOp23wz03gHLUhBxnc4Z0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bCCmMKr9mWEtSu9yXIOOi9024KfSuJI6gvjZHyavY7QB+O+I5HT6h5lfD175ScXRy
	 iKq6I3GjHY7l1fFMTudDAafB99NVtgyuO4gOEFAcM41RCPulUtCeufn+F8TOHyxl51
	 F/RclWBx0uvEn6g5F1DF52S3wizQ6A+1tvT53g99Em98W9123aIX+YBv/QBejczDQ7
	 XLJNJHy/+sp1ATuOVr2k/YDEptTrKVl+8wnnqQKP05P5Ac/47PHjk67fGYEzldFw7W
	 HIrgmsFRAoLKKJwtLTN8S+4+qPNUc/Mk7ToW/4gxoaWTOLA8VYNTv2YZPjNCnmSxuB
	 FwpePQint3PPA==
From: SJ Park <sj@kernel.org>
To: stable@vger.kernel.org
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 6.12.y 4/5] mm/damon/core: filter out damos address filter-split failed region
Date: Sun,  8 Nov 2026 11:51:43 -0800
Message-ID: <20261108195145.115792-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261108195145.115792-1-sj@kernel.org>
References: <20261108195145.115792-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CAE7F80005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: ytfqpga7cbqhwhmhqyau3rz8xyddxyhh
X-HE-Tag: 1794167515-911895
X-HE-Meta: U2FsdGVkX1/kgk+DcXUSHVakRg9AXdsDix6Zyyi/QSsN2PSNVOekwk8LnzqFBBYAxPiNBtV4IbU6HoItfpt+fmplXkSBUBYA5Uc1lMf3+maGcUfsidr/VdiC0GBkfi53pPPNxTvl7jUIkTbjRYSp3t+rP17lN8ZwNBhirOxkyPeXhWLCxsfgXzXtspYBleQzIlMEAE/7cBpKLEiNFUNqorUIxg5lEngah+RQ5vnkaj4XlPx4NbhAU8fTB3vrO1HaVLUVBESFP0tkSf5mP4oQZfJMGkJVfEnZtbGUUBcmLnCLHMVMskBXKpv1Z8Ug41+LZZkv5MHvByU8/ZOHv7q3Ngr4NdfnZuIU9+QScE7whJ16N/Xo0ksXShz/Ku0ZdWPohTW9xrVNWsSVDWKENF/tnpnuD/LLqQkb3pp5aK9pt82Hk1eCgkRN1O22aizdtLWidAlbYstTS/q/oc+SgTRWwiUoc1IAKshst5YqFJOdLOz2hhzz4w6X7jLnfflVBCVaTHhQRkUriws5mlTMMQmYiTfWhXFyW2gukDSFG7vNrtUrLz6Z/gbsRqgVZKDMseo0yjgWADeCsat7yVcSSk2tyf4zLtzG9DNee+wGNJTfLN8EtrF4gXoyPC1Zoo8i+TepYOqVKJaARBN1R6x+Vk2t8+Kc1gl4uwfzZ4t49j/ljw9t9eC9Pgo4oOvPyiLov+HrqsmvlRKJ6vl8d5Hq/yNl5OT/KXDgQAAjBaLeZK9eepCowYc4GUbnNn5TQ7qIpjJwqPX5f0GixJjZpWIpduFir+2/oaDshIslEKxpqNxGLCCc4B6Ow7lk96tNLDHAJQFJt1Kugs7lp+lFjTHD00Djt3NLXZ8gQHo2K1cnDC0X4FEjSNb6dkB+hYdL1J5JoPwlFlV4NLbcPH22UhKHYZSF9GbkRI1vgWl2pT/zmTew/ur1b9kOpArvM7Q6A4Pohav+HCB5qXbbzC6t8dQPYEL
 kcW9iqnv
 jUPZ2THbaPmSRrjJwocw7MYOo4GMOqiN8OoyFgRyjuiZcBi2Q+FXDYYb3fTIntTNya+7aeXmn5lDYkkqyzLNtHnAQ0swzoKzphkp5QQSvjZMx2nVjHQPdyrmcfLTJR37oB1lvDBweb0J8U/dS1jhaFhRdQj8UqP1tWjlwpEK8lNz8YmKt/YqSgcXkRDvaNLY3eRd5rtbQ6yZLwJFrKFjFnzD0xTq+CLBNcP3qMwsIysfFGzX3mRLj+P866UbrPjJ2z/+ffpLNrjaWq6xlyYoYWbagg0iSl3YUCxe8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When an address type DAMOS filter is configured, DAMOS tries to split the
region for the filter range, and apply DAMOS action to the filter-in
region.  The split operation (damon_split_region_at()) could fail from
allocation failure under extreme memory pressure.  In the case, DAMOS
action could be applied more or less than expected, ignoring the address
filter.

The issue only rarely happens under extreme memory pressure.  No crash or
leak happens.  Occasionally not applying the action to a few regions
shouldn't be a real problem.  But applying the action to a region that the
user has excluded via address filter could be a surprise depending on the
use case.  It is only theoretical.  No such real case is found yet.

Filter out the entire region if the split is failed.  Update
damos_filter_match() signature to receive the error from split.  Also
update kunit tests for the updated signature.

The issue was discovered [1] by sashiko.

Link: https://lore.kernel.org/20261020004119.106690-1-sj@kernel.org
Link: https://lore.kernel.org/20260801203121.117449-1-sj@kernel.org [1]
Fixes: ab9bda001b68 ("mm/damon/core: introduce address range type damos filter")
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: <stable@vger.kernel.org> # 6.6.x
(cherry picked from commit bbeec2d8324d7aac438bb12dd2d22b184e0a8d43)
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c             | 13 +++++++++----
 mm/damon/tests/core-kunit.h | 11 ++++++-----
 2 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 52f01a6508b66..046c07b86a6e7 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1372,13 +1372,14 @@ static void damos_update_stat(struct damos *s,
 }
 
 static bool __damos_filter_out(struct damon_ctx *ctx, struct damon_target *t,
-		struct damon_region *r, struct damos_filter *filter)
+		struct damon_region *r, struct damos_filter *filter, int *err)
 {
 	bool matched = false;
 	struct damon_target *ti;
 	int target_idx = 0;
 	unsigned long start, end;
 
+	*err = 0;
 	switch (filter->type) {
 	case DAMOS_FILTER_TYPE_TARGET:
 		damon_for_each_target(ti, ctx) {
@@ -1404,12 +1405,13 @@ static bool __damos_filter_out(struct damon_ctx *ctx, struct damon_target *t,
 		}
 		/* start before the range and overlap */
 		if (r->ar.start < start) {
-			damon_split_region_at(t, r, start - r->ar.start);
+			*err = damon_split_region_at(t, r,
+					start - r->ar.start);
 			matched = false;
 			break;
 		}
 		/* start inside the range */
-		damon_split_region_at(t, r, end - r->ar.start);
+		*err = damon_split_region_at(t, r, end - r->ar.start);
 		matched = true;
 		break;
 	default:
@@ -1423,9 +1425,12 @@ static bool damos_filter_out(struct damon_ctx *ctx, struct damon_target *t,
 		struct damon_region *r, struct damos *s)
 {
 	struct damos_filter *filter;
+	bool matching;
+	int err;
 
 	damos_for_each_filter(filter, s) {
-		if (__damos_filter_out(ctx, t, r, filter))
+		matching = __damos_filter_out(ctx, t, r, filter, &err);
+		if (matching || err)
 			return true;
 	}
 	return false;
diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index ff9f73579f7b3..6b7cd8149a0e2 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -527,6 +527,7 @@ static void damos_test_filter_out(struct kunit *test)
 	struct damon_target *t;
 	struct damon_region *r, *r2;
 	struct damos_filter *f;
+	int err;
 
 	f = damos_new_filter(DAMOS_FILTER_TYPE_ADDR, true);
 	f->addr_range = (struct damon_addr_range){
@@ -537,25 +538,25 @@ static void damos_test_filter_out(struct kunit *test)
 	damon_add_region(r, t);
 
 	/* region in the range */
-	KUNIT_EXPECT_TRUE(test, __damos_filter_out(NULL, t, r, f));
+	KUNIT_EXPECT_TRUE(test, __damos_filter_out(NULL, t, r, f, &err));
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 1);
 
 	/* region before the range */
 	r->ar.start = DAMON_MIN_REGION * 1;
 	r->ar.end = DAMON_MIN_REGION * 2;
-	KUNIT_EXPECT_FALSE(test, __damos_filter_out(NULL, t, r, f));
+	KUNIT_EXPECT_FALSE(test, __damos_filter_out(NULL, t, r, f, &err));
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 1);
 
 	/* region after the range */
 	r->ar.start = DAMON_MIN_REGION * 6;
 	r->ar.end = DAMON_MIN_REGION * 8;
-	KUNIT_EXPECT_FALSE(test, __damos_filter_out(NULL, t, r, f));
+	KUNIT_EXPECT_FALSE(test, __damos_filter_out(NULL, t, r, f, &err));
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 1);
 
 	/* region started before the range */
 	r->ar.start = DAMON_MIN_REGION * 1;
 	r->ar.end = DAMON_MIN_REGION * 4;
-	KUNIT_EXPECT_FALSE(test, __damos_filter_out(NULL, t, r, f));
+	KUNIT_EXPECT_FALSE(test, __damos_filter_out(NULL, t, r, f, &err));
 	/* filter should have split the region */
 	KUNIT_EXPECT_EQ(test, r->ar.start, DAMON_MIN_REGION * 1);
 	KUNIT_EXPECT_EQ(test, r->ar.end, DAMON_MIN_REGION * 2);
@@ -570,7 +571,7 @@ static void damos_test_filter_out(struct kunit *test)
 	/* region started in the range */
 	r->ar.start = DAMON_MIN_REGION * 2;
 	r->ar.end = DAMON_MIN_REGION * 8;
-	KUNIT_EXPECT_TRUE(test, __damos_filter_out(NULL, t, r, f));
+	KUNIT_EXPECT_TRUE(test, __damos_filter_out(NULL, t, r, f, &err));
 	/* filter should have split the region */
 	KUNIT_EXPECT_EQ(test, r->ar.start, DAMON_MIN_REGION * 2);
 	KUNIT_EXPECT_EQ(test, r->ar.end, DAMON_MIN_REGION * 6);
-- 
2.47.3

