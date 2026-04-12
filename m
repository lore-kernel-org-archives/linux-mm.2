Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C98D9E937EC
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 16:20:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E7246B009E; Sun, 12 Apr 2026 12:20:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6705F6B009F; Sun, 12 Apr 2026 12:20:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E9B26B00A0; Sun, 12 Apr 2026 12:20:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3A9106B009E
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 12:20:09 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F0A81BCE0F
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 16:20:08 +0000 (UTC)
X-FDA: 84650415696.28.185F6B4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5DCBA4000D
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 16:20:07 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Jf+a2hVD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776010807; a=rsa-sha256;
	cv=none;
	b=Jonmrndf774Hu5FB3t1wZ7vk11VAp8b3WrUcPKisBPePtqE8eiUr3MPvwxxCgCHYqyFI20
	Pgtf6hFLWnBPQ1HVXMWhfZJ7s7CnHYRH+HO6JnT0Eil6SyH4JgWKHtpJeUUE9OZBmeDcwF
	KTrkOKV//kkO/y68vg6/fHG46c9uwdE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Jf+a2hVD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776010807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4joi/1jxL0tMeoK2jtxaL6glpzvmpSwsvYu1Z1ZZFRc=;
	b=WJ8PGKRau0+aoy5ASgSb7CRmnKVZFk+78dOVkN8IWnm7SP2SSEchnoZFJcagF6DkgVDta9
	OyGUY07Qwp28V4Oiam74dhk2giWZgu3LSm68bzvIxFKIKyii/v281xTwIqZIV59x1Jr1dl
	uFqt86LNoGhDcGHwcuEDMdx5tskxsW8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 519A24471A
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 16:20:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBF2AC32781;
	Sun, 12 Apr 2026 16:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776010806;
	bh=EuOHul4fripHvwsgWhBfbomSmWCRXpHL6QQJMWdANgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jf+a2hVDjrVEvCGNr6lCjPwS4jHq/0cEijEDJBeVzwrnsicQAQFsWzgYDNBLgmpLw
	 JZFy5ZIuVp3VPwczOeJxiB/R3KbaUqyz+8ST9N3sz2bgpaa75i9EM2A7aQrKlHIQr6
	 AYLlLkOXB0FJ5pXp2BodwDO6mh2YJjoiadkxZKO05Nty/s/gj8qB1GNI1ebsvrvp6V
	 4OX1R08hIznpWvvRb4PGnOGI0wpVZ2+gLBdXRjtgj9jAvSuT9zavW+7wc4ZXZhoYHz
	 4kTWcY5S5MDSm5ELXfLy6CqdfI66M5G8fvLDFY/Sqox9YHPvsGhjYi86YlAD1KJdPg
	 eEfdVGUwn4Khw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v5.2 10/11] selftests/damon/drgn_dump_damon_status: support failed region quota charge ratio
Date: Sun, 12 Apr 2026 09:19:53 -0700
Message-ID: <20260412161957.82835-11-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260412161957.82835-1-sj@kernel.org>
References: <20260412161957.82835-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5DCBA4000D
X-Stat-Signature: 7px78gbt9b5tsutq3k9emem11j83npyt
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1776010807-647868
X-HE-Meta: U2FsdGVkX1/jPIYIiyPrDrktyW0su9c295vxlQkQ6KfvINQQnVNsgiof+d8reBNQgmXbCwl4xZgYls9tCzCujFw+nYF4wsjkPzrPzqkkd59IWP27IhUIlsjG5Q2FtxcLgaYio2FBTKOXuMBUVh+j2TsRSnR5pAmKciF/11QPapjK5y6Rxl/qR1wByr2kYDSWWJzIqOG79OUxjM1Fr/YhvOV16mDPbZh/5Y+nxuiy2pFHP8RN8582ByfqPC89AqreZ6mBxkymw6j6m6E3jNMaOrIGoFxrJUjXtfvRn/Umj6DdeLoZd5klMMF65Le0hEpEN2F92E9dkhEf2MYAXIZ0CeJsMtnQvFRQPUl3+BRstCxozbGUmU3PDOMJcmo2WYtEZsSk2zL1xSW45anqugGXUpvKthffcLIPakm4m4wCwJCUX3lUTfkrO1QU7w31pWNeK6LwlLMoI5PN/3m0NfjwSeeCmWlcedLXGHQRahuzwalW8ZQq5jZI8/wdIEHMUGKftrNxr+VMzEIqfK+ArZCIITMjGk3+9r42s57Q06CH0Mz6ceEFPx/WpZg2VvEQYncvM3E04sBxmkwAG43fqrqRX5ppIYIyk48hZ8WxZBbvl7XLasPggpu4MkrMFckUqqZTMhtTpnI0REqF5wQzpVQdrTvM0s1V7ljwAqMw6YEJBSoowE6o53RJWvwKGsMME0JNSMGEhaZwLyIhA2pV/2M5uowBUfnpG2owWqDRuRLy143vDDXKGct/QyETES0hJaScCyEVnJUuNsVl09ekjdQyR3AAdX/femBJLyxXRx1m3KOzExDm7NxH4IgbJ3jzOMmSUj7XuruTwosBLUxHA80PAy8Kb+KaAUr2M1BG8l1S7cqfPTixqtTILPkbvIZd2IYwuIfvsoVmrgB0+y34t2xc0WzQ0nu0z/W+A0mDleEpv5JTkhWdQS7djieVEedgsUKB7toxdHds1JcAXfJJ5yr
 S6wNYk/R
 PgtY+lVPyi84QVW+RPzKbos9BsXY7A+QDPZIIkWHSAzPyFk82I2c3mxtjsxfw1R/ZlZ7rfcdCVM+DXmkuA40X6fPRZBx633am5qn72Zlmib+HRKOwD/ysU6DbaOrnZwqmJGtLR0qFfkEFacpSbosyT9O5MjTzPOvuqZeE/VGNZp9m4Y/kthHwg7zd1ykt+WVDJ6DHTmnEreXPyHKQpfeFlNkgInwR7B7c65n5GnUfVPuP3dd0WMMZuUE63L5N+ftoLC8C6k43ek3v2wp3FFxdzM++vgfi5nyZj+nkfHa9tT47I4M8V0g47MDk2ENwLBCLzxwIYBs13dfP4Ca/JjQ9yHuYLuEPaSRBJ4IG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend drgn_dump_damon_status.py to dump DAMON internal state for DAMOS
action failed regions quota charge ratio, to be able to show if the
internal state for the feature is working, with future DAMON selftests.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/damon/drgn_dump_damon_status.py | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/damon/drgn_dump_damon_status.py b/tools/testing/selftests/damon/drgn_dump_damon_status.py
index 5b90eb8e7ef88..972948e6215f1 100755
--- a/tools/testing/selftests/damon/drgn_dump_damon_status.py
+++ b/tools/testing/selftests/damon/drgn_dump_damon_status.py
@@ -112,6 +112,8 @@ def damos_quota_to_dict(quota):
         ['goals', damos_quota_goals_to_list],
         ['goal_tuner', int],
         ['esz', int],
+        ['fail_charge_num', int],
+        ['fail_charge_denom', int],
         ['weight_sz', int],
         ['weight_nr_accesses', int],
         ['weight_age', int],
-- 
2.47.3

