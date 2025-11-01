Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16156CCFA02
	for <linux-mm@archiver.kernel.org>; Sat,  1 Nov 2025 18:21:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8CBD8E0012; Sat,  1 Nov 2025 14:20:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC7838E0015; Sat,  1 Nov 2025 14:20:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6A7B8E0012; Sat,  1 Nov 2025 14:20:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7501E8E0014
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 14:20:44 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 24AFB1A01FD
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 18:20:44 +0000 (UTC)
X-FDA: 84062854008.16.BD2EF09
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 72C08100003
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 18:20:42 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Imjr3I8O;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762021242; a=rsa-sha256;
	cv=none;
	b=7nMuFFTa/gNbcrjq5yCu278r8PxLE6I5MmTzokYJfcjLwxx6AD0ouVccdW3ybTJxGCgNJO
	r3Uc6vHSyiWMM+0LmS6gsuUH1XJihY2JGOgyFztb9GMQexW5z35+SuF7fDZ77wCOJvUQSQ
	iC54eXBk70hYQT6eK0u7mph4G3bw7Qo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Imjr3I8O;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762021242;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zx5Mhpt4IhRIoIdAqxEP/1+HQ/6YSjzP7ffvHnY82Ow=;
	b=Xu8RcbDzr+frIKJ1XPBNodnRjZIi3MsGsbUGHMMQ2pjmh+jzHsIxiXNHd3L3w6y20iAkOY
	WTWGdODy9BUSeG7iG1Cz2x28B8HFk/OPR9kD/iy5CqHQa5YVC8N+2Jni6qLcmdjBLGyOgW
	2aPeMMHKZoj8xgxz8dT/sEONuSSaDBM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1466F4403B;
	Sat,  1 Nov 2025 18:20:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6BC1C16AAE;
	Sat,  1 Nov 2025 18:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762021240;
	bh=XQHOX0L3vnaITOpKzT4V1ps8fyI4g/lGuTAfNYAXwxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Imjr3I8OuNTg5Jna92aip8rzDvyfRpHauqHGpTvTfxPPVWB7HZ559aZLEngl7yTsL
	 WsQiSy3lb7MATQaG5cMCagUHftewHz9Y7Rc3BznXFp44lPsX7g88xMa1DAT47Sb7Dg
	 7T2ssgB81oACG+Qqi0V4dA3RDcK3h/YHX1ZPjYXjtNBcH6rTgCOOdbbTF8ef6UsCOV
	 8GCbXS9gvGeHCvToxcmwmaQnSFzIM0SyybVQH6TtD5ImHuIC7V/QiWVG3dbdIVybH0
	 7f3ipUat6vqcfFBbr2X9bfPdHnqDTygrcF3vn60OK17js1A1vg99ZmijOZB0xHfTe2
	 w1Jd+dwaikcGw==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 6 . x" <stable@vger.kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 15/22] mm/damon/tests/core-kunit: handle alloc failures on damos_test_filter_out()
Date: Sat,  1 Nov 2025 11:20:09 -0700
Message-ID: <20251101182021.74868-16-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251101182021.74868-1-sj@kernel.org>
References: <20251101182021.74868-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3dgjzuyk9hictaktwouwfqfqmqoogcm8
X-Rspamd-Queue-Id: 72C08100003
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1762021242-65011
X-HE-Meta: U2FsdGVkX1+92mpUjhnO/FXZ7liUOrL6+SyiTYLovZlQ8x12Nltpqb6WBt5Exdl/mHk1NxKtpdbxN1VvUsdVjUk0zPkdtEBEG6WVfMLVT2IoEe3lQSQk+v/sAgrQSrlPoybgdAcYT7dOPYrgSCZIYLzKqfeDgSJ6Tz8h6l/gvD/6ekmEL0+FE7AicVaHyJPbK0E1oYTEvai3CBkPHJHlVKpOvwh2yt2RKAfzSByGHnr0LiqWVxbAGMth/M1p1BHbHBXTEE2fO5QFnr2HA8ZYe+lTJJUN7PmeCy29UOxdNgqm/y2LHteQKtObkmWJqyie4TtyNYqi49U4Lj72uPwqMerxw7cpjXdehT8BdzZZE7I9B6FwqZyTT85zx3VeDrEGCHTizM5BqTAKWrpC38Y15p349RVs+VrE1Euz1hlZ0WpzCLBn0HqOTnNeCylWaum52muihdTSRnVLxu+kSBpMuyqUcMNkiCFXHqPo5+kEeMPui2IOwpc6Z7aNRcz1BUoz8OUqDP69Ehbi8/R0Dmz3A9nV7XXhxUhhUuq24CZeaEkS7Y9y7u0QfbNWJd6NlTJ6AizSn2XDgUQREYUDohDrPzF11B0SOWHAAQquHFXVCzn6qzY6nA/chNCD3SBCYzF+O8+JmncEP1t+P4RAjy0uBUH2Ev5fj6ePAEtuSyPb6XUcDjH0TU64QFA0pr196nygqumgjScOkdhOzXUoZsjjJ4d1Mzpcv/7SJn/mrxpEGemfdaeff1EE0F8r14Bd378t94S7AEccIs6qzP4ZB+Q0biP3GjrkkkKtH+oJ9ZM+Z0L6Ry6qGBLlgJUspL1dIUKY44wvG3iSL/1T/ayNDHY9gBcZzXRD3uuHBrIBm/4fod8e2qpEooAab2im08MaWyZ9mifTqqg8+/R9N9lPhJKaWhLxnrHFtehEi9Um1vNz0+KIk+xx0Vel/szBlFaPmBdmoceQ4oNOtFU9QbpYCHF
 lvtCfxv3
 i4sInZq8FLlsiCX2TNURfuRXcFmtUEPky6E4Mb9M0UaxEHweeE9wDoqcGtdZd7L/QzrCVc/Y/zyk3s6BedfT6jdW0t2eXxP50/Q1crVlNQa1FL3IBnwYIuhkltsPbyvN9L3Zld4o8GJS2z07swgjw9WuplViK2NDccTtEBz39rm3wMKkLt/g05zfHaUMw+Jt3vPr7MqQyzYoi+22FZUSEzbXyWkt04oyY1egCkib0jibocZxLHfzL8dprkCaFdB9nN5QegBaCoz4VdYWN6+TakIHIv6Q3k7gaYZbd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_test_filter_out() is assuming all dynamic memory allocation in it
will succeed.  Those are indeed likely in the real use cases since those
allocations are too small to fail, but theoretically those could fail.
In the case, inappropriate memory access can happen.  Fix it by
appropriately cleanup pre-allocated memory and skip the execution of the
remaining tests in the failure cases.

Fixes: 26713c890875 ("mm/damon/core-test: add a unit test for __damos_filter_out()")
Cc: <stable@vger.kernel.org> # 6.6.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 5af8275ffd7d..a03ae9ddd88a 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -542,11 +542,22 @@ static void damos_test_filter_out(struct kunit *test)
 	struct damos_filter *f;
 
 	f = damos_new_filter(DAMOS_FILTER_TYPE_ADDR, true, false);
+	if (!f)
+		kunit_skip(test, "filter alloc fail");
 	f->addr_range = (struct damon_addr_range){
 		.start = DAMON_MIN_REGION * 2, .end = DAMON_MIN_REGION * 6};
 
 	t = damon_new_target();
+	if (!t) {
+		damos_destroy_filter(f);
+		kunit_skip(test, "target alloc fail");
+	}
 	r = damon_new_region(DAMON_MIN_REGION * 3, DAMON_MIN_REGION * 5);
+	if (!r) {
+		damos_destroy_filter(f);
+		damon_free_target(t);
+		kunit_skip(test, "region alloc fail");
+	}
 	damon_add_region(r, t);
 
 	/* region in the range */
-- 
2.47.3

