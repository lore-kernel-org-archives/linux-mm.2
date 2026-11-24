Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5813D606A326
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 15:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Q6oNJZB6
Received: by kanga.kvack.org (Postfix)
	id 610E16B0747; Tue, 24 Nov 2026 10:30:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59B7D6B0749; Tue, 24 Nov 2026 10:30:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 489026B074A; Tue, 24 Nov 2026 10:30:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 212506B0747
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 10:30:33 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 853F0120BD9
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:30:32 +0000 (UTC)
X-FDA: 85470399504.05.F8E7A4B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id D3B6D12000E
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:30:30 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q6oNJZB6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795534231;
	b=HYdrd/pWwOtXGEEaYF8+cdHlsbI6108F27DTs9yxfs5X5vzgVTswP2RyJkUZjKp36e0CdQ
	bGMA+wo2C2MEzcqu8fHMWq00czxJCiOSAmUNKjtEhEXtzaiBvy1lNIiuWvE8QCvqM0z0cB
	z3lsdIw4oc3lMUZ+H/J8YHO9Q6ZMh6s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795534231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=DIDV2NuLNU9URutPUbTqr/fH+wYU5tnhotuywFh00ro=;
	b=wi1DDR3NHJlH2yWiG1Y+l7u7NJDsukZFfoGF89ndXn4LGYBbHrwiG1LmC3+bm8H3iHhu2/
	f6AmcZcvnJdU02qSmeW5Iaj7f/LF/02aHaEr6RJXa/19BFlr3RZFdp23m2i7Z9N9xL+LNo
	TTPSOADSJoHMVprJGpfGNi4Sy6FbqXE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q6oNJZB6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 07E88424CB;
	Tue, 24 Nov 2026 15:30:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 381151F000E0;
	Tue, 24 Nov 2026 15:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795534229;
	bh=DIDV2NuLNU9URutPUbTqr/fH+wYU5tnhotuywFh00ro=;
	h=From:To:Cc:Subject:Date;
	b=Q6oNJZB6U7VElNu+N3//UjOfVMkguuC8Hslg7dqk0nXMHbSCUsY37asAo2n5/gMBc
	 xMW5QXfvxGtAB2gpJh/ahyFb+HNU0YIZRV/mOpHPCN4Zf+SUwBYSW3d50VuzYzWXqT
	 EkImSxO9p7KC/nLMgcbC+1FdZbBg93JkLGRLaU0mhtCYWhrYBxMjD9Ey/iu0kE0Ose
	 jc6ssCjLlI7OqdWA735y544BhZb8sxFQKZPG00zJZYsAJG3LROulLT+0ev3gV+t5do
	 KBIJgD3OeoXn/m3YeoqulnjVv8Unj55QRA7D9/27yT9YH91V1z+jGS7jxNEhHeCkLq
	 g7IQZEB5CxO2Q==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 0/4] mm/damon: improve efficiency (paddr, core), fix a selftest, add a kunit
Date: Tue, 24 Nov 2026 07:30:16 -0800
Message-ID: <20261124153021.90142-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: g5p66pe8qtzf1pc4upixmgmzatuwdmbf
X-Rspamd-Queue-Id: D3B6D12000E
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795534230-270550
X-HE-Meta: U2FsdGVkX18NHdf2HmjL62UKS8i1DE6atkFeblIebQOJMCExLVWW0RLwaAQv49PZiHxmrzcjrGnxaDlTlT/1aiJYKuhl+z9Ld0YwHYwh47wB5L+d5FzcWFmC5Gu/cOtbA458n3jpPmvuP1enYYilPz1z+Kim7uEgnnvdHpKQUwxhbY9uV0Zt1I3NPVj+vthzgN7MMTXS3leRWr+twxli1UYbV90mrDus0bNZ5V6S3ufgs9mvEEh6Bitx27uDS3z10udG40SQx+mgiFywWjdXamtH9imodbOyDkS4SqpSRwLgUAhd4+4Bbimlqka0JU5c3cws1kffW05833T/FJ8pD++X6pp/DOhpFHNSefk03CDzrOrFxCshh79D1bifCAgzvhys46uKZ0iT5ZbVNnMix0lcgDQZPVGEtBE2tXfVF1JujKwaX/LhDHYF52vGPVtEc7pb4eGafmfQlPA6gOYf+2NDFeNBCT5sL0P4vAxpQkq15PkPgDSbirXKF4LfGisXtWVadDfrsM6A/ReSEGV8pZrZUl5myifUT+KdAlX7mW/quJnBc2W1kosxGhbYYUwgvcjYzrWnf3rDh2CMC7SbAn0qxk5NyTStoKE/NymaH0LrGdR12RFxQl7jktfLAuNHxGZJ1qi0v8TPfLUNJmQR6ot7wNARBHnqyHMnYXWe2pz0HFoWw1/7fyQODhKi4fNif8Nrk3eGOhAeMyGP2p/T3nZFXhP2g+FSF3Oa8FzP+8XQVHajE0wiqRCJXJyDlMJ9G2edpGrKPLsXeXI1/4hGQkVHwI5BDQAUb4B2iesR53oZvhdE3wPJ/S/UZ0aM1f3ZiX2Grw68t2DkANqngkUhAC1Gj+xfNny0xIDpOfllPV77dwfmi2XTRESJN44Ws7g1l6GQq6totfWXGAG1cCzyaXdDgqZEK34/+Jhq6jz8WsQbxj/+PdjxIpExSqRxd15VvN3a2W89fIi7DEYPGgy
 YWZyupyv
 TeLPYIMAgHnVd5ZtKnuPDZ+xginuS6fM1UJCb2dhlB7TdTTWmUqM/8ciVF8lqiDHlKsDi/GvDyIFp+MMEr9Ud9NrhgDNU0T/LUmOY0+AI3ljTr71Msd4sKD/LR/i7YtWPxSnZX96poz0IdjmKIpe4EJlw4pZh4RTD/1B1gz6DHShwMoSJtQoBEJHcqh+7lGioJySazC+uS3VZZtSC8W0gdTBYvurnlyyf3nmYJeMV+VVQiVxyLXdGzUm13vDGW5wiPSsg+fwh0RRbAmDWgcVsLYFQ+Z25vw4A1xdnBNGSnr8BgOdITNQdgjlvFydM/oHZCrs/deRpJaHVft1L8B9xjiqq+PQ0asgYhJut0R6EzgSDx+/zWKJNjBEbyAEesh22rRb+GLn8nJNe0qE7k/FZ3bNypxGrjjucAEuAm/Aj0e4MFw+hbLHijXTqTA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Improve efficiency of DAMOS_PAGEOUT in paddr and apply_probes() in core
by skipping unnecessary operations, via patches 1 and 2 from Aveline
Noir.  Fix a selftest for a false positive failure, via patch 3 from
Aveline Noir.  Add a kunit test for damon_call(), via patch 4 from
Sailesh Nandanavanam.

This is a batched reposting of separately posted and reviewed patches
for being merged into the mm.git.  Refer to changelog on each patch for
changes that were made before this reposting.

Aveline Noir (3):
  mm/damon/paddr: skip non-LRU folios as a whole in pageout
  mm/damon/core: skip apply_probes() when no probes are installed
  selftests/damon/damos_quota: skip the last sample when counting
    exceeds

Sailesh Nandanavanam (1):
  mm/damon/tests/core-kunit: add test for damon_call()

 mm/damon/core.c                              |  2 +-
 mm/damon/paddr.c                             |  4 +++-
 mm/damon/tests/core-kunit.h                  | 22 ++++++++++++++++++++
 tools/testing/selftests/damon/damos_quota.py |  7 ++++---
 4 files changed, 30 insertions(+), 5 deletions(-)


base-commit: c2b9a116bd15d6afa6c3d032e97136fc67f06970
-- 
2.47.3

