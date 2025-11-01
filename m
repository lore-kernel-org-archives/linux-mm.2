Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27AD3CCFA00
	for <linux-mm@archiver.kernel.org>; Sat,  1 Nov 2025 18:20:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C15758E000C; Sat,  1 Nov 2025 14:20:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BED888E000B; Sat,  1 Nov 2025 14:20:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A403D8E000C; Sat,  1 Nov 2025 14:20:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 88B3F8E000A
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 14:20:42 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5033B14041B
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 18:20:42 +0000 (UTC)
X-FDA: 84062853924.14.2E7100E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id B3DF310000B
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 18:20:40 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fzx1oqvX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762021240; a=rsa-sha256;
	cv=none;
	b=C2SgMwClVbODv/PyqXXl8AGEU58bu7CcdPrGg9lLAqUWakHWhw+IgERc5rJcaLw1A10t79
	cXOMM7JafhImElAfsBNHwcX3tck5krnV75vki78Dg4J1tgZVePhUBDS9BZKL6zSoKfCgXz
	v+aKsze7g+ELKabzpC5bDNQvbLSShcA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fzx1oqvX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762021240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zRFtj9XziYDyLiXTkKdQ0UvRskcQiAJd47ybxkouUnQ=;
	b=Wx7e+3CQ71Oq/px/nfbVxQs4IIMFYDF657m0wLhvOMr6hC8nj/UiZpP3CABRgDxPa3GAxp
	B3tCiqhPGUh6TWXNEqV9Nco6qz6jx5MVG5URASvGgh0ymatdqPpkTeqJ9UOm0m+JBHxk+W
	DbDkUhsOn5fYDOYiobjUc9FK9mNmmVE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5D80E443F2;
	Sat,  1 Nov 2025 18:20:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EFD7C113D0;
	Sat,  1 Nov 2025 18:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762021239;
	bh=7jFvaJGAP1Q4wk1944apRFLq0yQCQ9xbNJKdqchcXTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fzx1oqvXMfUViV2BMqJZfpb2KQUo0kC6CUqYBP0FLxcaGA0B1YdoM+vM/lR9jXdkQ
	 qucFe3ffLdcRsidGlwfI2JPBgfhilaS7lDoaq+Ypdutd6XFBKLk8+qh46IQRv0RtKZ
	 DUkCvOoDwFpjzVk/PELeY0IqCbcWoeppyIBMHVXAgxbuxoQzAIgjM+owg5Lp0mGzc9
	 7qOzWsP/orm51MAae9p1o3z7PhJbKG9OlXIa0VolWBEymS/OTdUCDuDfr/3tI1NvWm
	 qXjGK8v1MFiB+uahqGHPzfoWkCUnFpwdZx/KwgpEBGqOc/fFkpZp0IUPleZcXSJWh2
	 Kg2xrmTnJwrZA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 1 . x" <stable@vger.kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 10/22] mm/damon/tests/core-kunit: handle alloc failures in damon_test_set_regions()
Date: Sat,  1 Nov 2025 11:20:04 -0700
Message-ID: <20251101182021.74868-11-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251101182021.74868-1-sj@kernel.org>
References: <20251101182021.74868-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: px89beuahjmzx9upxx14yjohxc4c8u7r
X-Rspamd-Queue-Id: B3DF310000B
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1762021240-447634
X-HE-Meta: U2FsdGVkX18NOX31xkQDN/6cZThsdKt/wM3p6tJBWLrozX1ykrldTSCpoJmzZ6toenZ8ebHL9tB5Nsv7GR2MOU4QACDBk7MKhzMaA/FzGiEa7mi9SjsOcvoxrspmBgNvomB7Sbtz0ALN6s7r4+B9/EgUbBmNx/ghNGtTh5CpykRqlt05vB1Cm33vEoyw10cYAw7JIiew5EkCN6txWx25N1AI8DRuR58ddyPfstVeNp1exNav+DG4czxsVPtuvYq5IQNszXCKtqJDr7sY4nPZWpvJhf01aYgmFChhtvgSopCDiRu5pK/3CKIRoHeFnJcf/QlKD6E7oKLwxJDSFsPqQdgYQsf0lalM2+agDW5qBKtrx6lOF4fcjsW+oA1v8pjwYYyqoR2J6Fx56MQ/m393u9KfTPvqOFUN8VZWDlLBMwQrYRU4xHIErugwMRohQoBqJQwxEOwKUnPTavOevXF49rUdXFmAuhxppbp7EptiStvo5CXG+cuxYWSY/mtBZ8gADOuF0LRoW8C6lltkAle8ybEY/vx6885nAWB/3owMCgpa9hAyYHPAUhnYDZ05iEzosZyNkrV09rje6l3kLrpUGby0mzd+gP8wLhxUfTZoSpG24FdZTg6bC6mWxBcnxXMCyKL2eIQg/4b5tVqY8gMDUrMkXan7JWVBe/fEDTNA5KLEA+pipnj8IW9/gpw2IMDovY8ZVmP3O/AXxbMJ+X6XsSUgqkhz0UI0yA5dt1x9IzTp2TlkEsg+YfnCfTeRclUM6jWv64pbNZ7k2Jhbo81krraI4oEAz1mgj7SHt7vYlm2U/+pYJepFr/ILYdf4Xdx4OtlDm+MmGLaxGh4CX26F0YjZt6j8xgK+X9hkYa8p7gaZGT8Nd4X/PVhCU4NG5JFEzEARRbwwDa3SOM+hbtomTojUi1NCNZ9RUy4LYx6h56i3nZx0R4uzzzllLmBehbrTcHTKoLxT4PHTTUKE+lJ
 RX9Iw1mP
 vn9Edq1qF45f4V48Hbap/CNkrjvInnQBy80lArIYRYlIHv4Wx8l8gtx6WxcTvZUNFHyK+2k8qYBgzv+6R5aIwhaHRGTgu2C5Icrm4hxatmXwp9eCvPVeYoDkoo1RLXSv5bm/fi6plRYDOwg8AOLrSa0F65HARYT41OdXzXZupm9Y7Df7wBrARMO8mxoju7/CL2Ezz6mmpSC2lttyXLePzDUF94wCQjwEUCy3vkGxQXwDyltG4nQ4+//aqioa+7Oh73bXRU7ITwSa+6YBj+NdvD7dRNQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_test_set_regions() is assuming all dynamic memory allocation in it
will succeed.  Those are indeed likely in the real use cases since those
allocations are too small to fail, but theoretically those could fail.
In the case, inappropriate memory access can happen.  Fix it by
appropriately cleanup pre-allocated memory and skip the execution of the
remaining tests in the failure cases.

Fixes: 62f409560eb2 ("mm/damon/core-test: test damon_set_regions")
Cc: <stable@vger.kernel.org> # 6.1.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 96c8f1269f44..e38c95f86a68 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -368,13 +368,26 @@ static void damon_test_ops_registration(struct kunit *test)
 static void damon_test_set_regions(struct kunit *test)
 {
 	struct damon_target *t = damon_new_target();
-	struct damon_region *r1 = damon_new_region(4, 16);
-	struct damon_region *r2 = damon_new_region(24, 32);
+	struct damon_region *r1, *r2;
 	struct damon_addr_range range = {.start = 8, .end = 28};
 	unsigned long expects[] = {8, 16, 16, 24, 24, 28};
 	int expect_idx = 0;
 	struct damon_region *r;
 
+	if (!t)
+		kunit_skip(test, "target alloc fail");
+	r1 = damon_new_region(4, 16);
+	if (!r1) {
+		damon_free_target(t);
+		kunit_skip(test, "region alloc fail");
+	}
+	r2 = damon_new_region(24, 32);
+	if (!r2) {
+		damon_free_target(t);
+		damon_free_region(r1);
+		kunit_skip(test, "second region alloc fail");
+	}
+
 	damon_add_region(r1, t);
 	damon_add_region(r2, t);
 	damon_set_regions(t, &range, 1, DAMON_MIN_REGION);
-- 
2.47.3

