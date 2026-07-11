Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E4E5C43458
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 18:04:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9A946B008A; Sat, 11 Jul 2026 14:04:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D72016B008C; Sat, 11 Jul 2026 14:04:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C87866B0092; Sat, 11 Jul 2026 14:04:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9D2D66B008A
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 14:04:23 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1D9CC1207A7
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 18:04:23 +0000 (UTC)
X-FDA: 84977270406.11.3DADF7C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 8665420009
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 18:04:21 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NlR9W1Qc;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783793061;
	b=Bx+xCebUV50+/35E7Ovfoi8i3NyodB8ZGfvyZkLp0KcZ6D+tpXxRSJ5ZwkIAvbkKnbH9rk
	Jz6AObc+LHIni3q+/HaHBJ4dcTn6NDypNUgglKASk4Vj91336jCWuzoZQPUzWRFf9+rq/k
	+teB7W+1JZendi7SlftVx2vgOGMESmU=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NlR9W1Qc;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783793061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pbj4M0PCAFhChb2r0bNN0cHfe6XonAYY07ZTVFUWh04=;
	b=hKOwCYPyTSFRf+PDPsAKwuBOsHTbCJC6fZwYwjV/mNn+JbOEV70q9qHN13vaTx9jMqtRHQ
	S/hBsHXkj0nRjzzv2rldVj+sDL54Wtu+yvm4CrMW7gYjbpbu03PlWKEuopLg+Xr0xeP/8y
	aji3K0u6QV4ArQvOBoqBT+fArN2Lhco=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DC4ED60052;
	Sat, 11 Jul 2026 18:04:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3660C1F00A3D;
	Sat, 11 Jul 2026 18:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783793060;
	bh=pbj4M0PCAFhChb2r0bNN0cHfe6XonAYY07ZTVFUWh04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NlR9W1Qcz8xV7IqYh9TId8gWx/a84Z1oJt38FZGx/ZhwBtOZqmdUG6YY/SGybTLvO
	 +QOkqHi6KptogQW+p04qBCVT9NPA0K6Jcq1iXiT7XsoVhiiDqhnqtGWkbzhczFVbTL
	 nlilupHYRytu7Ms8aO7Ixi2kJgGhoKHLIheM+zE09nWqJRBSLcilBKDrHnmjKFkku8
	 zj/O+mYJl6D11ahUh871RSWcAMMERFrh0N+7s8K/CpCshntF3sgJM4eZxueJTlSkUM
	 EAlEqDPphJYMdRFGCt4QJp1/v/tqqjByAck20wRZRkf90wzCGzY3eg2EpKraSriHWX
	 Xf2nccWV8oHOQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	"# 5 . 15 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	SeongJae Park <sjpark@amazon.de>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 2/5] mm/damon/tests/core-kunit: catch test failure in test_merge_regions_of()
Date: Sat, 11 Jul 2026 11:04:05 -0700
Message-ID: <20260711180409.82093-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260711180409.82093-1-sj@kernel.org>
References: <20260711180409.82093-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8665420009
X-Stat-Signature: na8n73dk5wgt1i3x5r3a7kyxfb4x3fas
X-HE-Tag: 1783793061-609150
X-HE-Meta: U2FsdGVkX18y5Tj9vE12ipBRg7QBuh0rSGexcn3gHLV+2lFFNcHJQpEhOIYrEAuRQfE6HlVg2SXin1n2iUViFv7DyPkU8XbmW6c7plp6Iq0TYl0CBLdpCdB4xxjrRUqRSDbVoSkl+hUuvGRjOhVohFYgdEhiHdY72cZckhawkYgyWrTJhLepRGi1bXQHMoMeQ8binhNOCKqFTxsqB/2TnaGk3YaWb1yXSpI9gEXhaOOZS2ebNWnWsQhmbVWpx6SumcqcRTGbMElMHV/Nqhisxq381YVrOpD2FhZWTuQHLQoGF+HvutKcriyftziQzErd1Hg34DnF5JrtB+l1S9AWGr+jLnL8Cca+w7hnSy/PRw26g04dLceNDwzzHMtxIJ/dzyUOyvA1DB/o114iajIw0W04p769onL5NYX21xOg/heXL9OCRLMWlGFm87NvCn+H4uPH8GxgFysSK6QXXgwbLhZ63PJYHRReS+pLxuuPnr++EKd7BvKJTxyz1BW8UxPz+emdK5jY5vF/UgDBXdBe2itVnxm5j3WbHf7Bxv8O0MaVG7UyOKMx7y6FGijSDjjDh/c/sPgRo3+4TtzdreMISTdCIVzuzz8Ze+XG8fMnxLOQIimbOsxfRa8K2ei45Rn3dvVq2etFgdavJkTdYxQx4zoe3I7XQn6KgqR5mZr3UqmAArZ6+nExTCa2oKWE9ydxq0sY5NK+H97Bsapmsa3HVWhyOHzZWC5eLP8Ywr8SjihdgMLduOD77iXv2rktK1wIPJGt/WBCZJglPYb5TFPJOEaNzFC5aPFu8a0jYnqnW8XdWZ5kgfwi1Nqd4lNuu/XoaHHwesee/odrAXglswdPvq6F+cN0ju+xmvCACxaj9RVfh9RES5oqAQGmoG9q6oKn81N4Abo3OwA+BoPg9lNDfmng/2ccXG0bdkYVPT6X5jjeA7GGn1QDvAJYwAxlhIlnxs+W2OccYtZ2nb1v66t
 y/Anm0Si
 4BP7CplUI6Vp6OPSZcpDyqCGxH1cJ1RtAIkyALAe1g5ETqLd9l/+XvxmBTZaTbTo4h+Ce1cmdldLoF6PlPFBg5MObfQWOJ8Dc1fPcAxKNug022S/ylFoCKOvdcS8toO0qPqUOxv/OqpYjjFjPnthAknv2emqFxG6ZU61P8MdJgfCtkSeqeNrBJ+hUXd1kv7SqooCFyyDZqpLpFKNeV66CccAiPU9AhY6nTbmNCvQ6tzwMwsVm8MWi5Ie0FSGSL6gRbWHrAuLEbe565oFC+mWX6ATXdUSPJ7Yu++3EHJOh52GbQsfR3jfowp2aRXeLgdA6J4d/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

KUNIT_EXPECT_EQ() does not abort the execution of test code when the
expectation is not met.  But damon_test_merge_regions_of() code after
its initial KUNIT_EXPECT_EQ() call assumes the expectation is met.  It
does a per-region test with a hard-coded number of regions that is
correct only if the expectation was met.  As a result, __nth_region_of()
could return NULL, and the test code can dereference NULL pointers.  Fix
the issue by catching the expectation failure and skip the per-region
tests.

The user impact on realistic setups should be negligible, as it is a
unit test.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260710144937.26981-1-sj@kernel.org

Fixes: 17ccae8bb5c9 ("mm/damon: add kunit tests")
Cc: <stable@vger.kernel.org> # 5.15.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 68d30648c612e..fb882a0602ff9 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -260,11 +260,14 @@ static void damon_test_merge_regions_of(struct kunit *test)
 	damon_merge_regions_of(t, 9, 9999, ctx, true);
 	/* 0-112, 114-130, 130-156, 156-170, 170-230, 230-10170 */
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 6u);
+	if (damon_nr_regions(t) != 6)
+		goto out;
 	for (i = 0; i < 6; i++) {
 		r = __nth_region_of(t, i);
 		KUNIT_EXPECT_EQ(test, r->ar.start, saddrs[i]);
 		KUNIT_EXPECT_EQ(test, r->ar.end, eaddrs[i]);
 	}
+out:
 	damon_free_target(t);
 	damon_destroy_ctx(ctx);
 }
-- 
2.47.3

