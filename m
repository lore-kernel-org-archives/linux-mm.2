Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E623CCFA18
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 18:44:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9308A8E0008; Tue, 11 Nov 2025 13:44:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 813918E000F; Tue, 11 Nov 2025 13:44:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 701EF8E0002; Tue, 11 Nov 2025 13:44:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 588018E0008
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 13:44:30 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0E0CEC0175
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 18:44:30 +0000 (UTC)
X-FDA: 84099201900.14.3B12A93
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5F4E44000C
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 18:44:28 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=idvbzuY3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762886668; a=rsa-sha256;
	cv=none;
	b=IiEtGH1nPsQdSQdLUNLwDa0OSFfQ3pY+UMVZDmzkekuUmhzaBR2rfeyw1e3Uadlqe7WCQ5
	87C6ckoqqbQGQlWOUJi5xXYQrYw4sY5b2/8gW2W+RPU+PIU3TQe9vJWYTM/mTxyyd9hdc9
	L4eFyeJVboSx7/WjeJ4ACaiHLdA472c=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=idvbzuY3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762886668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v2klNEOgM4Ottd1GmQT2BW86R6f0yfUbqFlm9mMt9x0=;
	b=RCgi+QvGudD12g8DrFeNdxf/SwRa+KrMEMnMplVlwmaOaF6Voq+5yh1WorOjJlh/RastrB
	ZAwYF89KlGaa8QoWjnSXGvAtCh7ZX7Cp/S42Q4Gm0bJTwz93h2n0Sj+QCLFdR5M7k8LdOQ
	9wCsNrTzMGC/nVhds95w8Pa2QTDEAY8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9365C41A94;
	Tue, 11 Nov 2025 18:44:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C9BCC4CEF7;
	Tue, 11 Nov 2025 18:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762886667;
	bh=zbEUetZe1c1xcRt1OCgTl8LCaIpsolP/79QDN3FVibc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=idvbzuY3Y/fIkegrqp6zLZHd6RqtUjeLzgaU25symERrWFb9VGucHpztZYkxG8gBX
	 zyj4TMqyKJIPIyOHgGgJ+AIy+//vqUn3UnparLqEoQ6oDLQBYeCjN7fZQCQd/xZ01w
	 MvoCymFWU+ME5cH7oJB0A6sk+8l/1/Uee7OWMNnex3X7C5J117SYwPHVjPFrITdZP1
	 LRE/tyJhCb2Wd28LRm3m7umdl87k+PgjhwDeLjgHOdSQ5sy9th+r56qKMwtK5gnDTr
	 zUvCqLREHKdH04OvAjgLeEZKp+tp5cdoc2zYAFsA8JhzbVis0vEnfmpiRizxwL6iYu
	 Hb6Ovr6IVDIVA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 02/11] mm/damon/tests/core-kunit: split out damos_test_commit_filter() core logic
Date: Tue, 11 Nov 2025 10:44:01 -0800
Message-ID: <20251111184415.141757-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251111184415.141757-1-sj@kernel.org>
References: <20251111184415.141757-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5F4E44000C
X-Rspamd-Server: rspam07
X-Stat-Signature: gkyniwifhktor144eaznc6j41fahd3qk
X-Rspam-User: 
X-HE-Tag: 1762886668-153138
X-HE-Meta: U2FsdGVkX19MuVCT5Kp2rPrQvBi7U314g5XKbzlSWi0d7nzpz9J/mIAPbCk3fgD0/5zYSGNfBY/NWdLUBJ2zMcSye1rpgqiNo0fwBhGLwFRB5aBEyZp3U30kig444YjCpqvDCTa0xvuOBfCwT/lNQU3jgSvN6E+N510woJk1H7xQFO3kuiyGYJ1devhq6QluHHIvbid7OrqTVAJrGvcSbRv6GsDBrvOn/g8sTHAs1pX0MKhqdduoyxIHpfi8xC2Mr9sKAMZze4QuVSKolWtMY/be7sV6QS2sMZVvivOeuxdljXCmwmBc58Jp9F30wPybZ/1S7ubM5vV8xWOLXL+g1sd4SxuQKIF8vQpdb5SzVMtDMNdTSn2/Ju7rYZgBkSYaJWKhIxfnYkcWolS202kSrKbOkHABDwNYKNNZbbmmtge7TG++jQNhPeK8zFJgkhBwmKcwofAClWBV/zP4I9Potui57lzN/n16tRgC/+c7O4vCUIDNmmzXIy66ZsUeRb/fOQHULTCywe3QPJK6y2x9UWZdKbee4CdRzakfgJ8w+4xaD5ElQTAEbIVAWZVsReV5xSZCbIW0Hd02BQ8DJbkJ+LMG8Gqr2Vx0+DchKuoq0mmuy3bpQlE7a7wICn0Pauip+nFY6fbx5JyP4O2MWrYKxLHQAwftK/glnzXtDPc4kTISADO5U5Rl+gCnM9kmta1znU4uC8cxJdeSmdUo2YMTTAJWHkNI+UzQ3TdXU6JqGBE3AU8hKx/CNQfX6QTXeRoE6exxN3DrQe0FjMhohFlymyZeHlKd6wnVmkbdWczxOHF8djjg41sj4szZ3d4MdvnYm8BQFdBLelrDqP1yCfUFWP+rrgvoKQHANHeepyeqcc1sQV1JGOo5LIz6SV10zrnI/kKPSBHdLh78d5nHW0HZxJpNZFa+ItuyP72k4gXVQDHXkKcgoHSYRriwrpr/buoCQjZ/pxLbZLkVgtq19OJ
 xDu2vi8S
 bDKlvKc7XOdKO4arHiLdmqConIgD1MnUsQJ4rWuri4F/wI3jD76H6c5ptnhLmNnJZVWmtfoez00O2FX4tDXcuH4Rlm8UOrp3kf7nzE6LSpsaOzB7rhoUdKxyhcKns/GqPASRlix7NR7QtmYEv6kedQspkakCVr4zu1I03Q42VgARSzXQXbFI+8KvBxi8z1ckQs+GEsFryC3s3Us8GeNaGB4KXoq9+dLNGNHKzUzw4hbtajqn9gUcjWiWxWl1pebE1678lSqFBf4V11n5p0O3qBCyGRw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damos_test_commit_filter() is written for only a single test case.
Split out the core logic of damos_test_commit_filter() as a general one
so that it can be reused for multiple test cases.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index ae97886137dc..31f90cfcabf3 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -497,6 +497,15 @@ static void damos_test_new_filter(struct kunit *test)
 	damos_destroy_filter(filter);
 }
 
+static void damos_test_commit_filter_for(struct kunit *test,
+		struct damos_filter *dst, struct damos_filter *src)
+{
+	damos_commit_filter(dst, src);
+	KUNIT_EXPECT_EQ(test, dst->type, src->type);
+	KUNIT_EXPECT_EQ(test, dst->matching, src->matching);
+	KUNIT_EXPECT_EQ(test, dst->allow, src->allow);
+}
+
 static void damos_test_commit_filter(struct kunit *test)
 {
 	struct damos_filter src_filter = {
@@ -509,10 +518,7 @@ static void damos_test_commit_filter(struct kunit *test)
 		.allow = false,
 	};
 
-	damos_commit_filter(&dst_filter, &src_filter);
-	KUNIT_EXPECT_EQ(test, dst_filter.type, src_filter.type);
-	KUNIT_EXPECT_EQ(test, dst_filter.matching, src_filter.matching);
-	KUNIT_EXPECT_EQ(test, dst_filter.allow, src_filter.allow);
+	damos_test_commit_filter_for(test, &dst_filter, &src_filter);
 }
 
 static void damos_test_filter_out(struct kunit *test)
-- 
2.47.3

