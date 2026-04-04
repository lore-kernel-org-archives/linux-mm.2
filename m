Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF1E9E63FE6
	for <linux-mm@archiver.kernel.org>; Sat,  4 Apr 2026 16:40:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 815306B0093; Sat,  4 Apr 2026 12:39:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E0EB6B0098; Sat,  4 Apr 2026 12:39:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CE066B0093; Sat,  4 Apr 2026 12:39:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 546D76B0095
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 12:39:59 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 057291603D9
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 16:39:59 +0000 (UTC)
X-FDA: 84621435318.07.609CD2A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7AC6EC000D
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 16:39:57 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Qao+zlqE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775320797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FZKTp3i+BsG9t1vwJVgwplb54eYNxc8OgxjqA6xomhI=;
	b=dSO3GbacYRk7XIWV9xQOuaPXsYLSq4ufNfcVe2od64iIKixoLAdrgujyCqSLaEJKUfbNyi
	my6EihTov9LULAOjbJi+nTxtGrqy0LGtBjLS6DqqdI4cFb65vxsnnIYDQrOjjX0JAyV9bM
	rwkqo1tjs5qIvxr4l4nIc75HSJpzP70=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775320797; a=rsa-sha256;
	cv=none;
	b=u3YUVedqhO2fI8uJ5O/sm9gOdePwPhWLUhYI9tAHtu7X6zxH2qwJTbU0PG+zFy8i63gSFv
	9h6CW+tG6n3Ux7+AWyvJIGr8VBuPfubB2XFyfMR7GmfRZwjcv5T97OZig+APV3BB7VI+Zl
	qNnh8F4y/laA5Aytqa2TCgxpDTptcKA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Qao+zlqE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EE88760126;
	Sat,  4 Apr 2026 16:39:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5847EC19421;
	Sat,  4 Apr 2026 16:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775320796;
	bh=b4CXGO6BtXvCfJCLfnWiBdtEE+beFehwNMWLSu4Nq0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qao+zlqEWV9F2q0IEVtzTXnMp+hsLYhkJsfLY7Lw6VwDwLfxub4N9+Hbr6CtWkv5C
	 KsMrIjvKAQr5aa2X04R6FmYuB5mE5sJTZkTTAwdIKLM86b4utjrMVYp4K/CEmbSP68
	 PvZcybMJKQrSb8c9yaQLc6yoQGniZ5y9smTvwgESB++vise5+u344cnSBJ6BaAA/1F
	 H40fCHq5P2lkP182YUVsrVsCTU9pNCaqG1TjDZzednK4skOxBNTPYCcPZheIOB7ziG
	 0+V536TSC37LkHY8zlN7Gi6gGFBH2xxECO7Xg99seqrGGmKiH0S4htDgh5qUUCz0na
	 CZZrtBH74Sx4g==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 6/9] mm/damon/tests/core-kunit: test fail_charge_{num,denom} committing
Date: Sat,  4 Apr 2026 09:39:36 -0700
Message-ID: <20260404163943.89278-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260404163943.89278-1-sj@kernel.org>
References: <20260404163943.89278-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7AC6EC000D
X-Stat-Signature: 1pd5hec1ujsjfpwb1kh11n79j3d6d5we
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775320797-779500
X-HE-Meta: U2FsdGVkX1+Qrbu2OEGoKtKj7ND0DznqPLjrFyrPTSLJWCV4eceKU3Ed8t1agDiXBOBO1u42EBDB9ePEVhQNd0gMENo7FQkI63KGeXtHIsB5C+JIh9bqNBO0rP/RcQyBcG25kZ4D0UAP+TMXW7J+2Gjkvg2N2jDFl0TVqUYT9wQifA9p+9aMjrsO8v7bKqPglJYXlhKp7O0815ZDxBQZ9NM2Rp5LH2X5yvUQr76TbcgjMRLJ7Y4IvexJ9sxTaqHBEfu0HUQd6RzCckwbKAyhCaOL+DAELKOcNJh9nKmq3F0KiVbq3V2DxsTWGZjlZALVVgxZR5VMcvx+fcMMy6IJmHxRzf9QCVleyceex9ZFodARrnEkv6AGx2skHbPNJM4koBxCRimLALCwWAV/Wn82HlS04Fc2kFhLAyYXzl9+mk0Uz3u1PxKL7JEnaOlE+w+NqNPR/fvJ8rTVNv2Aei1YzrwxNfVDczp1s6X6y/HV1knr6FkH2/sE9k7kbu2CCjcVBqPS8Al7Ql/gweJ5LxYQpf7qDaG9G0Js9TQbAnEQdrsbFjeEXW8VGvEvVdOopw+I8s6Yc9SOycxi3xOxuYeXVzPLejhosCA8iXVRHd48Gk51W+J0+vAt1ufINIIdPyogGdvGG/JqgWgHJ3NFkaLvQfLU0ZraA68WM3SiFxtsqeVqayQjZWcq9hi/A174cftxwZ+AJ/mqif8a6qTdvmEi8V712UbDuXN7CHLtW6Pnq8/IrZvjGXYfaYdunvnABmrzaWU3Jzju8Gvzs8Zb99YDZJoEG1mErj2vtd/TQXiqsTMhTnx8y8fPe5mYHHHt7zUy5u/shgH9MXGYnXCT6MMm6nnFJ3tzOXH393WgJpGX1dn7CPrlFCx1K8OybZjuFGlLGqu/fRT4DEifSaRV9hG3V2SuI4nkV9Sl7V4rTvo63D6v7jn8NRxCO0lU59Xgg3HGX+Aj8drm2v5V2AStqno
 ivoLR1cf
 8YINjjOhk3+r3j06x3RTWgnmhzHI5zxBJXNWnkqlVB0NmlpVNl8+69Y96PDZ8VRdP7QCgRYvn9IZWL9F5cXQkEXeNnIDW8Y3Q89i1YXRP7AFsmVqPOIymRcPAgMkLkCfejxivsTbm8bdEfqZE9l8ZD7UX0vfsKevSLdo8HeHVdsyearR8Aw/bdxym9rs4ap0H6+r6Rs4loKeW0nVzXm57AxAF/oMnyw4i6o5L6Q13XH01wTa9CEt5Y7s/VdOoN26dVSttBl8D8si1b9/36mvaho2JwQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend damos_test_commit_quotas() kunit test to ensure
damos_commit_quota() handles fail_charge_{num,denom} parameters.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 0030f682b23b7..16f68315ba119 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -694,6 +694,8 @@ static void damos_test_commit_quota(struct kunit *test)
 		.ms = 2,
 		.sz = 3,
 		.goal_tuner = DAMOS_QUOTA_GOAL_TUNER_CONSIST,
+		.fail_charge_num = 2,
+		.fail_charge_denom = 3,
 		.weight_sz = 4,
 		.weight_nr_accesses = 5,
 		.weight_age = 6,
@@ -703,6 +705,8 @@ static void damos_test_commit_quota(struct kunit *test)
 		.ms = 8,
 		.sz = 9,
 		.goal_tuner = DAMOS_QUOTA_GOAL_TUNER_TEMPORAL,
+		.fail_charge_num = 1,
+		.fail_charge_denom = 1024,
 		.weight_sz = 10,
 		.weight_nr_accesses = 11,
 		.weight_age = 12,
@@ -717,6 +721,8 @@ static void damos_test_commit_quota(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, dst.ms, src.ms);
 	KUNIT_EXPECT_EQ(test, dst.sz, src.sz);
 	KUNIT_EXPECT_EQ(test, dst.goal_tuner, src.goal_tuner);
+	KUNIT_EXPECT_EQ(test, dst.fail_charge_num, 1);
+	KUNIT_EXPECT_EQ(test, dst.fail_charge_denom, 1024);
 	KUNIT_EXPECT_EQ(test, dst.weight_sz, src.weight_sz);
 	KUNIT_EXPECT_EQ(test, dst.weight_nr_accesses, src.weight_nr_accesses);
 	KUNIT_EXPECT_EQ(test, dst.weight_age, src.weight_age);
-- 
2.47.3

