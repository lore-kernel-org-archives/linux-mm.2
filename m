Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8124CCCA471
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 20:15:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F6D48E0005; Fri,  3 Oct 2025 16:15:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CEAF8E0003; Fri,  3 Oct 2025 16:15:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60B128E0005; Fri,  3 Oct 2025 16:15:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4D33A8E0003
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 16:15:14 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F0A5511B09F
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 20:15:13 +0000 (UTC)
X-FDA: 83957907306.27.5F395EA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6E53A100011
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 20:15:12 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VqNiRg7n;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759522512;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=SO1w9aBKzoIWmKHBURr+xBsEY9rmlI2MyvRBzuu2vdc=;
	b=8OhrfTVmDYOoUA7L5WBwl0niaeG9Sv2EU/1J5LqgemrzyTlfiOPvbeq49cDsoi7WcG8g8z
	ld2dCFb/oneyM4VEom+/x5JfYWRD8Y+0+KBAclx48MhAe7pkI3il1LX5y38KOx5SGAkaFD
	W5RUcROH0S2FeIOSJ0AqA1Yq1w/g7RQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VqNiRg7n;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759522512; a=rsa-sha256;
	cv=none;
	b=CyBKJn1rdIKwt3iKRdFWlzs0MXsR3DK+wWlW3Cr00CElAfvk8f4hAdwB6dmDFBIsbaEC3z
	Oai+C7q3w0eDAwQ2hxRZY7TMZCYD56NhNj6aXk/EyggtMjRpnu5RNw5IW19ka8Vohr94Tl
	kSdi6+ovtixGCbIIkfBXzG33jZiwKvk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 279D94332C;
	Fri,  3 Oct 2025 20:15:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D740AC4CEF5;
	Fri,  3 Oct 2025 20:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759522511;
	bh=qtfz/YfEllIXjoRI/HBAplZP1lyB8MYFrVrD1QnzyoE=;
	h=From:To:Cc:Subject:Date:From;
	b=VqNiRg7nMuR+dDDL6d31WcMOXqHyGxsxV+xYD53aX9znF5dxsB3RypkLd+rWv1ovr
	 RRJCZ6Zfr3pEhrWCK+GKaXKLoMDgbM/p5qwRtlUZ77dfaS31ARj5iXv5m3gBvyYbs2
	 FWRSPSxWZpAkqB1PpcDNyP4GX9kuJSm3hDAamesOxnrpfJEY5JVpiNTaBFn6mE4wx4
	 5hKmMn+wEaLtaKQ4Vs35mZtrLTd/hcMVXKjz9badoLpFXiktjsppsy9bP0ibgP5IyE
	 CMwK8XANfTZlEbGFX+w/U//NY6eI9FMXPumY4UptgsfkYNKIrNV0UuZ1K+Hi9avsB1
	 +72RZ+7AgHEdQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 15 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 0/2] mm/damon/sysfs: fix commit test damon_ctx [de]allocation
Date: Fri,  3 Oct 2025 13:14:53 -0700
Message-Id: <20251003201455.41448-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7cm9wnfgdjogyr5gfxj1ngtm9df8zznk
X-Rspam-User: 
X-Rspamd-Queue-Id: 6E53A100011
X-Rspamd-Server: rspam04
X-HE-Tag: 1759522512-525368
X-HE-Meta: U2FsdGVkX19USLJKrDJfkpM/zydzVr+HZwNyHm2S6s7MWyq2hgdRwUcOIyw/Q2tsZJfHEg2VEjP+GZfkFTQsWZ0zkYtTHanp/J03298MxYkurYj8bcNr3CopM2+WL9OG40dW4H5sIFiryByhRf8mPz84O8UdE7RdiWU0C2rMwYDs82A4CChLRGBKJSt+7DpzQ4+dMbXTy8lhQN2RI0sigdxwWaBNzhXb7oj3QK6jCTpAnYwRZNwkzFssKvF3j1Ftp4XIHJsZ/8cBzeGKxYqeXW2MEzJxGkkwHCVD4jpRMZ+Mg4W+Z2yPa28Y3ymcnFsDau0RnAJ+0yPR5hq6/fRW2r6RGS3lf1vIK4YnI1RGbbpA3H1ncX5U75UV74raFFWl3mbRdAWFrGzr2FVerjWuZWVaqwj1a/oKMgzGeRwfzkJnKQxSY/E9O9MkqeyEnvQAotxZWyVPdxovmC731V8IjRrjy+yq3oAS+s5hLGx+SgKWxW+0tMYTUfv5TTi+WaXv8na6/E7tJ5y3iWIGrmw/Q62UdcECUloeV9jgBv2Y6gJR8Qaqjv5sNn8k9BrsTrNg9u926vZP8gTlnFu0kk1n+soxdcOFrYvP5Tfd1VHjDAwDht7MFtUpjzsEoWti9JmPd1in4Z1l/C1MK/0nFpiJUCVbP7hOCA5qp7JoiUySJj3r5r5+++BjXkiZci1EcfCbkZqYDH8YItPzBAioeX/gGzHA8ttFm6eJomhAMEvGtHKKl9DybZk5kIwxBgDVi1BKMyPnLorcmj2C71yNS0V45ntRAkcNLte3kCtXaTpENSFvKnlR/LV2tR+YLPr4fB+EPRqbLmYGJv3iWqYY/KPCGYZ9iU5PepWKgind2g7gGtpjBc1FzcP/zlfrCXv8uCh0/FpMKTuCCEZOd3qAcvXS02l1F46h+k9UCm8oTieCuJdD+7jRZluofvxqxgkfcFUVW9FZVKB9UN3SzuZ1pFW
 AaZ/1tYn
 M5tH4Hab3W5sm5x58WDm+KDzBWgKye7xzTTxcT79Gszgo72QuGwC2CtvzxCTsHHYzr1UHZDml42kg7ivkC8rsPm/AJQvETTQ4ce5Oripf6hgTwizSJXHMNIY/9Cgfe/ib1GLYFvhML/HSd8kX0A44PQ2mzQ2hldMBgwE7Pn7NEQKxwKjcKmMklMb1jd+C6W8AQwkN7iYOkW8x10kkR3UTvrWHHVdGBFCIhLrhn3GxSb8H5+a8eDmtfdK+KusA4Tibs0uv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON sysfs interface dynamically allocates and uses a damon_ctx object
for testing if given inputs for online DAMON parameters update is valid.
The object is being used without an allocation failure check, and leaked
when the test succeeds.  Fix the two bugs.

SeongJae Park (2):
  mm/damon/sysfs: catch commit test ctx alloc failure
  mm/damon/sysfs: dealloc commit test ctx always

 mm/damon/sysfs.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)


base-commit: 3c39180d389ca58cf309b7aa58b6a3617151c226
-- 
2.39.5

