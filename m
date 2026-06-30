Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B47D7C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 14:17:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F3D56B00D8; Tue, 30 Jun 2026 10:17:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72D8F6B00D9; Tue, 30 Jun 2026 10:17:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 642FB6B00DA; Tue, 30 Jun 2026 10:17:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2D92C6B00D8
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:17:44 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 92B761679A4
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 14:17:43 +0000 (UTC)
X-FDA: 84936782406.16.B0F1692
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id E8F9140003
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 14:17:41 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E7r7tMI0;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782829062;
	b=WANWeyYh48wCQNSDX5KqTbTU468CUB/8TWjBLPFPpREqmHIt55QCckRAnDdj+08B9JgGrA
	anRJu3CoZwnfMrLgrkzPm7zGCqss/xLpQzbnoCvXr8WL6Qvm1N/wx+dsCsMiradwY36MXf
	dztQVH8DEL523a+JRY79o2r0/NNCO48=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782829062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UL1zPOd9UwMDzVKB7bhTFiDOr3xTMkEdXRFwvMlUiCY=;
	b=e3jgl4DJwvY1iYUdfjMyYsS25kXK0y+f9ljWI4y2M3tUWhsU1S3jQtA6kGXMclHHRMg5lP
	PqgxedfCcCJlHuhjf0GeSWee54CpU3McV3FKyNIwVnSGNKOrbjUd+JvHk/7bJWj1QlTfyZ
	eYuw70YUMkx1SRLlE1eqTSdrBQJOeuE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E7r7tMI0;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3E0A444011;
	Tue, 30 Jun 2026 14:17:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69ECF1F00A3D;
	Tue, 30 Jun 2026 14:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782829061;
	bh=UL1zPOd9UwMDzVKB7bhTFiDOr3xTMkEdXRFwvMlUiCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E7r7tMI0wjFr1faZzbmUrzQCujOA26oYurN3d5aTw0SGW2guJSrCq21g0YRWbomPR
	 HhQeXpD4yYE8q6UII7rTOKtH1AgkbXHVAt3pVzk3gsxrZs70eGsLrKyuCfh3yYS6NP
	 z9BHPGJt/xKf6aiDAxfpovahhT2XFbc2cj0iNQXds0LSf/24ENmj8aVK7YqAtZh1Im
	 u2Z7oWV8DJYlBfcRJpt9wIlgY+0enYDYnMI936h2EF53cYQF1QG8Wrq983ib8SemIq
	 1V8Zfn2XAdhhogv0rk+GbIuhkNQv025BXZ7MVXyzhiNbUA4uSLB83liU35JUkpaBiE
	 nT9xyz8hnM9Yw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 04/11] selftests/damon/sysfs.sh: test multiple probe dirs creation
Date: Tue, 30 Jun 2026 07:17:18 -0700
Message-ID: <20260630141726.92246-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260630141726.92246-1-sj@kernel.org>
References: <20260630141726.92246-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: gwujxm7w6qj6empogw89tokpr9tmmrcr
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E8F9140003
X-HE-Tag: 1782829061-568872
X-HE-Meta: U2FsdGVkX1+MstfwyAV9kO+I4C63S8cxv3Cot61PnnR9BHU2e9UapNYMYpNiqsE17NnrVaBZjaicUG9NbZYTDDknGpDzzYvCNM4jyeqNKDytHX/r3VMmULNzwOca0ectH6wdoYBybD9ypW65erx9sKaRoJmuv+qvTkqp4gl0JUdq+bQTgwo63MCAQ4GqO7/MfvE6vzbv3qmffYCygmjKIcofhMfmfPpO8Kl8HhICrBNnvd7wDUlvbX1fMPvoDkM3mvf+ji2D14XUqbJcbySOlHvMYyAjMhBdyLRfW0/q4AtfuRSu0OgbLlidegQe13iI2AB78wgILXNKFCrUhcXm9k0b1iGFVNO4DbhgdZnyW+M2l3HlSxo11l9q9H5fZk6NYAUF5CAu6XL4t+1xpl1HFWewDK9oZRemutQ+2JouhLpdkv5wzrrHNkX062qarZA86bweWp/Soa9B6S20+KNJd9rKYb0B63Km6bu07HTgjwgE55IicRoizrFaGzgCl2pibPitE/BILWG8gZQLZn+Fbkg35o64WxWN9R2Vxz05qV8cp0RR669vCWTUwv7idiv9xxqG6DL5IYFHn/hPz1MfT4Pi7xIyy2Su+daJCmtfJVPfap0HgRMntO9TxVBkeNuwqjkBe8uBKbjU4H0sel5gCq8ieFmPYLTLyLJ3gKx/FfBt1fCb8JMZi1ItUDHQOm7XcsUrKsKwNQpiM2jmw6VneU/0q17H+HtjjoFE+q4UyAzHoafhlWy1DNpM7aA0BMWllMagwjmWHqThBZj3FhbMG3Hx2snGuPoveuUJL3aoP1aFEmzHX5iJHHzqf7OGrw2dfHZMvL43B5j2cTt9yicXyp1v8r37VYB7wQWD5eCCLs2BAy3zh0Ip37ZYjhsC8HdUIXK0wDQfRA0PZ3AXmrSMaqA/njurBRgX+C2zvVIzRXYYwccZYMwpxaSq4d4AAloSEkn0UjEOZoCddNrjWVS
 Y1YTjuSi
 4pXAQgyIOTAM1ouUm8aU4fT4+3c6ZUdC5y4ui5r7JYXNvIaXCZHez1ARmihzkfoz1w0QD8RNxNottNpUo1Y7vq19tuNcVc/bjckYHHIYxj3zoETYNmXX01DRpCodF1bVw7Rud4xRGNI91hqle7VEKQdntvRdeaEnduonUbRc66Oa+GpSZ+bvVRVWgdrclk3l6P/538ygKAiSQqVJ19METEI5baHd8zdmZeXxpDBtoWoV/QBE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON sysfs essential file operations test (sysfs.sh) was extended to
test DAMON probes sysfs directory, by commit 14885da09b0f
("selftests/damon/sysfs.sh: test probes dir").  Unlike other DAMON sysfs
files, it is testing only a single directory case.  Extend it for
multiple directories.

Signed-off-by: SJ Park <sj@kernel.org>
---
 tools/testing/selftests/damon/sysfs.sh | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/testing/selftests/damon/sysfs.sh b/tools/testing/selftests/damon/sysfs.sh
index 2eaaa5ae3c5ed..d528dfea44c3b 100755
--- a/tools/testing/selftests/damon/sysfs.sh
+++ b/tools/testing/selftests/damon/sysfs.sh
@@ -346,8 +346,13 @@ test_probes()
 	ensure_write_succ "$probes_dir/nr_probes" "1" "valid input"
 	test_probe "$probes_dir/0"
 
+	ensure_write_succ "$probes_dir/nr_probes" "2" "valid input"
+	test_probe "$probes_dir/0"
+	test_probe "$probes_dir/1"
+
 	ensure_write_succ "$probes_dir/nr_probes" "0" "valid input"
 	ensure_dir "$probes_dir/0" "not_exist"
+	ensure_dir "$probes_dir/1" "not_exist"
 }
 
 test_monitoring_attrs()
-- 
2.47.3

