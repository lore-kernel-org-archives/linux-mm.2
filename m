Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5D19C44515
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 17:02:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 505666B00C4; Fri, 17 Jul 2026 13:02:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DD466B00C7; Fri, 17 Jul 2026 13:02:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F3516B00CA; Fri, 17 Jul 2026 13:02:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E2AA26B00C4
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 13:02:44 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 518F2A013E
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 14:34:58 +0000 (UTC)
X-FDA: 84998515476.03.AEE1484
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id C537F10000B
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 14:34:56 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ICVbrfZK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784298896;
	b=PIUIEXDuojXqgQUFRSNdCYdFYff+vEarMkO28xR+SUcTJiv03vrJVsJnYiZp2YwLWWqg8U
	CQoiPU1PwngKqHtoTK7jS2Mkr0Xt3rwD55xqSED+KZnU3jmokoxAjrrmlK6wuAx8LAZn5m
	YRVHWGdPdztQvdZK+OLKT/uvW0eZRcg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ICVbrfZK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784298896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hlaPqrC6aZ24tUVqmNoMgW7uRiUtt18MWvor7D56nnY=;
	b=t9MyCfIBA1IvJaSckdZs4DZAa8TaVtIHhXf0OPy/WGCKU7pCngQbOmDcaVdhY5pgJnscgp
	vm8bCItkWGKT3eNuTWbf3gelMARzEaGsmlgFexlWvvwhaRILzWFfzeCEfYN906jbdf7lW4
	rFUDT+DUnN/JCM2lVn7xdVtm17k8kBk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4ED8C60A6F;
	Fri, 17 Jul 2026 14:34:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFAEE1F00A3A;
	Fri, 17 Jul 2026 14:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784298896;
	bh=hlaPqrC6aZ24tUVqmNoMgW7uRiUtt18MWvor7D56nnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ICVbrfZK6cVoxKsi44Lk4Kn3Gu6CpPdntck4mGTFh7AtJHNjq5PJbquA1SUbvvpjC
	 zeYNGiTp3OLtzdArKhatXEgccYWS3FM53j5VL0enYSv08EWGPfXiihj+W5I//u8lwp
	 j/DAdd+qZyJp0zdgAyyypLGyDFBv/9DaRUzqC3Iog2zT6rkO5eG5JcHg70+VnTm2CG
	 NLpDLqkLRV8BxPP3kMPgfTd0eem0YnEDrwZuKVDoN4bZk/jMNm6W+XiqB0xYXw74mO
	 4Mj9lF0CzsdGctP0DXaezJsyy1m6/x4JgN+sZy1WBRs2vajYtHZBM96BriXFE9Ur57
	 XBk4OWMdrOjkg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 7/7] mm/damon/core-kunit: skip wrong region walk in commit_target_regions()
Date: Fri, 17 Jul 2026 07:34:44 -0700
Message-ID: <20260717143445.91207-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260717143445.91207-1-sj@kernel.org>
References: <20260717143445.91207-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C537F10000B
X-Rspam-User: 
X-Stat-Signature: nktzmzy6b3w8g1sremnxfpwy9qxn1drh
X-Rspamd-Server: rspam03
X-HE-Tag: 1784298896-449328
X-HE-Meta: U2FsdGVkX1/djYSVGYctwiRVQg/DC6zx8sFZfSatAXuJjXLAo0wkAmOvk1B4KBJVuuD46JqTFjZaILVBrZp9tVLTKaw61JuPmmPc9OwGxv2v7FkNg0VcS9mwnSy7OC4re8WRXjJfXDmg2mB4lzt1HMChkrydH6UI2KMc+ZKXEGgNnP2RpvBQyJFyTwucmbo/kk8cZMJ1k+fk/ncfdR5s81aS9X+zV8egBnUzNqXyyWXCqW1Nq21O4T9C76HcSieQ3WTMKdDcWfCFRHqqzSn9V2crNG+5Us8Vw3aD+fI5dWzenRKiZ4uL0dALL+hqxG2IBn4xC+yuJBVCIezi34z+Ajw3ifG+DCZaaLXjN1dqmyRRsQkmCsRp3F4KSjESTW5Km6IKO/Ss+Utu0Jr92XtRTpfgVaNZSwPKd3jy5w9nmGI4A/PAxEVRGfyG4Kkzw0t2QM6uKB6loCyDWkSAJBgWmenRryUXwHXkdec1aGLDUURafciNpeVJVjOfZ5VO0EyBMk4ioeu8WbeL5TU7HQ/kHJh5kVsCHfrnd2Pv8KlXK/AT8DQdMK9JP2+2elVmtMSCt95te+UNfyeC2b30THaAVc+mdYuY4BaCLRE3FaS/QcZjgCEYY30lHy8ERMREsGXXkNZ0foYmvS45JjPe1kie9hzLsCpTc8IHI7+iqKmxeUlzRoPpkKmErXPZnbImb/byYJIBgU3SYEp2Q3RjDcmVtm5rleotnfDD29LpyiQrxQ49SXW8n5txoHCYvCy1gN9OpqbbYtic0ep+VwLMydsyPcP6A4jUkR7iAlh/mCXIOkeh8We5kDm0LZk6TEr1ulVeBoWayIF1jsbtj30ogqsR9/W82caILnwRxfUh3Ws3t9waF+g3i4pCVNlT5/ZXUgfuo+4Z9TixxixwwJmhudv8GRF1O3zIwj/oDefYDyf+0bF1ofx4BZjcMf2GxyuqeWCkoQ2Zf1jLq3CWUqRSYBB
 cXFDNNQR
 imcdtAmD03v3m8oK6akQ2NyunkBNzre9bTchaC70zhnj+QQewmkZf7+MBQOBv6GYMPVRTeGXef/GbOHDcaY9gPmuaKUm2BQ/siEv5HZYK4LzZicNKTCnG+4vy5IxHWrOCw8CQllBT/+wH2Zh656l+CxlP+ugxNbJJ/Uekk6++qRkg3t1CNMNFLPsLBf14a8L1p17pDivBFj0hP9Tphe6wP2u7k+ZeN9qX00U4WZz3YNiwBDQfTgFCdowNCFtMSf+lPNo4aGBaCtbfzA/vusdWFMv/1A==
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

