Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9564BC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 13:54:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6CC96B0096; Wed,  8 Jul 2026 09:54:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D476D6B0095; Wed,  8 Jul 2026 09:54:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0EA06B0098; Wed,  8 Jul 2026 09:54:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 87A676B0096
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 09:54:09 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 092251A014F
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 13:54:09 +0000 (UTC)
X-FDA: 84965753418.29.B87D69D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6C34540007
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 13:54:07 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Sh26RdOy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783518847;
	b=yfXCQEcfc39+Ctwdd9b75kjulbWR2mAF51On+srP/3jpESeBTKkUR9r5pHhbYShd2VOETC
	CL1HjhXsEKGPt2e65K4MJScyh41Vspgko3G03qB064ReB3Yiu1IcbUEnFug4BGcfna9Mkr
	vH25V/aOI8gRudXOpaJhXLxp8t5nOuM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Sh26RdOy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783518847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rYlq3Lp1htxNcYc9q0Uy+3l1xL/3ejGhpOTnhJctTfI=;
	b=bn+AT2mWcKT2AhI9kpWgAUulNmtNQJcmcwUyKwFhoh2zykaEs5zw8rJ+ECNJGDdLEqHxDI
	sBtaVv8i24uqs1YiDClqK+SYymji9rQtpVO+o4Y+8le2NSjMgpeCxmRjyWIY1ZCoZ9MAue
	TSOVMG1NIlG4Rz66k6VUYwe51GRTBQY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B73FD43AA5;
	Wed,  8 Jul 2026 13:54:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 700C01F00A3E;
	Wed,  8 Jul 2026 13:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783518846;
	bh=rYlq3Lp1htxNcYc9q0Uy+3l1xL/3ejGhpOTnhJctTfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sh26RdOyNx2Ib9/YFRg/SCG7vFZKPp8CLnBNfBAApRjhp+NYVy+NW3x5+Uj4Adpil
	 da41HTo417Vo3ilaw2dAmnPjj7oxn/rLthJOkR8k1kOPeTYPeooLXIcLOEUJu0fnwh
	 +Bp9+AjBlGmFdRW4rGzX9ExHFJXPd/gPHRWhUvfXp8RIpwq07mFSrxkGrCerJWCH9u
	 lFR4OYcELwEx+38K3cZMJ3c//aWW4/BAZhtPmXd/FR15rWOafn7VtprafEQ02QxqPE
	 1x1UarV7M4cxDzUGGMSYlVxCDp1sW0WnXnEZwnKiNaOwlDX6tzwwF/T5z+jKeRgKvd
	 VJZZQ4z0kgvTg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 5/7] mm/damon/core: s/nr_accesses_for_new_attrs/nr_samples_for_new_attrs/
Date: Wed,  8 Jul 2026 06:53:55 -0700
Message-ID: <20260708135359.122587-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260708135359.122587-1-sj@kernel.org>
References: <20260708135359.122587-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6C34540007
X-Rspam-User: 
X-Stat-Signature: 4pgp67xuo6fhx5eqgjqs74is9fdd6s6x
X-Rspamd-Server: rspam03
X-HE-Tag: 1783518847-960330
X-HE-Meta: U2FsdGVkX1/RvG7CeLLjGQiL6jWCv4Y5KHr5ABh68+rwLPUUoQNHT84/Xa6fCHTs9mJqU7IFW/EJggN/Hve6oYI08D65VNIBe1WxehyFsMw2QDd19nDl9zto0miWrf7CawF9bMGCSs/dhofq97QVEqAzaXrIxZqAKJwJLCTAGc6hp6BuMTfdfXgJ1X3VsqlFfcwPmmbryuyd0awmR5XixYGCdQsutLFzgRx18zk03T4GDCpV+hx5AVsmSq6JNvlFjuzjacqjbavGVc1fZZIzGl1p5kYWGhYT+J0eY3uA2ew9bND+W8etGAR0civND3c4pNbzr7Zoaggzd8sDG9FYrZRQGzqpjUitgSJgAJkC9QQswLB3dYSAnzPaVkLB658D7u0Lba4SVyBL8y3bhdurePMkvpMOyXEWF05sjy5RbkE6/dvgYpG5VLl9XXoBUncM75f5FomdWB5cdLmc1svLbrioqK6lcTe5WWzOK6cmgExpLrREGs5g6ZQc6Pp1ynrmds03MBmeoa8QK1reuynePQ2UPb1vjIe8cnzjfjYI92Q3l219Ipwub2yqCql3tWfrjjFuPJWVD2ZENeh3tF+GCRh82azmdulXzHHllv7dBNYI9JP9oCKfpyT4WtERKPUpmyPTUbVMGOTt606Bs6M9q2xCNENqf0Nct5tpZBINhltV5AeVE2ur7HVNvb9zmeCzDop1Z2kR5ziEhmdIjZ3jcrhMRninVpiQMnlT7OL+2WuDu++QlgvMsue9mvVuQOaYAdLWXYe+z1/6TCg1E70W5Jg9dYSIdc8DRB4oGrltmr/px400RVoitzLogMJC6N3AkQedFLgVWjub5BuT82xLdA4jQRHQKN4X889MMbyZlVw5hOXIYi270XEvgVp5UAMDbitByjJFzIHAtzmFF3AZc4uL6n5jltUZE9mZqZeYqw8vl4LIKtGMvBZxhSAT6/8VRbfsFwzU9BCdOQffW4t
 G21VZ/GP
 BZYucbndvbc874hSzl0OyZjWYSHAtvSNeFaxKefMRT91Bm64ueX265pgRFqgOpZ+AQcsrdTNLDbOw4F4B6jaL9alhXwcAviOXxHwXeQltKyjgNCfJrJBO3Ewl7aPn7/PHhUobj9fHrmDZnHx3V/BmEbbt0I8bh9GKX/CPIra0r3GeoQ2ZwgMsYuKQ8WU/K8Efe6uBcvbTs9wsg0Ui9CasauIm4pcwZ9TtSHgsHPMoJNQzUXblHgasx5tQ5muDQjIMKcqN488grol+wlLfqDvTzPyIi64Cv4Afg3mT/c11rURKhhtIwNpOQ392DrHMVAT8Qasof7cOYSXTyn9sv8Eg8dJpEpJHSKleqMq+1aB4DcQS8e4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_nr_accesses_for_new_attrs() can be used for not only nr_accesses
but also any positive sample count, like probe_hits.  Rename to be able
to be used for such general uses without confusion.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 718268df27fa7..800ff6b6d2473 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -890,22 +890,21 @@ static unsigned int damon_sample_count_to_bp(
 	return mult_frac(count, 10000, damon_nr_samples_per_aggr(attrs));
 }
 
-static unsigned int damon_nr_accesses_for_new_attrs(unsigned int nr_accesses,
+static unsigned int damon_nr_samples_for_new_attrs(unsigned int nr,
 		struct damon_attrs *old_attrs, struct damon_attrs *new_attrs)
 {
 	return damon_sample_bp_to_count(
-			damon_sample_count_to_bp(nr_accesses, old_attrs),
-			new_attrs);
+			damon_sample_count_to_bp(nr, old_attrs), new_attrs);
 }
 
 static void damon_update_monitoring_result(struct damon_region *r,
 		struct damon_attrs *old_attrs, struct damon_attrs *new_attrs,
 		bool aggregating)
 {
-	r->last_nr_accesses = damon_nr_accesses_for_new_attrs(
+	r->last_nr_accesses = damon_nr_samples_for_new_attrs(
 			r->last_nr_accesses, old_attrs, new_attrs);
 	if (!aggregating)
-		r->nr_accesses = damon_nr_accesses_for_new_attrs(
+		r->nr_accesses = damon_nr_samples_for_new_attrs(
 				r->nr_accesses, old_attrs, new_attrs);
 	else
 		/*
-- 
2.47.3

