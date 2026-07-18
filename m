Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CFA3C44515
	for <linux-mm@archiver.kernel.org>; Sat, 18 Jul 2026 00:15:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 609C06B0104; Fri, 17 Jul 2026 20:14:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E1606B0107; Fri, 17 Jul 2026 20:14:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 458686B0104; Fri, 17 Jul 2026 20:14:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0DD736B0104
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 20:14:50 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 227C01C036B
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 00:14:50 +0000 (UTC)
X-FDA: 84999976740.21.F244577
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 87E4D40004
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 00:14:48 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DcZST0Jy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784333688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hlaPqrC6aZ24tUVqmNoMgW7uRiUtt18MWvor7D56nnY=;
	b=wkWtlKG16P6y3hSCVwPSgR2gtZaAnuBUYwqnYoEjsDOY6NIEcAk5GtRU94CYiocu04+KFY
	l5q9TrY4prgO951H/DaaofleoghX7105TmQ9fqRBMgWrjZtlY7ZNrnPpYuzy6RO7oRnvlW
	8yLeSkpUvcGf35gNnsa7TdmsfbHCFHo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DcZST0Jy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784333688;
	b=JczfBOoVknHLt3/+d9ouroYoiwmdy/UwXDSheRqWcBN6obgsmBBwdJ425C9O0/ak/h+Cqx
	m2I4ZNasvTsmV6mSGr6dTcInsRdBA+19DqZyFhHiOTQLSG6GGC+hFBOkA9i+ImWrbKgqRd
	ywUYYQphaKAZpqgsUp0YzZDLYsRsd0o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 34B1E60DBA;
	Sat, 18 Jul 2026 00:14:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9137D1F00A3A;
	Sat, 18 Jul 2026 00:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784333687;
	bh=hlaPqrC6aZ24tUVqmNoMgW7uRiUtt18MWvor7D56nnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DcZST0JyZ+VsKqU9PvOID36E9CRrNSLnOGd8EFTWxNPgb/FkFEKw7G8fsXiPmcgtU
	 Aw8pWXa/P+qt01XtysDSejd52LvREX3r51PgldBJAJkTI55yAnH92FgrZ0CkdVMnEb
	 Vu6V6vKTRiMWDLz7evQItMSQZ5WPpAMRxFipilfAbj4fr7j+FmkqR18ef4u5lr6AoU
	 b6fKlaC1YHNFVRf+en/jSKYQRAz6xfr3IJm/QmICHoIjDEfiRK5f1OGbBQy4v3NswL
	 lStie6B8ySy71K8yKxdIn6i2qT1+Ok/VKVQ/N0o0O3PaqT+qtPQLncD3da9gsrxScq
	 UjnGKstrcxxVg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 7/7] mm/damon/core-kunit: skip wrong region walk in commit_target_regions()
Date: Fri, 17 Jul 2026 17:14:41 -0700
Message-ID: <20260718001442.87129-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260718001442.87129-1-sj@kernel.org>
References: <20260718001442.87129-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 87E4D40004
X-Stat-Signature: zpriegahgthsjjmm5c5uo9rxa7o1qdcq
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784333688-960821
X-HE-Meta: U2FsdGVkX1/LF8woJQ7vayJ/YzCsUt2uIEp54TjwqoEuiZQU7z6pB0O4MebVosKC1AsNbg0U/o3G+VHewZ6ZOJ2mIGhCD0QU8dyf0riIFTSMkiWw7DR4BPmQ9oOjqTyYjjF1DjQZcc5egHGKq04yvADDt9430hEZxAudQpJ+9zZec5Tw/TX4BF1GwWMtfIHIIm/gbJqsLI61naZxe2JAPb/N8R9/hFOyIIJ8OTNAhYVjrlX9t2WjJqNNJhBbklhfg5QRlPNf6NTk9yc4zUHEUdNnJgpjfyFoM+wDrLB8TYy1sXEtVAf295klkuKK4HuRBJ+zclNq7Jz7EqotfNFcj2VvnXKHeDNpuboEo88tIvh5DUcN68zKjmHLGrvuR+yDr2GSzz1u2rmH8PKAOpKentUYMw1ru+X5UDXtpyjUbcaBMW+0eumXzkqPrYlHggW8rRu8wrjW7Oq78HeInQtqJqdSv+8KsDAQnUlEs/2mDsSR0A3ZrWNMnB9cWHCwxnbpiH+UOxDcqVOI4MJWEQjhz3g4YLcdDa94XAJtHYzD8SbUOIH6IrQfn6AIfr06a1hijEso67fB2ssQ3zj91NHtqKyNmPY1WoxRCZiVGJWcEiG1zS60921QzMfTxxUQ7qMu8mynF2ZLdt6NYxh7GP53hhxK5A0E8NasNP0jcJh0hfwqWtbWiH0EbubHNSoaliI/tpzsZrxUdug2kbz3MYdHaryqsGTa6RgFASIjebZSc+OrgrJARhImATiEw0AuhFcp+TKPrrKGViPq30RcSdsLrlPlDR0KvEPTmgsfp9tDALm8T6AgaMVVbvxZ7Y9dlm5iW4QYP/MI0ZH+kT9bNS+sC58dEbDPXjC+SacImoVVsweb3lqMFp1Rh7ndSTWOUtHP4WqVhydUcWzi/HluYGtbadDmQ7AT9ym13xwNJ4p1Mc+AUYGYEVXZO6wl7g3ROB/z1NF6bQRKf5zu3nsQXTF
 o2Ld82nZ
 g1ydoELyDbyG+Q01Hw5e/T9jG5Ike+FOVQIZcBIzgfbUcKERuEDHuoHWY9Z9whEJirdErGa16z90V4NfWe/6+aB88281xqZLXQqWva5pLw7NW3362A6cuVsBaE3802IgQscOIkpfkKTILPeb4h6nTRTcCwQTmpwSDonyNPtKV04wrkD5xIODna+9YkBrBd4QCwy/l0MPZzUO/9K+ou+f3b7QgNJelIdviM3GgQn2ZHbTWhpXB5etDM7WvdvwDKVA/Qxu1mxi+8XtrJCCo40MbuwwAKA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_test_commit_target_regions_for() traverses expected values array
after damon_commit_target_regions() call.  It assumes
damon_commit_target_regions() made expected number of regions.  It might
not.  Because the traversal is made based on the region count, it could
do out of bounds access to the expectation value array.

The consequent user impact (out-of-bound access) is quite bad.  The
realistic user impact would be limited, though.  It would affect only
test run setups.

Fix it by testing if the number of regions was also changed as expected
and exit early for the failure.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260713144757.39740-1-sj@kernel.org

Fixes: 603f67eb91e0 ("mm/damon/tests/core-kunit: add damon_commit_target_regions() test")
Cc: <stable@vger.kernel.org> # 6.19.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index fbf986aee2dea..4a536d41cdb2d 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -1277,14 +1277,19 @@ static void damon_test_commit_target_regions_for(struct kunit *test,
 		kunit_skip(test, "src target setup fail");
 	}
 	damon_commit_target_regions(dst_target, src_target, 1);
+
+	KUNIT_EXPECT_EQ(test, damon_nr_regions(dst_target), nr_expect_regions);
+	if (damon_nr_regions(dst_target) != nr_expect_regions)
+		goto out;
+
 	i = 0;
 	damon_for_each_region(r, dst_target) {
 		KUNIT_EXPECT_EQ(test, r->ar.start, expect_start_end[i][0]);
 		KUNIT_EXPECT_EQ(test, r->ar.end, expect_start_end[i][1]);
 		i++;
 	}
-	KUNIT_EXPECT_EQ(test, damon_nr_regions(dst_target), nr_expect_regions);
-	KUNIT_EXPECT_EQ(test, i, nr_expect_regions);
+
+out:
 	damon_free_target(dst_target);
 	damon_free_target(src_target);
 }
-- 
2.47.3

