Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBFD3C982E6
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 15:15:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D22506B00CD; Mon, 21 Sep 2026 11:15:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD28A6B00CF; Mon, 21 Sep 2026 11:15:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0FF36B00D1; Mon, 21 Sep 2026 11:15:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9D3756B00CD
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 11:15:56 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A7E091A021E
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 15:15:54 +0000 (UTC)
X-FDA: 85238119428.16.078FDD3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2191C8000F
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 15:15:52 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iJ5oC3YT;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790003753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=v2TT2RzKq0ySasMECuIA77pplW9JQNZIwLSdAY2y1e4=;
	b=6zUMFfy/5AbgFUktE5kS7UjQhDgmTRgoZ2NYTG/BA73a4BVby1qdztKkRnloGklApbg8RD
	abdfjDkWQK8hrzFhPjwXd1WGBsldZBqnYvOAHLrOvjYwmndB44l37hi+n5Tm0miRXnTQV+
	D1ooTiFUG5FOUkUrgWrC/irSqBmVdnA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790003753;
	b=j48viV1QnB+5opDdxkOU0ZeV4W6ZZxuFASxN/rdvTiVHzrvbLCs5EJa0M5XbUe4xomF86I
	htlnsgsMeI2WMwwHGKVUxhI8ENGP/+uxE4JoT7m116C/jVWbUFB/loR0UINJGAmJSJu55E
	dPPWRGpN+nyTgiS39t9MVuJOIwuLwj0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iJ5oC3YT;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 426A540AE6;
	Mon, 21 Sep 2026 15:15:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EE501F000FF;
	Mon, 21 Sep 2026 15:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790003752;
	bh=v2TT2RzKq0ySasMECuIA77pplW9JQNZIwLSdAY2y1e4=;
	h=From:To:Cc:Subject:Date;
	b=iJ5oC3YT2dCKI0AwnslGMi+n4gVJufBi1ZPcJxeK/Q5reOxklap/Edzae+xY9CkJx
	 EekHs+4Iops46s7MuiHT2GCd5FyhyXyn/cp6FM7IEc30WVSSZ5VtRtc1RcqLfCfPRn
	 Eh5hfwPTKbE4vtdqNUIBvl0k/0tEQQzxYzgcuG4HyCR92j0iNCuuxwNbFodY8YFXPm
	 p72zzcItP45FCvQcZ1sNhW1c62aMfJImyZJaVne2f/EzFWcx2ygGtyP7L/YBSLLf6b
	 nXiOX7VG5tG20E/3neCVwZX6jAHV3i69/ByzOwQnXWThoS7oaJpJa2xvu3EbxHWFas
	 5MfDPTp0M0ISQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	Adrian Huang <adrianhuang0701@gmail.com>,
	Karthikeyan KS <karthiproffesional@gmail.com>,
	Liew Rui Yan <aethernet65535@gmail.com>,
	Xuewen Wang <wangxuewen@kylinos.cn>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 0/4] mm/damon: improvements in efficiency, error handling, documents
Date: Mon, 21 Sep 2026 08:15:42 -0700
Message-ID: <20260921151547.78472-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: nnhxium1t6bp8ibnag5k88huspp5fpne
X-Rspamd-Queue-Id: 2191C8000F
X-HE-Tag: 1790003752-987670
X-HE-Meta: U2FsdGVkX19CqEfQDQyXvNO6NaZiaZ0Y0oJl1qZZ73Hip2Jvbclq2HDj1mfpae7H10ToDVsgkh2O78ilTFBk/IA74OuKKw/2wncTghAcazFFXNl3aMalKW70FlwdIJxOWSyMnJKJEllGzhc9NTGDV+3UHboNRnTWDHnUJzWHTu8HIKjE9IjYaNew356FUkUmD/jbM8hINFVtTddARhGMvsJ3UGgFtpxYyMKYxBGH4JcjuADQ4dPYKDWBIRZitvQy1RlbFyyRgwJT+x2CxYDoaz4zsnMq76ubDId1Q7CDh3KFdiP7itle1NEl84cCxBw0jP50Lbja9/YRvwjdWqNydWUGauuV/6uKI3pCKrzjDNFtkgIfDy9PROI8mKjk33x+1O0DnoIePa4HCum0dnUzcV0OmL4I4ugcdToWvB2wrnPTkya+DsfbjV2Ax2OynwccroLD6f3g2r0m7VCJy20pBj+I67rmIjuNcvwP7btNKWDLh35V/oYyK4MjyItQ+ZbfYTc9mU9upk5nRDmiJWRZ4b3TZ3tEgRfefvO70FUw0mjUQ73xmHBqZzNVDGPkrFYneUF2SxuyWZK7k4SyTWbQSIenH1fetCzs4Bywpx7E9RBhaLH9LdQz0nC2VGECWstqc8dCXdCBRsmzWnsiTHaDEfBLj2R/9MlvS8TXzptPqSbSQ1shGd00aHyI2J7Vv0JHjD5rs4YT77MWtHWN5VbA2F9U/KU1cQI5w6rjY7Rh911igqell96Fm0BdpIEWZv4TdefkVWbmTjWTuOJkKEEs20i2pUP8ZOUbCaTQz2kfF9fnshVv/6B1VueX5ft5wU8IovoVvPiV+ZxLB6Zat7ztmlji2GuwGe1jAgrbbk5Z/jgO0vbFyWkJ8SiE0z0fRLR3spvrmXGmCj5OZJi+6/sSSIMTB/PnHuA87zBTkaRnMSwJNobcC0gBl/2PKYgUvWAuesr7sNW2GdTw87tcDy2
 MhUGOAuO
 PZXRJPleG8el0Rp2pqBmn7vNoHmNr5gnLI5lJ3lB50hnR4NvymZ+kY5iEY4NiMheZ0VjzkafcrnlLRQDdc3o7xbTocoNIUJ1+Phay8ePD0I3FCBwEv/LCCnwdZ0XQvcBJCgzeSRvrzU4cRSzAbLo8rVa5/XfrB78O4Po295UuFcW610UXOnZVCQy5L34UGFucqIOO4suGylJ+aX4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Four various improvements.  Patch 1 from Liew Rui Yan skips unnecessary
quota setup work when relevant.  Patch 2 from Xuewen Wang propagates
ignored damon_call() error to sysfs users.  Patch 3 from Adrian Huang
(Lenovo) fixes typos in comments.  Patch 4 from Karthikeyan KS clarifies
zero sample interval acceptance on kernel-doc comment.

---
Note: this is a batched reposting of DAMON patches that were
individually posted and reviewed by the DAMON maintainer.

Adrian Huang (Lenovo) (1):
  mm/damon: fix typos in comments

Karthikeyan KS (1):
  mm/damon: document that a zero sample_interval is accepted

Liew Rui Yan (1):
  mm/damon/core: skip quota score setup when the quota is full

Xuewen Wang (1):
  mm/damon/sysfs: propagate damon_call() error in turn_damon_on

 include/linux/damon.h | 3 ++-
 mm/damon/core.c       | 8 +++++---
 mm/damon/lru_sort.c   | 2 +-
 mm/damon/sysfs.c      | 3 ++-
 4 files changed, 10 insertions(+), 6 deletions(-)


base-commit: 05b2dd9725f76b0024d387ed2226d1ab531620ce
-- 
2.47.3

