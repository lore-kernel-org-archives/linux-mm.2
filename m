Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAC24CCFA02
	for <linux-mm@archiver.kernel.org>; Sat,  1 Nov 2025 18:20:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BEEB8E0007; Sat,  1 Nov 2025 14:20:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 647AD8E0008; Sat,  1 Nov 2025 14:20:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5104B8E0007; Sat,  1 Nov 2025 14:20:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3FBD78E0006
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 14:20:40 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0E8AA140473
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 18:20:40 +0000 (UTC)
X-FDA: 84062853840.11.2F7D847
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6C3B2180003
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 18:20:38 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tjfWg275;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762021238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GpztkjKXZzCZJU6iyX4H1mHHGRLqww5Vfypj4ZBY6qw=;
	b=04zAKW0cRYTu7IIO8dQlCnEoAmPFrCaE3kiCvh6lzfOVRY5xVJo//NB9owHCNwjN40e2x4
	8cdxpSYni50yWu0yufZjFVWNyTH4dVVg+tXZpMdMmBzklr5YipRGPrS3fSB3yj1hOMrteT
	FkCLZ+FgYEx/eLTakZATy4eceXBcDho=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tjfWg275;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762021238; a=rsa-sha256;
	cv=none;
	b=thr6F90AlsNq2bB7Piq4vHekOtoDkAUu2v1iBiIVLPuw6HmRRjB9jLgWYClyQ+r1nWRacF
	52Q+1EorYH4LUoVXE4Eh+LlOcmRC2n8Fpk18HYSs4smbLeu+qTQKktXt3l1QX+F2VUQRYk
	NswGMRL3225oFRiudbx+bIVj1fs5D28=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2A85F43EDA;
	Sat,  1 Nov 2025 18:20:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAC60C116B1;
	Sat,  1 Nov 2025 18:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762021237;
	bh=pDU2J5kjF0mDExz6cAUb5XwN43HUszp8OiQLnrE7vDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tjfWg275qIcqCglMB1pNp6XR9Vg/I76R2wghTcpkgMjU+pMcG/oAyVN63rubsrOU4
	 66VxNV9bKKV6mHnxcLtqcLvMup9T8H8dBiYozR/dFWadBrMheQ3PgYeKZnFWWWlsMj
	 YuwKb1XkEnqeir/aZOlPZx5tzin/yqHbgWNfYvN4SmccwSkJ2tUu0i5Z5dw5PSac5o
	 XuSWP3jy54dQRj+vUcX7F/KL+0LgDoXvC8AAZsGrh9eB05XnpYevil+X/bXiw96yoK
	 /siThDcrZxIidLTTVVuBC6F1N2MYjM4IyiOXvhSaXO8guTBxf9w2F/hC6qkKrmW31r
	 OBUbclFw8Ehcg==
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
Subject: [PATCH 03/22] mm/damon/tests/core-kunit: handle memory failure from damon_test_target()
Date: Sat,  1 Nov 2025 11:19:57 -0700
Message-ID: <20251101182021.74868-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251101182021.74868-1-sj@kernel.org>
References: <20251101182021.74868-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qhegwxgoxaeqqjef6hu336pmruaqx4pc
X-Rspamd-Queue-Id: 6C3B2180003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1762021238-674120
X-HE-Meta: U2FsdGVkX1/20eg+UIe6PtM9NvA2upQmHrlnZjPdj3x33Tha2coPtjhdpdgiQtj4S+a659ufxkAgta16Fca9S8Jse+BDllF9pUnohK6DaZXkncCcmIw1jPFvL7nO56ZxTAoWwmh09LROvPIbfb1cMbBi0tDJgTE6ybHa+CDPy2jnkpmgm9Qy3TgC/aVgiXLKu/3EriKzt+gGcpabqjfTGIs6Vi6SAzossoeHDdan12q4tYCyVIo4b/OHgyLhxgSHg7p04/HePDzYhIw/D3V9DWGQUxqvm+kK67u8EGeV+IWNsVdkWHJbM2PriRST/75mo/xR3T+OzjPjOuC2DBuKGFdtj/WHA08fyc0fqHma9ilXGiVetdnjNA6QCIrMcjOBidl1v4jI7T2JEyn0sdWu27xNhLgatX4I7LREPOwwTyMv9kRDPgKJlccY/zq5qpX+GrPNvQJkRuxLLmBE/MnQiBgZs31aAcdBVVgvLvfTyp60q+VVlh+S7RziSkB1LcEh2h//pcKo9SjmHNmBTmrSurKeSshRIUWidi+2d1C+xLs5bRGjc+lSCb3HCiKDFoipwpgS9UX3fsHCuOFY0Snj2rJRp5JRgbjvuMMWNPL96i7YbMY4X5frsxN3N9AdbL0IvmT7eqsPjap6etmZ2XQOYc+82jMilfFAa24vvkoVq4QR6r4CdujHvJjBUNnX7OqRBYjIYXYZq20HVd6wu0L0wjw7vhxxcFo4oJqIzhgzJf0rDM7wCbXVYXc/ByIR0lxpETUz9zhMhQnb11TzblOiwfQNbKq2eK1qXj2FKnkoUlQ9NlybWW37AUGoGD+ZjlBRbx1ChXtUmag8OyY/6X5R2aQ9Vdq8fGLgA5BVJ6uj97SK/YrMI48b4rh5MlO1GxzUAomFlU2oNhLMeiNCkLwBOwAKZrX/bAF3iAtq0nJUYKXvFq/MkeSwRjgZnBfdVQUxolrVX+OJoDL92/hhLae
 IoogaxsB
 UO7z8XcYOekJnXPToqcCcJkU1hEwo6RRXjAjnQqt4ZuUH/o9mVa+ZhuDDZxUhpxvzR0NOZ8dboglNHxVDtZP3PHThdOcgk4PqHZo27XIitfA8uyGfRgcwgo5viElvXxJkosKhLnUkHYWo54L513TFraFkp6bf/6OyPO2M+yqEiXZMlsWN4wLf/rOFjH0ZAGBJjqx94++ficpEF+mKyYp9hvLD1FFCwpDl8d/4D4hbECfl+caBihhHc1HUiFup/MUgfwsbMUKw/M9RKc46ogGllSEbKQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_test_target() is assuming all dynamic memory allocation in it will
succeed.  Those are indeed likely in the real use cases since those
allocations are too small to fail, but theoretically those could fail.
In the case, inappropriate memory access can happen.  Fix it by
appropriately cleanup pre-allocated memory and skip the execution of the
remaining tests in the failure cases.

Fixes: 17ccae8bb5c9 ("mm/damon: add kunit tests")
Cc: <stable@vger.kernel.org> # 5.15.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index a2c9ee7a5de1..6e8a605277a3 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -58,7 +58,14 @@ static void damon_test_target(struct kunit *test)
 	struct damon_ctx *c = damon_new_ctx();
 	struct damon_target *t;
 
+	if (!c)
+		kunit_skip(test, "ctx alloc fail");
+
 	t = damon_new_target();
+	if (!t) {
+		damon_destroy_ctx(c);
+		kunit_skip(test, "target alloc fail");
+	}
 	KUNIT_EXPECT_EQ(test, 0u, nr_damon_targets(c));
 
 	damon_add_target(c, t);
-- 
2.47.3

