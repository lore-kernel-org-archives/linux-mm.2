Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D7CFC88E73
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 14:24:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54EFC6B00AB; Mon, 14 Sep 2026 10:23:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E04B6B00AC; Mon, 14 Sep 2026 10:23:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C79E6B00AD; Mon, 14 Sep 2026 10:23:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0936E6B00AC
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 10:23:41 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 97022A3BE1
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:23:40 +0000 (UTC)
X-FDA: 85212586200.25.10CD875
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id E1FD5100005
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:23:38 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dh500tXi;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789395819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nqfaQq4DYDAwDcS6eX/vnZ8ZZiveWwkFxlbgk1mGGIc=;
	b=w0hDJNSHmkGw/lgMMQkR3jD43p7gxT6JCqZHolwdTNllyF7B0Z26JWdxkmuduuqza64wZ4
	BIPg5ADE8aGJMgeSYha0kETtQKnC/vEnY9cg5niYtYENSJfg7Hts4dEG+7ioTaC3OUdvxI
	1g5W8NSutAGck/EaGGzCJFElDYMTo8s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789395819;
	b=NShJOa7WC/SZdkZ0Rf+Ce96C+9k4Q1AXqtFwdSRkfbjXHBwIvr6hVIMDWfDoosrwDgGtOR
	dbw011DrQBPIEM+KLSTv5Ub3BGTqSDYiiqoU5eRdZ26TiP7Hbl6ZSzs7yyqO0tf5QkwyQ1
	aY2eeR/pIVvWzptXHjoNgFYHjwXndS8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dh500tXi;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CFD0D43D84;
	Mon, 14 Sep 2026 14:23:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F3481F00899;
	Mon, 14 Sep 2026 14:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789395817;
	bh=nqfaQq4DYDAwDcS6eX/vnZ8ZZiveWwkFxlbgk1mGGIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dh500tXimlxoBgg5rmkLqh2JXQwAtfrB2fcHhfvhYra2wqHmzL6zZ92B2oLiF2bsc
	 uzfShF5jhQ4mZaR3Q5gRxbyoIwm896GC9ssfXY3VckSlL/3oq/5ySY8ttzU8XIPeTw
	 imK4yl26UHt5hfSORx/4fWGJnlUA0QY6IoV0forPtiK2tbRqPVVItsTJpwqGNXZvD4
	 hupCQOCA43vaa9sqpeoPZMMxmLynbWnQcRdB3yBVl7x7sqv2pvDMwTfpnqVVu3/RvZ
	 glMsKbsvjQePceor5rfYl+xzGxK6Eh/LtajRzUwTvwOGEEHYyxpqn2xM9aRDYuqyP+
	 GP4fpcCeegnuw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 7/8] mm/damon/core-kunit: extend damos_commit_filter_for() for wrong input
Date: Mon, 14 Sep 2026 07:23:24 -0700
Message-ID: <20260914142327.92510-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260914142327.92510-1-sj@kernel.org>
References: <20260914142327.92510-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: unxqdgjiqe9rgf9bc9cdx9p7umg55hmj
X-Rspam-User: 
X-Rspamd-Queue-Id: E1FD5100005
X-Rspamd-Server: rspam03
X-HE-Tag: 1789395818-889052
X-HE-Meta: U2FsdGVkX19xqpHdlcbF1SEZy2CNySTfTquZ/ptI3LX9myeNvuT6ZwPEjtxaVvzdX0aBegP9TzbNeLTZqOvSwtgukx8jsXkX8XOG9ONebf0jknh7lp2zIfzx9qQoB4VP7SidPhLaAgAGnAxoVRpk1N+wNUw0BEQv/68h1ETUaKJ5eaMzFynH4iBpEHwxmMlsuYW5Lp3v0GhcVLVelrgt39pGBoYG1z4y4gsABgecnwgvze+8WVSDCIbOLt329FUiQfRfkgtREiaJJj1CMoUx2aOjQ5F7ZgOtYEvy0gK73/PJHgUd/02PRw2/6N5UObq07A3vHr8bjFohHOTf+gQ1oB8OAGviBCLrqRuI+d5DYmvFVx0QCA3+eudSF7B2lsUTCc/bn01XAdCN1WjRgu49+nFwNgayhbKOxZuLJ+zSXFgFFzQ2NCTGMJxKLvp2FfUB1+nBBbtS2AZQmX4IpCObovf+VdXaLrHGYY8bmXeN+DWixpwy6Bu8gXHkv0k8HJlFKuv67KPdtunS/lKPAqoLTk2BNK3PlbrElT+NftZ/I7RXs8Th2wzax2FNB9xmfIcXKyM6BM41dgf9TjGTQgc+dDyY6GzsXQpBt7hDlnM4sOnHCFP33kwkGIjq7djcuAZdcGvrd8XVblOlvGlm+aBZkQH7UMoths26qT1pzEO6TXGZA3+Snr1q33eV4GqPPsjybKW9qd24DcL4zUGR7YPg+nqdGVE+sCjNS+J1dnFlyn2G7WMve2hUAfzLxIa7FXAiqYuF3cQy5Hn1BbvglM2SW9Lb+R5XgL0fLDjzAUkVnsmrlSXPRb2ebkJRNEQdKlZ+v+u2hY/OZ4mLRkExV4wlded6+2HO73IRIZ0R9rgltJb0L4pd7AIWoeKW+Ygk7/ZZNgPc+mzGpk1PnFSultWCgsCOOamMoWszDjqw6QB3B6sd2VjBPFNE3VJbZ+t68Jx01SKbbs/YZxMuf7hfHIp
 HxvqQl2l
 K45vDVqW1LTEHoSu6y03BQkfj6htborBQ8nJPE+hwC9NIFnD/R0zYbaXd667s4IbeOHUrCjIXqiJUWinxLtDDyNf0ify9zc4ftqV3Op/tkD/zvA9frGaR8m4lSsugNJknMwdXu0rB7lGrIHGrBHrGl9VTLbyCKxFqktbdcLAdvKW4Qv/W3PoDxBvg96PhfFpsyqBrEfEKG9BOss8PjM41pR7/KE0bIPoGNieiosB4UfYv4rxBCIGOHR/52NXSodYhBT4kqpLMsa9bi9CVj5hr8IAw7w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damos_commit_filter_for() supposes damos_commit_filter() to always
succeed with given inputs.  damos_commit_filter() could return an error
for invalid inputs.  Existing callers always pass only valid inputs, but
they may pass invalid inputs in future, for test purposes.  Extend the
function to be able to be used for wrong inputs-caused error testing.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index a47a5cdf285c8..c9941f3bfb42b 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -1127,9 +1127,15 @@ static void damos_test_commit_dests(struct kunit *test)
 }
 
 static void damos_test_commit_filter_for(struct kunit *test,
-		struct damos_filter *dst, struct damos_filter *src)
+		struct damos_filter *dst, struct damos_filter *src,
+		bool expect_fail)
 {
-	damos_commit_filter(dst, src);
+	int err;
+
+	err = damos_commit_filter(dst, src);
+	KUNIT_EXPECT_EQ(test, err != 0, expect_fail);
+	if (expect_fail)
+		return;
 	KUNIT_EXPECT_EQ(test, dst->type, src->type);
 	KUNIT_EXPECT_EQ(test, dst->matching, src->matching);
 	KUNIT_EXPECT_EQ(test, dst->allow, src->allow);
@@ -1168,47 +1174,47 @@ static void damos_test_commit_filter(struct kunit *test)
 			.type = DAMOS_FILTER_TYPE_ANON,
 			.matching = true,
 			.allow = true,
-			});
+			}, false);
 	damos_test_commit_filter_for(test, &dst,
 			&(struct damos_filter){
 			.type = DAMOS_FILTER_TYPE_MEMCG,
 			.matching = false,
 			.allow = false,
 			.memcg_id = 123,
-			});
+			}, false);
 	damos_test_commit_filter_for(test, &dst,
 			&(struct damos_filter){
 			.type = DAMOS_FILTER_TYPE_YOUNG,
 			.matching = true,
 			.allow = true,
-			});
+			}, false);
 	damos_test_commit_filter_for(test, &dst,
 			&(struct damos_filter){
 			.type = DAMOS_FILTER_TYPE_HUGEPAGE_SIZE,
 			.matching = false,
 			.allow = false,
 			.sz_range = {.min = 234, .max = 345},
-			});
+			}, false);
 	damos_test_commit_filter_for(test, &dst,
 			&(struct damos_filter){
 			.type = DAMOS_FILTER_TYPE_UNMAPPED,
 			.matching = true,
 			.allow = true,
-			});
+			}, false);
 	damos_test_commit_filter_for(test, &dst,
 			&(struct damos_filter){
 			.type = DAMOS_FILTER_TYPE_ADDR,
 			.matching = false,
 			.allow = false,
 			.addr_range = {.start = 456, .end = 567},
-			});
+			}, false);
 	damos_test_commit_filter_for(test, &dst,
 			&(struct damos_filter){
 			.type = DAMOS_FILTER_TYPE_TARGET,
 			.matching = true,
 			.allow = true,
 			.target_idx = 6,
-			});
+			}, false);
 }
 
 static void damos_test_help_initailize_scheme(struct damos *scheme)
-- 
2.47.3

