Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 837FCC44515
	for <linux-mm@archiver.kernel.org>; Sat, 18 Jul 2026 00:15:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B60446B00FF; Fri, 17 Jul 2026 20:14:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE7B66B0101; Fri, 17 Jul 2026 20:14:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D9816B0102; Fri, 17 Jul 2026 20:14:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 69C996B00FF
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 20:14:49 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BD5A6A02E0
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 00:14:48 +0000 (UTC)
X-FDA: 84999976656.16.26B7827
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 40055180002
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 00:14:47 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eCj3AtKT;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784333687;
	b=UnLyh9JOGj3CrvluM28DR/mH3BzrbzKF9N1f+6DSKR4D7YwDEzvUCpwOIh562hBQhHX6yR
	kEWo5zXKQ2V2ChVFNpVAqaQCsVJfHF0WdCUU9mkcre7Kqo/dBVwCP7+O1IocpDVpbP1T/b
	SaR/L2/bI7fvWuczlsQEJtVgJAGkyZk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eCj3AtKT;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784333687;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cUz2au4OyIrV9kPXUAznd25PGFTMj7HneR6m36jCxn4=;
	b=fn3JKxnPUoriSRcOahjaL1P+ZTosnxAxKoqfGBkLE96nAsVAgqFZGl0oIqZ2bZvhT3ipvL
	kmGf4xPyL0+ISHzLaE3teeIuJgseLIUXu32t9/TSkDpcCktgIVnDW8trGD4wd8iWmOeieA
	ZOwRurqMmALtWHZ5RLJD5ltpG2ViCNg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BCC4F60DB6;
	Sat, 18 Jul 2026 00:14:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28C181F000E9;
	Sat, 18 Jul 2026 00:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784333686;
	bh=cUz2au4OyIrV9kPXUAznd25PGFTMj7HneR6m36jCxn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eCj3AtKTOWh8nwQAmfmA+VQ82bpReRimwkqApgoi4pVQ/HsvlN+yZHblj8TcRlGUw
	 tDETKiD2M6IRi5Q5yjrpbxdAaCASAGdrussfsQabdATc0B8ncyq49ArJGyb4dP87IE
	 OpEELBOety5Bg0/VDJ1OUn01wVfVpdcrHGQqVVY/8TQ1Vl6cbfPQ9jmI6865zaqwmY
	 kKrocI7c3gHhWJUiZZwZTH86jQQ6kH469emNKPNBU+Lvhk1Q4r/VIU2b2EfC5Ab4L5
	 lkEW5JzgBD+gPRMUdbYXfXYE1ypd0V5GZHUNcr5ohFmRl/tjlMX6La3brUOTWbZ5NU
	 o2C5ggz61+K4A==
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
Subject: [PATCH 4/7] mm/damon/core-kunit: handle region split failure in filter_out()
Date: Fri, 17 Jul 2026 17:14:38 -0700
Message-ID: <20260718001442.87129-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260718001442.87129-1-sj@kernel.org>
References: <20260718001442.87129-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 40055180002
X-Stat-Signature: 7g51xfamubgr5wx5z6kztz47ipuytstf
X-HE-Tag: 1784333687-509276
X-HE-Meta: U2FsdGVkX1+FoiKYOVKjMoRkTAi0yrdRGvhB4/Xo5Buoyn+PjmKOl55wNhgurvEk/HiC0FdHTHwl8KHgF1yOTQvghX7CXuaxKp7HBJYFd3LDt6F70OgFKwr+L+cNC6+tUkeRIzVkPQdulJAf90P1JHzydba7VAB3gFmsANHWqZ872+a1/qp7DEA5OBixHMLi+fGK07hI1kFgPl9yj5OKx0FnampCNR8WCwbyWITVWhny2r3lJyKiDpwHx/lbU31gwTGz+iCit6eH0aNI+FZ0ZgvesUt8sh1v4PmhZW+BK/YjuQqxA30aHIhUQhW+TfI8y5HQYyIr8azD9P0rzSm2XSdQAOUjRGuyVcrSwk3O5l+vRs5knVn3JFc6yWhFeS5eLrehJiE9o48ypTXl9INFRUlIQMYwSj3T/BB0TfMPkO2/YXX85EvzTAh+LGosYsJq0AoPhQdyFigbg/sqVKbN97RYP/m8WhFopSzYcjj5c0XKdS1LPij9kYrpCCyWzp8Ja0+f266IabbRDMm23g+dUyNxUo8g+l5uE54c+WCT1dBAmGE+74JuzH2zuXGgXguAk9oHoFcnkbS9rI5wyPoJbfcf9nzRBcO+bUbuU4p132f1JGNtnd+PXZBFGlsLQ/joM/HgpdZlAGlAbSNXrVm6nmW9eIr55gb0BXq/q1LAWdOd9TgNrrZPXhXgW+4MNKQDusfRy81PFR4+mJhpl/XbYuS1iKA+shf65luZtv4/GqF66Fn//jLcXbsRUSsrgKFXKOGexH8rCcOA1ljMeN2PkkaBbzcka+8iSZHzimn/0/rfvSe59ZaMzGbQojevIcghQX2gGCVCQP41yypN0fa3TK1YNnOU9Nfoo+LBkR5GLELZRFjoAoHS7ZvlP1XONYuhQtHIybbNIe4DNOYpWRwmm0nj6xtVB37zuCyYiT2GknSRnqQkm6nWyZC9zLQZJbo9ulRAUbP+8xTRmJiu1iJ
 dTMukytL
 P8qn/ZrvhIsgJuFlk1gEJg4eRsUaA2YCJ+wXwFpzAaSw7iW5W9cO5Efopy53xKLsLuZiDCN1CPThrG1fn1BF5rPjOjRcE1rsJ3VqR5KE+Cj67LqrkrRH1eSj/qgB8+dyGMUhjwLgAJUZ71jRnWHjMMz2LZ2nX/vHTSMr7RjoXK9BOljuSuuSzti6wKL39FmmCJFSVEz/j7WHVDLYwWtMchPT9ubAZ0j/1PUqFVBNVV956ac45XhEu4TumVJxSUV57sUMl+J1tU2Ok97OLlmHI5enQbA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

dasmon_test_filter_out() test checks if damos_filter_match() of an
address filter splits the region as expected under a given condition.
But, the test continued regardless of the split successes.  As a result,
the later part of the test could dereference invalid pointers that
returned from damon_next_region().  Further, it could corrupt memory
from damon_destroy_region().

The consequent user impact (memory corruption) is quite bad.  The
realistic user impact would be limited, though.  It would affect only
test run setups.

Fix it by exiting early for the number of regions test failure.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260714142352.100478-1-sj@kernel.org

Fixes: 26713c890875 ("mm/damon/core-test: add a unit test for __damos_filter_out()")
Cc: <stable@vger.kernel.org> # 6.6.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 322a295ac2cec..eddf3a0484583 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -1365,6 +1365,8 @@ static void damos_test_filter_out(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, r->ar.start, 1);
 	KUNIT_EXPECT_EQ(test, r->ar.end, 2);
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 2);
+	if (damon_nr_regions(t) != 2)
+		goto out;
 	r2 = damon_next_region(r);
 	KUNIT_EXPECT_EQ(test, r2->ar.start, 2);
 	KUNIT_EXPECT_EQ(test, r2->ar.end, 4);
@@ -1379,11 +1381,14 @@ static void damos_test_filter_out(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, r->ar.start, 2);
 	KUNIT_EXPECT_EQ(test, r->ar.end, 6);
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 2);
+	if (damon_nr_regions(t) != 2)
+		goto out;
 	r2 = damon_next_region(r);
 	KUNIT_EXPECT_EQ(test, r2->ar.start, 6);
 	KUNIT_EXPECT_EQ(test, r2->ar.end, 8);
 	damon_destroy_region(r2, t);
 
+out:
 	damon_free_target(t);
 	damos_free_filter(f);
 }
-- 
2.47.3

