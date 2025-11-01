Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DD3BCCFA00
	for <linux-mm@archiver.kernel.org>; Sat,  1 Nov 2025 18:20:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A8648E0005; Sat,  1 Nov 2025 14:20:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 907558E0007; Sat,  1 Nov 2025 14:20:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 731F78E0006; Sat,  1 Nov 2025 14:20:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 54F9C8E0005
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 14:20:39 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 20C564A767
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 18:20:39 +0000 (UTC)
X-FDA: 84062853798.02.C23246B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9C559140008
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 18:20:37 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QTwPfR0t;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762021237; a=rsa-sha256;
	cv=none;
	b=ZEcv7Rc5Pep3BhVX24aXI1syNn95EaMe6rJDzYFzUqMJRnni7f5RDPh50NAqM172oFa+wJ
	olgMRc1TbTJ89Q/Vr9JODDnXgdl3RPtGJ7apA/L+wwfGoVITX874LMfIhXCO7fQPRjtScp
	BI2hVxH4CF1Le64TVWLr8+M8ZHDceSs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QTwPfR0t;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762021237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MfAduNrz0Fxta61wnG5fM20Rrfb47wWXUj217sMYV7I=;
	b=DFpKV7bF+Z9WA6aUmFHuP0rBwSLu2teo2aPpQ5g3ktTiFUioEu9LRvpfo3W/iG1Bh+7pWs
	3E8bNYrBG2pPdopfbhFiH8y+5ysHDb8f3+hbUyKwH3P77wyYWW8qIOPEaWc+7m9jIZQZLZ
	2bbu893I4IMgh5tMqp3n5X43KBNtN88=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0C6E4601D9;
	Sat,  1 Nov 2025 18:20:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EE15C116D0;
	Sat,  1 Nov 2025 18:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762021236;
	bh=ouIjUDY9hLvXA2FpIhXVT6nydcM4s8x+MSQlq+lUn6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QTwPfR0tWlZ0xcg0bSAtUMV8xDBT9nY8XilWVFWUNCZHNu9tHdOoGMRwA9qgohWZI
	 dSYyiLubnG1H6HR9e+bU10DycteR2XiegfvrDfa7hIH/BjSKAcrbFHWPolG6utILBT
	 IIfYB2Lo7fpJnwwWqWfYU+o7KsFAdo79J3YdFlGAv6dhb30fH1yKH4NAWgM9DBSyAo
	 g70JxduxlhMwOVe5dJcBi+f1dMV2lTtmY3PkAckdQzMrJIVNXr5R1/nzpUVANVa7EO
	 Kz7RUnKtcTj+P+oo/wlfj2uqT1OM6yFZayxOldtxc0SdiygribF4CHq0u/pJUUVTwA
	 JBGgM5PwTmfXg==
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
Subject: [PATCH 02/22] mm/damon/tests/core-kunit: handle allocation failures in damon_test_regions()
Date: Sat,  1 Nov 2025 11:19:56 -0700
Message-ID: <20251101182021.74868-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251101182021.74868-1-sj@kernel.org>
References: <20251101182021.74868-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: xpdawyidabncztgk3obkdkdf6b5tgiji
X-Rspamd-Queue-Id: 9C559140008
X-Rspamd-Server: rspam09
X-HE-Tag: 1762021237-225992
X-HE-Meta: U2FsdGVkX1+qJ/zBJ7FdLg1XU7cQShObe/AWGLvhdZEKYjiY1DbFRT5osZQV7c3up1O3bILtVdDfycKGb+ZdZKmBqkpxyq/pOacmU5ZGeaD+Mfn7kcS22vMAPabBqADk4jwHn8DHA8bQD7oCSmmLsm6/GJQU0ORYSvVqOiUAlPkKBMq8f5JsN/UtUdsOxs00PJm0BrzySzqCJcPUoIyNX6eJQbkiTT3/A4CKfGwlzxQnmwNv+cme2MLzjyfV7JDNXWREikpU0btDyB0erqkKBHblGccxB8Fx2f3NzkC3X68BAzt4FJGK8+4OFdLDbLMKSZXyk11HhihOkPPtGXxVgHkz9fZ9zEWoLpCUQBEQvLp18FLc6RVQaV9dvO7Bn83Lt0grlYC+YnXU4YW/13R6io92TzyGIrx3Z3JOJrgULvJuCsyXIzXVLVVdg9vk+Eh5bx4WGCgkspQBQCqXIToMpQBLLloltiG7DJYb+1a+egkFuT1TLlhB/iyLBs17MG+GhsKUQn1ugpRXQZ6l1+njhMgG9w103BD1KvzA6Ex8ocplyPWPQzswSdtRDMma0LNb4emveoKKJZX87w63kOPVUABRuKPs7opxJGr4cfrPg65NckM68ICkNt92jX0buTG67lWw8J2b7r3C418SQ86CZux4g1yM4AMrGc/fumX6E+kDNDqNEsVT7mH0b+zCf6v6aIDIrm4SSo1aC97S3G9uU7/cNmfjldohBegIn+K1waWQjwWSvrktbXGQD+IcqQFHuko1VzaRRw68CVt+t6iqX2JBVdhXmdkclCvpyO9SxWLLHuQRO69jjreAHAJia8ukf+fA9BvtMVl8u9zI017MG2AtHoHzM94uG1rG0xVRH1G6NCubYTYiPeIZNtEJbayStO2fhJIYJTrBqaQduPaEPYvtEPGYtZFvL/D00PEcDg1MGMY97pwLOybnhqrxOc02rsM8DKt4tTWkobwLXpu
 sghTcylN
 Xu0ENf99FELxY33Uqok0H9/YiXMwAxVPoJ8foIBXT7gb6N1g5NNfycBAmOHZFiRifQIpirBiWqGxZAjc1JVDDbM6y/aX1qsTE+SKoXUiZGmM0ZgoOQBHA2nz9qSjTCPbNv8w+PvfnX/52WgcLVZVox9sxTvw2cgMXrjIY85QRmj+dNsyKkIL3RmDwnn3v8lkZ0FLJFnDwdGY9PjabL3zQ0sZAkBCtHtOvctbyb3Idn5K4jEDjXIkvhf8vF2cvzGqa5deWu7pZNjqHy7EFL6/DpYp1uw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_test_regions() is assuming all dynamic memory allocation in it
will succeed.  Those are indeed likely in the real use cases since those
allocations are too small to fail, but theoretically those could fail.
In the case, inappropriate memory access can happen.  Fix it by
appropriately cleanup pre-allocated memory and skip the execution of the
remaining tests in the failure cases.

Fixes: 17ccae8bb5c9 ("mm/damon: add kunit tests")
Cc: <stable@vger.kernel.org> # 5.15.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 69ca44f9270b..a2c9ee7a5de1 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -20,11 +20,17 @@ static void damon_test_regions(struct kunit *test)
 	struct damon_target *t;
 
 	r = damon_new_region(1, 2);
+	if (!r)
+		kunit_skip(test, "region alloc fail");
 	KUNIT_EXPECT_EQ(test, 1ul, r->ar.start);
 	KUNIT_EXPECT_EQ(test, 2ul, r->ar.end);
 	KUNIT_EXPECT_EQ(test, 0u, r->nr_accesses);
 
 	t = damon_new_target();
+	if (!t) {
+		damon_free_region(r);
+		kunit_skip(test, "target alloc fail");
+	}
 	KUNIT_EXPECT_EQ(test, 0u, damon_nr_regions(t));
 
 	damon_add_region(r, t);
-- 
2.47.3

