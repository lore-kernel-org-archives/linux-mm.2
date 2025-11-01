Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2708ACCFA00
	for <linux-mm@archiver.kernel.org>; Sat,  1 Nov 2025 18:21:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92FD68E0011; Sat,  1 Nov 2025 14:20:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 896AD8E0015; Sat,  1 Nov 2025 14:20:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 536838E0012; Sat,  1 Nov 2025 14:20:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2E02F8E0011
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 14:20:44 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ECD1F14024C
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 18:20:43 +0000 (UTC)
X-FDA: 84062853966.23.23547E6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 79D69C000A
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 18:20:42 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KmC7pbG3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762021242;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0gjgTBN+6x5Em8dVKqPyO8zqdqGtHS/fQrPkuv1v8Yo=;
	b=5wZOde4HJM6x5PZW8Jry0rbXBB3EgCqo1qn8lIRPuPvsalqpLJLjgtJ4tg6H34+K24ee+U
	snaaVwFquE+c31jySVMZ9JVv4zihdzVZhMKKTBllD1dgtWO0e9j/3efKDTkUtXfQcnRy4w
	OnQlGypa8fhui154e+u7qgRhpUMbmQo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KmC7pbG3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762021242; a=rsa-sha256;
	cv=none;
	b=nQf2Iu9b3XSYOAglb+di2kE2NDsOQ9LnM2VnQD1HTn0RXOBZVfFW+hqipxJTQnPtlyh6PN
	2kgu9/GINCv2rOgkmR8Y924t6HO2wFtUvegvzNhMZVx4LSLDqbnrOwBaCYqrzKHHJpOnGQ
	3x9+EWxpUeXu7umfwBFiu/ttSqJ5B8E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0C9FD44099;
	Sat,  1 Nov 2025 18:20:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3D57C116C6;
	Sat,  1 Nov 2025 18:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762021241;
	bh=4mW1l163HEBJlF7jgeTLtvFXIHv4JgpHKouvNhyCopM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KmC7pbG3YkOMd+7g918cdD2BpOI7oFdF9qnxui4hsUok0+bmX4TQNx2xAn5m2S4Nn
	 yB+XGNZpcNY3qD/0jz8c1PuFnU1/LBikJ8pBFdOAsdxM3Vlds9dLZ86Sh+2sCK3KpS
	 6GWOO1GI2JW805fbb2WbpIewsPcpabhvN7rmD/4zDwKqkZbS8odntB1+IotOKxj30Q
	 Z8l9oPUDZsHJaceCN/AFGIIF6RmQdtMgTpoPMbmU/p7PmTqJPmKjw84h6oa7allm8c
	 arhvyipfJC7GaPUhWm5o3sQuBb+GgrKujoaYcenSKnLoKv4Rab50MYJhdQy6k968TM
	 ND6VLOxB6s1Ag==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"# 5 . 15 . x" <stable@vger.kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 18/22] mm/damon/tests/vaddr-kunit: handle alloc failures in damon_test_split_evenly_fail()
Date: Sat,  1 Nov 2025 11:20:12 -0700
Message-ID: <20251101182021.74868-19-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251101182021.74868-1-sj@kernel.org>
References: <20251101182021.74868-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 79D69C000A
X-Rspamd-Server: rspam03
X-Stat-Signature: es1iy8gksr448onh4x3irtpjaiz34mqh
X-HE-Tag: 1762021242-603564
X-HE-Meta: U2FsdGVkX18Ri58RYpq4zXmR7j60Kbmou3H+C9sPKX3ZwKR1LmyJvJ0tAVBAwmank2suvjpXKxZT4TAr1nItm7+MBhylD9oHXX4TpOmCsx2i15yt7dpegFM0PnVrIRbTKCRaBtWshRVmut3o+KS9fiji52qu3GrP3wOqNa1pvPmFno5uX1Rd4iNdgVo7vZGLf+yk4PjPCKgdQUs32d3+qrZoRk0IPOBn/jfm7neiSPVc50zHstHnodrScrPW5ihUysrDTur1asK2yl0uBNh4pZdVHahcc6DMDWTah2uBu8ui1sXQQ37UgvPn0Y/44e83vbKgFSx2RdKSc2Le0JJSxCoO41ubfb4PzvvCO1SvQK/8dAzgXri4QFfGNjLoaVknR8JmcGTyQA+bA2cgFO5whJfAUzRXG+jsQYPTcAOZXI+90SkZx9U2V55RUbdMRs2TA9QKnY3Za7HFk7a9qgyxZmza7VyedYGDJQel197Vs9eVF/ojSmLidLkfW4Yt7arX39nl9TI/d6OZEXidN5+iKssnvWCdE9lC22c2YSsqIQtWMX+8X2x4Flb87YfWED4bCOF0GZInmU8R4DPkII5zEqqfiSaGITnHanyo2uVin6MQTHITpMnhtFSMGU2+NF6jA/3dmlF/8R6ez1Bw20rdN6UEKua0KgMMHwoAQ5RlcRMHx7rQGbRwAYZ+e5fWvY+vDB1XN3uO+o9MRdac1Tknji1B0YOWtXjmSBmliNNDriM/yWDozeSVf88aEFQvJHUPtj2sQntp9b+kG157ZZIuvUcwMvUMa8MF+A/lj8HKCcfreJmySGKQcrvePrzQbLYf9goo1ov6GXdDlB8f/lMiHwJRsKHnjdKufNv661EHsmSAtLuOYw4IpcpslqUql9ZIZWrDLsHwcJMYC0djxdjwDDZdHi9r2mXfqawpakutfvf0PsopxBlnNVY/9yJCqYkuhT1OVEbolH85NtC00ZG
 RocdeFVR
 KXp/vxy1onO/oJ78=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_test_split_evenly_fail() is assuming all dynamic memory allocation
in it will succeed.  Those are indeed likely in the real use cases since
those allocations are too small to fail, but theoretically those could
fail.  In the case, inappropriate memory access can happen.  Fix it by
appropriately cleanup pre-allocated memory and skip the execution of the
remaining tests in the failure cases.

Fixes: 17ccae8bb5c9 ("mm/damon: add kunit tests")
Cc: <stable@vger.kernel.org> # 5.15.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/tests/vaddr-kunit.h | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/mm/damon/tests/vaddr-kunit.h b/mm/damon/tests/vaddr-kunit.h
index 484223f19545..1b0f21c2e376 100644
--- a/mm/damon/tests/vaddr-kunit.h
+++ b/mm/damon/tests/vaddr-kunit.h
@@ -256,7 +256,16 @@ static void damon_test_split_evenly_fail(struct kunit *test,
 		unsigned long start, unsigned long end, unsigned int nr_pieces)
 {
 	struct damon_target *t = damon_new_target();
-	struct damon_region *r = damon_new_region(start, end);
+	struct damon_region *r;
+
+	if (!t)
+		kunit_skip(test, "target alloc fail");
+
+	r = damon_new_region(start, end);
+	if (!r) {
+		damon_free_target(t);
+		kunit_skip(test, "region alloc fail");
+	}
 
 	damon_add_region(r, t);
 	KUNIT_EXPECT_EQ(test,
-- 
2.47.3

