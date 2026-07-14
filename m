Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68A40C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 13:52:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0A966B00A0; Tue, 14 Jul 2026 09:52:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6FCA6B00A2; Tue, 14 Jul 2026 09:52:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5EA66B00A4; Tue, 14 Jul 2026 09:52:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7202A6B00A0
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 09:52:44 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DF993A03F9
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 13:52:43 +0000 (UTC)
X-FDA: 84987522606.22.F9E75D6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 46D42140003
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 13:52:42 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=o2Mu32fe;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784037162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Csk2Bs95SoFAJpGitaPFL2lXi5OcS5tAvUkrHnWNWRA=;
	b=xMmOpibc6Dqzp+QyWA9BTwU3ejrZkpL/UjIugDPKPeCBjzhZF+wlTVSSMgx9rornRUN65/
	p3RQ00RvThoX05rrbM+eEFW/2U037bJqZ61rvfd35RcNb3eLsLw1JFGFB1Jf8De1FVMwGM
	e+6zS/dN7RsrcTmL4U0QPl6+Rm+ZR6I=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=o2Mu32fe;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784037162;
	b=1yXovPtebQ/+AxccvZz/6D50CN8vjxvnnpYzb5b33LCUxQlZVtWs+xomGcWZzhLtjdbQ2x
	Um3Q+RNVS9LkE06DIQeLTVMScQKaRCdqobG8lE3VoiZlLHXz+9kMfYThDLgftH/gBoOVeC
	uzYcYlyY8SzsSjEUcgl3N7wmxtkjBuY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5A4654081D;
	Tue, 14 Jul 2026 13:52:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E051D1F00A3D;
	Tue, 14 Jul 2026 13:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784037161;
	bh=Csk2Bs95SoFAJpGitaPFL2lXi5OcS5tAvUkrHnWNWRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o2Mu32feVKP83fD7JNCE+FPeaLoTggU2hLWV+t91Oq6Xo/b7T0n91PDrKGBicdpIT
	 tpx7pkI6XwSagk62CiGVmhne6IeOKo8WbVk+n3mogaHWHsVIDCTFl2ar8xwch0Kc1Q
	 4DxxOJ66fjwEMNPC8Gx/UtamMjq5vnz2drmQ2Ms2q/x0xLhSQSZYEl8WQ+zvrcQCz2
	 4n/elR7mws1pVx6Rfn7PvRVZYtRNH1JfJnMdtcSCP5/9dTyxKcWpQimVMabUYxJNKM
	 /2kZJa3E83DkUVcmNqKZbkYKgnyEdquT4xc4eSqF1wqV77KN8xdgkWTJsDDc5HNOCO
	 xnu1NV3GuDpfg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	SeongJae Park <sjpark@amazon.de>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/5] mm/damon/tests/core-kunit: catch test failure in test_merge_regions_of()
Date: Tue, 14 Jul 2026 06:52:30 -0700
Message-ID: <20260714135236.92699-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260714135236.92699-1-sj@kernel.org>
References: <20260714135236.92699-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3skkyzhxm5z83x5aq75wr94rnbmpeed9
X-Rspamd-Queue-Id: 46D42140003
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784037162-488786
X-HE-Meta: U2FsdGVkX1+ps30HwK/ZYjQpMoZ20qS8R4lrUvh4RMC75+h707XDlOGARkw13bx6gZfVXq2hqYkYlNeySPF/Vi8pF+PNKZ03da+OxATk6P+NsKH28O36GtRjTBJ/T1gCvqXVWEqIYjjXa18tnj/AjsN1QknqHBrASGJaBg8bsDAM1u3DuySrmFdHxhkJUhb88MPkdUEp50XAUZYBykybQXqUXOjPWTztLYcQJlGt993Vu4VXup+Y6kNoryaJAGUiW0Gt7EnYCFJlzwSL+4tAQv+NdXgu8mOoznfOEM6CxGVeqXdoFWda0lOHhylRst3eI/Jzg7ktBS00CGNCMAQFiUH6yM1OogjGdSZPn0Loj5/kF1hRqf5TfzCAc80Q7LIbHnf4M0s4MCgatoMYsjlzvw0CecgR5MY48ZTHJvzdA4EM++3KZ+dLgcUdZFvPTWxTi3fa+n8shnAJRWxJ02MGhFrtIURIw/G6UzuAYqdN5dzmUP5MQ36HAbxhU9sE/7s1blDN9TrDqooZtOzsk8DQWozjTzy7fnrkGsaQHUhGyG2NNiqtBkmgHQpetv+1P9XP+NzK5bL0+EXtTjgS0IU9rt22oI55svN21Bu4lKZVyfb6svexCP6QYgjv0Lorr0qPk5fmkeirNvKAoZHavtpfzYdWtvFuFrCu5ggufMw2ZZ2BYaOWRg4njnKFYdv/kMoepeAgKHu9czkno6fhEnGVr+I1+WXOU26ulh5CXndDrVKzJmWCShOM/xAG2W1qkJ8NnJAAzoR/ft631lUCToBKnFD7B4VE0mcAK13vJa/dXURWVslEczAdv+vIGXUXKA38dE7HjVTiwP7vRFRJ4dXODhUszBPfHayCkOiMkAhW59r3hiBcXe7sVkZBGP7ehyXsjPWL8tscWOf+FwonxSVtSg0rU1ufzTHcMFxq6pAwW5gFNDdNe3y8ctLIan3fOrVXx2PxFaH07CSHB3h2CLw
 CMkcouN2
 Vcm+KZec0dDzZJ+TBDB865Fa3xVaDMWOML1n1kZWRmudzMZjdtaRYXaEWiJqO8dkOfXJcV1wxSurFZ1sEOvi1a1rxFWYQbKRsW4UBbVl68hUrzfsSAYSbDX6AE1UksQdr8SCKvThNyv3ga8wdpF8lhIUq+VU9MEiU+0Q2u7ffrNFoKrglZhGu7LBikzAOt055zgxQK+4o4vyy96nXTv+sQeDBg5RR+g2Jh+5Cp14G2ueW5P/mW6PltA8qj5Ahs/wJy8nH28d2v0cp3L3BtkfPqfhV+Sw6iipkyICt2mFyM6arO+/Oi8jzWu/O+DtHyupZw07f
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
index 485472ddebd19..eba643762132f 100644
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

