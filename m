Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40DAECCFA03
	for <linux-mm@archiver.kernel.org>; Sat,  1 Nov 2025 18:21:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FAF48E000D; Sat,  1 Nov 2025 14:20:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 389CF8E000B; Sat,  1 Nov 2025 14:20:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B4888E000E; Sat,  1 Nov 2025 14:20:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CFCC78E000D
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 14:20:42 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9B410160544
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 18:20:42 +0000 (UTC)
X-FDA: 84062853924.24.B69BC2D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id ECAB74000D
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 18:20:40 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LODRtFEU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762021241; a=rsa-sha256;
	cv=none;
	b=aJ1E4zAU6WUUIPoBzdQnPt90XPJ8Zg9EnpIAPowdFhiXYd8dS3bgLEhMPK6xgOp/jYkzUk
	0KNTYzJRYj2IkfFyQB2b10RnmESMBSwm3WRSEQe5YV9dviPbPWPgjn5AtKqryXDV+vqHvj
	nORdoHYNGkDW7vsCLBBSgVEAPBunyh0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LODRtFEU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762021241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=welPT6fmsndJSwGCzrwho5A4w+1pxTKFkzF+QWpwMe8=;
	b=LPvMdezWkvfIsmGeUIjwFpJmqUb8Gudv36IQuLFOOf7cJdOsICg4mVU+hWQkHLh+LMBtpv
	RNg0oXEP/3FtLwxB7udL5FZBKlztctTzAR/HamNwOfWEXXtWxJkTRBt7xBbl72dIX7bKQI
	gKIe8u9m7HGZPtJ4Fc5oryMjkgPmqRw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0CC0543E9D;
	Sat,  1 Nov 2025 18:20:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFEC2C4CEF1;
	Sat,  1 Nov 2025 18:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762021239;
	bh=dtnr1Fqk2FrpK5TYhb0W5JzpIRDJYhJ9Lxh+9EtnNZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LODRtFEU84yycbBjTVcs78D6I+NelipVPJ4hhUP33InVXZ6/uAU0nQ/Q0e5tCEB9c
	 k52lYLaQ5R/WxIefPw1cyESyibMiqPAm+gCsrnPejUKnsVcvA3PyNC8dQC7a7P8BNs
	 I0capoajcgS+ARJN2vZE0ycBCidUElL7NcVZnjOwEKsxi4KIyTl7pNBoTLk17WMVTT
	 CtSFlKdgOHKfAoJmNsb/m+ijl0/KmyxTvn/YVgQaPDPdxt2HPH+m9UXxpVng28frPX
	 UdhLUrzoTHjz0azZU87aVvssUSjOlT7/6GRDN4aL7ztWCCo0EXHS/4eQDVpMVnIaYE
	 DPdy5Wx86MtUQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 5 . x" <stable@vger.kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 12/22] mm/damon/tests/core-kunit: handle alloc failure on damon_test_set_attrs()
Date: Sat,  1 Nov 2025 11:20:06 -0700
Message-ID: <20251101182021.74868-13-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251101182021.74868-1-sj@kernel.org>
References: <20251101182021.74868-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: ECAB74000D
X-Stat-Signature: n9ydorudyz3h7r6zikin5d6skyensw71
X-HE-Tag: 1762021240-298773
X-HE-Meta: U2FsdGVkX18qwEGYdPZoVOCNJ97cO5N+CN0B5SOTTEKh1FLpMeHuAalbinjcJtmEBxv/pL1nm+8JXPpNEJf+Cr5+cVSKeJigO8brPrwuvW+Zu4QSQRvY6gjlVdxBbUT4XabPg7fQ1iFxE+9LdPsgKqsrb4JOJi7JfLvMGMh10WvflEGKlihhpZf3mX1I/8SD5tkZKMVAIO2Pz9N9qI4jQrFsmkCRSPVf5ApsolUaeadtjMOCENmk27JPl9m+KYBPFYTxzW1sCWSEWvUZiI48ZZfycGJRVKyihsTiaiChdnQpBCMWSIcvYm0Pbk/pQ+Au21pQqRW9RvcZd+DE8pBHUHPfwL2sJhn7yUaOEHREHdgvIdd9kB0SW5hD5lrS2lA2wAroFmc9VO6tYHses5t2Mvj9Q41Lajwdq8L3DnhqKp786/hFegW6ZMcLh+SGGBAGEcfhNrhuWC3ban+lpYNMAsarsEKJoRP7tEoK8ZyCDICsTQVeAVspNlMF5AlkvpHAHFCCPsOFvDYGVSQ02KCAmJ5Q2lTMsFF1V26p99tpyhg3rLRBZQzd7Umq3fqMWXl5e9sarNjD8yiZLdQdK6UbKZHEXtIr6T/dE1aX+Dw/MVrbpH7Rv8hnOY/TiYqp8VGGU1SDsE3B9ANt+obcHgHpKooZfXytVWZt5KJs+hcmyAGRelq6FwhOSVHN8nJXrp0pleYisx0I3fmoxOQoikvh3OESxP3txs0pI380auTkg7nQdXKXzD08xR78wrJk3qxkrnEPAWK2/GLCutZDpG8oWErU3RN46paZNEhEdGqMLz+w5k0uj25LchRYgI6+FDDK8DF5hTY7rjRiBY0ur0AZ5LSZyZ96w9ykdOVp1A2epvW2P1kMsuumaOkv0UwreO7UuoUr9xfBSCWFAd1rXZKGN5GIYpxMt1nhN2iL1sTN6TNoWFA9NfzDZlD9lFGgLJhWb7tFnGKZdylSjIzH5ZO
 ma50pRDn
 9+fZFRZJyYGc94ckBSp3QfnFZ5AT64VRab5w3DWtPqoJwicn6xylVvyh7n8eorYuJKWBwuhD0oShtF1rJnfStQMn4XVeACtKEwK/DxiD6qzL64CE8oCV8v8YhBAs93heO+ZPdMgtT13mO+ELMZox82o63Tw+brbaIYfNLEG99+WoqUYuJGlXfct/zi0H21OV6Z0dC4NtTTvlY69fY/9XonQ9vIlOCCCTlgRmU0vnl920W9YOMm4UKmKtL6BWNCKXZiXXOvV+JTbZYqRDBS4AOkaw8rA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_test_set_attrs() is assuming all dynamic memory allocation in it
will succeed.  Those are indeed likely in the real use cases since those
allocations are too small to fail, but theoretically those could fail.
In the case, inappropriate memory access can happen.  Fix it by
appropriately cleanup pre-allocated memory and skip the execution of the
remaining tests in the failure cases.

Fixes: aa13779be6b7 ("mm/damon/core-test: add a test for damon_set_attrs()")
Cc: <stable@vger.kernel.org> # 6.5.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 10c9953581ee..b9bd69a57e62 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -465,6 +465,9 @@ static void damon_test_set_attrs(struct kunit *test)
 		.sample_interval = 5000, .aggr_interval = 100000,};
 	struct damon_attrs invalid_attrs;
 
+	if (!c)
+		kunit_skip(test, "ctx alloc fail");
+
 	KUNIT_EXPECT_EQ(test, damon_set_attrs(c, &valid_attrs), 0);
 
 	invalid_attrs = valid_attrs;
-- 
2.47.3

