Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 567E1CD13CF
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 18:44:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BD7F8E0002; Tue, 11 Nov 2025 13:44:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 248398E0011; Tue, 11 Nov 2025 13:44:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E7BE8E0002; Tue, 11 Nov 2025 13:44:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D508A8E0011
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 13:44:30 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9589D1401A4
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 18:44:30 +0000 (UTC)
X-FDA: 84099201900.09.E4A03D3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id F2C09160006
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 18:44:28 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EOcGp6yY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762886669; a=rsa-sha256;
	cv=none;
	b=0J5uN3LAS3q8zTZja4WUt4r++S05IvC4iW3HJU6FyESzrUYMhEmjD2ODzu2gU0TP8z28xj
	Ym5rFn9Z7ZDuvYUAZhuL/dGsIYtnsId8f5MRwMJt0ZFnL8fhlFniciNNv75XCqGS9SABwp
	c9oz7DKnTURmXZt98KF3ZF4+zuTysz8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EOcGp6yY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762886669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tIW4yOi2mYrsvfYYz8B3ejPAcd8LvYBVN8qqXRZeE1Y=;
	b=7ctSI12bwcT2umSZbhTY1/8lYzaoKGR8sCfw6bDkXLRelUmbDzdpy+HvWYKq60X/28mIKY
	uQSMdyTVLpxAjP37P+MWrjfYWYWNzNOzjaMTRGx+BkR1yG/X0usNmVeufIYFKzw2YRMLbx
	Whq5fRIUbuEJevqUpaJEyfbYPxnZFt4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 27648446D9;
	Tue, 11 Nov 2025 18:44:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D320FC4CEF5;
	Tue, 11 Nov 2025 18:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762886668;
	bh=bWfWODgDizfceoDSDsQvR25at7fdp8OVsfqGkOutAqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EOcGp6yY2aQatoc9Pf+0VGj8G7nF6mD5WtOgX1LI7HrKoGF+J5uDarPUUvNpntots
	 HO/A1rcMkU4gGomxfPV5O+QRdCwTBJhTOP2WAXYYCR1gBO0ujStAlusyiV3pHsEwHU
	 3huE/rA5fZ1sEbwMv+FkhBth8xsfxDg541I+XVotUHN4AGXeFMGVi1o51QFXwnMxc0
	 tIpelBNbkZwejQdLyv34q+zBFICZzjjmNOfrOPiCYb/2KUl++VDsvlkJbIKud3MgTe
	 hO1e3gy5yqcQNJ3AXl8DxUHNfD9LQCPDRZkp+eRLtb4H0k13FyEUTz82KCc41PaA4o
	 mKIRxMI6muc9w==
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
Subject: [PATCH 04/11] mm/damon/tests/core-kunit: add test cases to damos_test_commit_filter()
Date: Tue, 11 Nov 2025 10:44:03 -0800
Message-ID: <20251111184415.141757-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251111184415.141757-1-sj@kernel.org>
References: <20251111184415.141757-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: F2C09160006
X-Stat-Signature: 3bmsirn9ytzbbaymkwn8cxujaq9n4wx8
X-Rspam-User: 
X-HE-Tag: 1762886668-748953
X-HE-Meta: U2FsdGVkX1+8Ksu7IWV9JqAi88cHSxLn84hKk9j1SK18XdvZbzEEyqKmJusi5Xin0nUnKwzBO1EYlhN1M9Px9bFc6JFoMXQHvUO13+kwXbpVin1FLfb9o11VA7LulLmxQ3MLsjbBC2M7JBq73PwpTp3f5GnXnsq1qUFkTbZ2H6So+hbinCJ5J1xepiFFmGM1IzlOa5jswihfPJTgGX8Ww7leRdR/72cJVIeK7qtQt5H0O200l0KWx31rOcz6VH+dZEYGnr5KlRXq7iRQQ6ZLFwYydzN8zkJjuT1c4+Fg3kmj2seGcOIodnzhbfMQcp1Yiuy8vP1ai6o0h5YUIOcox6zX3D2TW8x/LI65VG1PHYaHx2rMww935COPctwxQWKuXHCWYNkpM7+Z/sDdUW72zjytBPVMd09WkN1z7K0oN+OarI4/omews5LznDMrKtL00kwVJ+NOKJ8phlkShqOAIdw7omVc8E3D5Ys3KMKl4ph/Zr2CBvZ0hwxUBAfYVrCTUuwUZo98saXNJvwsn71cdGoEK0dweCurNO5l1xCwU/YSXCgPIpL/Ns+yrdJFvPEzGbcr7M1pOUqVCnlErQyKZLulisBHwnuthn8PXALlNVmH88Q3ZxUqb/Yf3yxMpN26VYUKAooChH8gJikN/iHk05lNvzdZY+xk+lVfcwMItzT2O+Uw/NrdBHPpT6+STzbER+ob0hNiMhhEZVPo2cQwgcsgQNihmzQp35wcOmkx+cnlC9qUrqQxKfBfj4tkv7q1AJiepkcx2hodwH+4lJPfxfxagTdbTciBMeoyC4uJIIBHeUxipJg5ZTc0cVcIqNdQ2r32kvhxieyiWEXvn3GGWAjbql6i0pewUiB0X4DVboOf+nU51EHLX6/cfpGiK5xx2J0bO9tYWsXzFxIrh246g2amr+2LVqoGEO6hIYSyLdSc6OsR9Jr/byqUwQ6qi5xEJo22xMH93/rF/3AXWMy
 moQk6BPY
 qj/Nv9gcg5RxGwN2n8RnPtOJUPUrWKr9F73TUNS4Tf8uJn7YpzzxDreFcYo/sIGGhZuRaFYZGmXRMR3CRB1JrDiykBD/ttjwOSP6r5lZ/9oSREm77dFza7nRPBgVJ7LdlX6UPyZZEIrGMP1Xv4Z+SgCnbNqop5EazqBAc0ZVQA2coEn/t64XM+Bwazfwh0FHM+Z1wHHgBEo/jpnY9iBmKTh1EVFDv8Zz9qpBQ60uQhw2LhiR6vg/yvPUf+mtRb+91m5cgz4E9bXynbhWHoiVgUhQMbw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damos_test_commit_filter() is covering only a single test case.  Extend
it to cover multiple combinations of inputs.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 53 ++++++++++++++++++++++++++++++++-----
 1 file changed, 47 insertions(+), 6 deletions(-)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 5052d8db9657..2770972b0a39 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -528,17 +528,58 @@ static void damos_test_commit_filter_for(struct kunit *test,
 
 static void damos_test_commit_filter(struct kunit *test)
 {
-	struct damos_filter src_filter = {
-		.type = DAMOS_FILTER_TYPE_ANON,
-		.matching = true,
-		.allow = true};
-	struct damos_filter dst_filter = {
+	struct damos_filter dst = {
 		.type = DAMOS_FILTER_TYPE_ACTIVE,
 		.matching = false,
 		.allow = false,
 	};
 
-	damos_test_commit_filter_for(test, &dst_filter, &src_filter);
+	damos_test_commit_filter_for(test, &dst,
+			&(struct damos_filter){
+			.type = DAMOS_FILTER_TYPE_ANON,
+			.matching = true,
+			.allow = true,
+			});
+	damos_test_commit_filter_for(test, &dst,
+			&(struct damos_filter){
+			.type = DAMOS_FILTER_TYPE_MEMCG,
+			.matching = false,
+			.allow = false,
+			.memcg_id = 123,
+			});
+	damos_test_commit_filter_for(test, &dst,
+			&(struct damos_filter){
+			.type = DAMOS_FILTER_TYPE_YOUNG,
+			.matching = true,
+			.allow = true,
+			});
+	damos_test_commit_filter_for(test, &dst,
+			&(struct damos_filter){
+			.type = DAMOS_FILTER_TYPE_HUGEPAGE_SIZE,
+			.matching = false,
+			.allow = false,
+			.sz_range = {.min = 234, .max = 345},
+			});
+	damos_test_commit_filter_for(test, &dst,
+			&(struct damos_filter){
+			.type = DAMOS_FILTER_TYPE_UNMAPPED,
+			.matching = true,
+			.allow = true,
+			});
+	damos_test_commit_filter_for(test, &dst,
+			&(struct damos_filter){
+			.type = DAMOS_FILTER_TYPE_ADDR,
+			.matching = false,
+			.allow = false,
+			.addr_range = {.start = 456, .end = 567},
+			});
+	damos_test_commit_filter_for(test, &dst,
+			&(struct damos_filter){
+			.type = DAMOS_FILTER_TYPE_TARGET,
+			.matching = true,
+			.allow = true,
+			.target_idx = 6,
+			});
 }
 
 static void damos_test_filter_out(struct kunit *test)
-- 
2.47.3

