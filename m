Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C100AC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:27:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACECC6B0107; Mon, 13 Jul 2026 12:27:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAD206B010C; Mon, 13 Jul 2026 12:27:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 946646B0108; Mon, 13 Jul 2026 12:27:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2A49B6B0105
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:27:41 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 175C9168B98
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:58:49 +0000 (UTC)
X-FDA: 84983909178.13.9323F96
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7C75F40005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:58:47 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="LQ/zMYiy";
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783951127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SKLq7ZuoHq2BFm176pu4DfNEYfPU8F0EbpgzHa8ZXlA=;
	b=WFExV7uRr5IQgrVurptulJeteumIoUr0Z5/QPeTJ316A/wdyJbChMw377PVzjedVSkdQqk
	aRqB+p9p3tBrWE96uCHFLgkuMFOm0DtdhASry22GM+AeAzn8pqTkXrW5ImqnA4jFnwLtPA
	ugKMo68x+Ny+7NRS7t5kCWtFjhE/b54=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783951127;
	b=e5LCoaQNiRGqe0v8Ec2lTsudSZ3B3W32oPq+5oInjGyMO5pkc6KiKMcmRxKiuBGgn1lJX/
	JRzFKpXVoQcDiWPAyqTeM0vokGcSCW74RQh3U8KxvtkFJ4e01OVWomjTTGldq5DPBsAlSf
	ncwQsz15xYQ7TD1436uqzrpKWVdXWtA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="LQ/zMYiy";
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C83FD40978;
	Mon, 13 Jul 2026 13:58:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5565E1F00A3D;
	Mon, 13 Jul 2026 13:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783951126;
	bh=SKLq7ZuoHq2BFm176pu4DfNEYfPU8F0EbpgzHa8ZXlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LQ/zMYiyDc9DBS+2PK4RjZYTpHzO2uSG2unKv5GwCgnDUqdMiXhJTqI0CAFZAa/3P
	 1VHFTEGSTxLynIIT943yFiCNPlZs2qYLlkPj5Lrfw3eveLRGKadq+v8/xT17JP2OpH
	 L82xYFFVjkghxdfAMdHlpQzTJEh9RWCz2fVa3BBJsjN/WjDZR49JoYSQ71YyYsSRaF
	 RDGRPLh6A1tTvWXaOQvf8hecqWIQ21JwhI3GXDDS4vJnPKRN/RLhDiRbTNbz5gq3Eq
	 nd1bC5m5KLvePmsUtrEd19vJxmscIWClZ9+2ZPN9UuOnMDRbSCD/38I76b4JqnZrzo
	 bKvk5Ooi9Yn2A==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	SeongJae Park <sjpark@amazon.de>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 2/5] mm/damon/tests/core-kunit: catch test failure in test_merge_regions_of()
Date: Mon, 13 Jul 2026 06:58:33 -0700
Message-ID: <20260713135838.32730-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260713135838.32730-1-sj@kernel.org>
References: <20260713135838.32730-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7C75F40005
X-Stat-Signature: qqqsy7834iapfczywitm9dj7rue1977p
X-HE-Tag: 1783951127-517621
X-HE-Meta: U2FsdGVkX1+snGw0yKxkQiXUeZLdBDFGkK8IshJFFY8jvpkZPmVHPraov0UqB3VucHZ5oNKMKK3qNQCSxOKKC3+76SoTQRCjsp+KIvjuJRgxfTosG+gRXG+U/AKzXmdN8otH4nScvQqnzgerf2iwt0sH495Ztbelqn4NRBIr6cTELCNi8vPLiymT50poLBWUT+SHWi6k5nrNwreuWBcDVZAlatBMPALHNjxCD1q0fyGQ8jAVoo90gKSIKitaDHHhr1n2B4B3++aQ8tvZc7VO9tJVzj18lEPM9jlcYqOkL/0rljimSp6Temgrk1zhUUppbdNCWapedIotBiZpRMMNS3RFtRyzsVwAdnYDUSYgyLj8xf6XbXAcfG3ujzDvN+l16/si5Dq8z4vpd5Z1CbmODzFXjA+2YjfzVUiZxu52wfEA4BqiBkp8zppKSuaHHfpBrTtngx212goBolnK1RNnw6wAineXRCfLfCu9PVhPCa4CBEN4QMvlpnL8UjZnWHXuMkv/tM5HAkcaFk+H90U1shKDxv4FO4SzPCO2yWHRYlJ615edG+fdRYQIt66G0DRwHRvnH83P/SOEkQOdwPSS6cfrDtKtIAaySf6odkH0VnCmyOdvezOUY0MiLMsgOQ9/Wt3NGrbslZoCEC0Km0ZAk1vSfUyMJTcir3HyOuohgC3vVDrFM+jZntd7Yy9hTwQ7DKTHLqmwRd2CZOZvSGzyLh8en/D90qdaob73Aaowzp0/i7bZxMIEpHwFTZ0fxbYXsE7zaHxe2Ole2Aa1SzqFFgZVQ1hdLNOFij7flqw2O7L6aH6NHAmax9xAJqrSHIbiofo6wfFHyuztKO3OZZ5rUsBCc79HzR3NoKdJogtwhrah8npssIsSUIoAtPFZmMI1+ejv3pp3qGxJcSuDttGRDridNDbjyxdGDepUSgLkXUy6MR8NEzF+hYL+nsQPKgU69ERkfteFeMn/sBjOQwD
 drKSbNtk
 t5zDBrbWEAKqjBZ2BMHTTG1L6vvLGSdoa+BXWlUU9TzSCC2qVaIXD9GKiPUtq2005GJ5B7epmVxn7oweeA94xNMp05wU2bB9ZTo+yQI/I8rXf3+FyybJlbdb2DHte9xL112XRjeo+0bxNWu39cKJmmKw+Q+A21LsKTDppZDoaIhPMS8Jy0c8gwSz7008LApLUpdmJ7C6Jn8/W1YKOMI1VCM4TBHb2omvSX6VFk/Z659Qt/99FzTRAf8s7W27+mgEZS3Jm7zgX135f30c3gkaCTW5als3750CpcuQUJtLntfnps7RvQYiiYru783ISUqAObXXp
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
index 6ad73559dd8ea..a99363720e677 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -260,11 +260,14 @@ static void damon_test_merge_regions_of(struct kunit *test)
 	damon_merge_regions_of(t, 9, 9999, ctx);
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

