Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 301E5606A326
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 19:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E4XJY5Et
Received: by kanga.kvack.org (Postfix)
	id 19A406B05B7; Sun,  8 Nov 2026 14:51:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14CED6B05B8; Sun,  8 Nov 2026 14:51:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDDAE6B05B8; Sun,  8 Nov 2026 14:51:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CB7F86B05B6
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 14:51:57 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D14EAA04BF
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 19:51:55 +0000 (UTC)
X-FDA: 85412997390.19.4534F1F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 49A2A120008
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 19:51:54 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E4XJY5Et;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794167514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=OJAr4xLTV8QiOwhk6gGpqr46jyVyTKNFU7LHvyqTRTs=;
	b=XlqVvtVVGW1lDuuJE7rtfComdjL+pmlO+5XIplt+iLcXgfRQjh0XtRzFnll1fZOArfYPn+
	bhLZC44HVpXdic3sJlOydhjWxWRxEUpj6abawusTs+RfaCqzCJmMKDVSJY+f+3sGhTgJew
	5ZBeGNTxpc2SbzynvZSWw32KcoN2tTU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E4XJY5Et;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794167514;
	b=Z3ZwhQM8XMxFxadyjr/uAWlGVQcXwYpOO8BNZTS3aatpq9VoDsaSF2svqyDPYeifh/zBNL
	EMzhDLQO/MGAHXAj1k4m/2xX1IjXR5V/bYsTFiJy8LnALo1z12EjxW4LOcB2632CmKxZFT
	kcoUf/fvAw5tScSPEdKPMIh4jn0Xc5c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7C779423C3;
	Sun,  8 Nov 2026 19:51:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDFD11F0089F;
	Sun,  8 Nov 2026 19:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794167513;
	bh=OJAr4xLTV8QiOwhk6gGpqr46jyVyTKNFU7LHvyqTRTs=;
	h=From:To:Cc:Subject:Date;
	b=E4XJY5Etd4ycRs2IGY1YQ9/0VbDTr7XLpuGSttyjyxlozycuUxa+fQ4LjIRepbV3q
	 AdBNR74SA8BowS5r+jit8dUOUzLsoTFMvZ1U7L0dKsq519Sp5Z72DJJFeD3hs3b2EX
	 BkIpVLyldzMZWaGmQrnOqV79F6Ek4RG/cFOXQo7deN1XP8xk57TEyHUs0ZoQOEh7Gb
	 NGR8x8L4TUrzt5tJKccxcptbseIzXbziAHx32uht1yrqf6LpzH8QwMRyGXWOziv2BO
	 ukUpeJHzbYOFZWhgZIMnSWiTOOJFjjKyJQjNPiH4Zb57ZGnnaiYFoJQWOolZhRIDFO
	 xwscjWhn774VQ==
From: SJ Park <sj@kernel.org>
To: stable@vger.kernel.org
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	Quanmin Yan <yanquanmin1@huawei.com>,
	Usama Arif <usamaarif642@gmail.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 6.12.y 0/5] mm/damon: porting fixes that cherry-pick failed on 2026-11-07
Date: Sun,  8 Nov 2026 11:51:39 -0800
Message-ID: <20261108195145.115792-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 49A2A120008
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: ci5i6yaypwuzkute1sxgwo6kczca4jc1
X-HE-Tag: 1794167514-26176
X-HE-Meta: U2FsdGVkX1/f6KsRQ7OOw5Xu9/KE7KjI1P+z4uZ4Mq18EpDo+jbtMdCzv8yGYtCUuIBue96BqkqLQi5HXYNEMVffnn3q9bDEKPbouurAjDuPDJZeCDZUfjKolgp9VdB3AIlHJCCiN48SPANVXsXLJBrE9aMW1a+Qi1vyCrT+g168YUAIDzNlFQ2LFpYvqCxixlzgcydEBGMDtv2s4Y9g4u9j8or3A8h3l/dy1lXWITuNMeGS4Qx6vJoxlDAgTYqoI0aCfrvN0d21N8XSZj3pYQhcGmatuo4e3w+/JQqY+wy+ew+Qrvd0kP5NjGTkEAIdRIqt6YD4GtqOD/YQ0GgihY4ONmCTXGWSAk5AtY7uEptENMK0c/wHbobGKnYPR6QyY4AZxXg/pbEHDA/emeIZJI0LaAnjV0bketbizmywrX2mTFX7g662GbIpmfHskdKh23pqsM52NF8OLR7/zlqSpzZZlIgm0cI0C8RkuKvRiC5twMVpphyzSjyxaJY76wUcD18M2N+PyVXjZM/uiIJ1QYC+Yzmsfy1zPp7kFUY+lLipqH0Lq5uQpJKdurbm4VBy9UlAJLobwE4qHp41QZSgdnMZXPejG2Crdef0TyHSLWWJ6op9q2LS26ktloBjLuYrDst6mz3QZ9LruUDPZrYRiEi/CCjVDcpx95ss1eTktZT6m/QWSP3EFWaQ70aJdI0IgmP0OyQ7gZ38evcMqiES2ER2UbkpQx/j8QOK1GUSD3VC6uUr0LbztB5xTKMAABdTTzght0iPNtXDnXGOvCG+VA1Io0oSf39SkzHTl87DwRDUyhrDV418v+QaxoXeRfreEE27BPmUrCCqFSmUWbBuFc8VjrSPuLVEXcwxce7deYt5kMEGwe3DhXCr31yFM1oW0MU8Zl6N2Hiac9PWAqCjYaPvSwxqJEIwe56WbvOrUtGq0FdSCP2OZwZcbvcOtptDLI0dUkdhGGNHzIAZGo3
 +i7xMXEt
 qlG5geGSfJ7nPgdVa+gIV17ALsWV5GFfAZt9XPoO1OQ7vPVIVj6i/3tzPc0eIxMVjF3Y/g2XW/ELXi9vvCzmit63oDwjsgFHaPzTKunSTI4C3o17iyrAofEiAZj6fs8UX3QCYR9LRvK921ca6UlDLEzQFnhm7ILLO5fpcGRhxUtlu8R1IdWa7P7xNQ8YClG9XdKnf5Kat+gv3zsAGjUIrAx1omdEJs80UvvD8DPkwZkuHfL4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Manually port five DAMON fixes that cherry-pick failed [1-5] and turned
out to really need to be picked.  Note that seven patches [6-12] that
also failed in the same day were having wrong Cc:stable@ tags, so
ignored.

Patches that this series is porting.

[1] https://lore.kernel.org/20261107051942-failed-6.12-90c2fa6adfed@kernel.org
[2] https://lore.kernel.org/20261107051944-failed-6.12-1613ac9edf38@kernel.org
[3] https://lore.kernel.org/20261107051946-failed-6.12-29c6084658af@kernel.org
[4] https://lore.kernel.org/20261107052624-failed-6.12-bbeec2d8324d@kernel.org
[5] https://lore.kernel.org/20261107052626-failed-6.12-5695abc4e742@kernel.org

Patches that also cherry-pick failed but deliverately ignored.

[6] https://lore.kernel.org/20261107051949-failed-6.12-df7d9a0f8d91@kernel.org
[7] https://lore.kernel.org/20261107052123-failed-6.12-6f276422aded@kernel.org
[8] https://lore.kernel.org/20261107052125-failed-6.12-a1c7fdaf1657@kernel.org
[9] https://lore.kernel.org/20261107052128-failed-6.12-1bfb9384ae0e@kernel.org
[10] https://lore.kernel.org/20261107052130-failed-6.12-cec08aad3def@kernel.org
[11] https://lore.kernel.org/20261107052132-failed-6.12-409d2ab6d982@kernel.org
[12] https://lore.kernel.org/20261107052135-failed-6.12-1d2397b2c414@kernel.org

Changes from RFC
- RFC: https://lore.kernel.org/20261107214525.304638-1-sj@kernel.org
- None.

SJ Park (5):
  mm/damon/core: skip applying scheme if region split for quota fails
  mm/damon/paddr: respect folio end for DAMOS actions except STAT
  mm/damon/core: handle uninitialized damos_quota_goal->last_psi_total
  mm/damon/core: filter out damos address filter-split failed region
  mm/damon/core: remove unreachable damos charge_{target,addr}_from

 mm/damon/core.c             | 59 ++++++++++++++++++++++++++++++-------
 mm/damon/paddr.c            |  6 ++--
 mm/damon/tests/core-kunit.h | 11 +++----
 3 files changed, 58 insertions(+), 18 deletions(-)


base-commit: 749e25da48308e7fd273cf1a64a27020e4fd1118
-- 
2.47.3

