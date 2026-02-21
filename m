Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5DF3C61DFB
	for <linux-mm@archiver.kernel.org>; Sat, 21 Feb 2026 18:03:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A33EB6B0088; Sat, 21 Feb 2026 13:03:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E1E56B0089; Sat, 21 Feb 2026 13:03:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90EB36B008A; Sat, 21 Feb 2026 13:03:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 80E096B0088
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 13:03:54 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 44E1F59382
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 18:03:54 +0000 (UTC)
X-FDA: 84469237188.20.F50EB61
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id B381B14000C
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 18:03:52 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pGsr1+A2;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771697032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=7grIXo2OyOKNOgpM3A2Vx6X5HExPWQSbTjDfJ3JK9vk=;
	b=JzAONKG3mnNZUegCvfy9yjJQgPzsx2t2FqSQCmUh4Ue3LGmrKzTWvaDbL5lHIcNyk5kqY3
	sLVe6EmHUwsTiXNQB909F8RZ3bE9MkeFp4lqqEr2V7qO127J0UD0h4WkrCkGEK8JFTTse8
	/c1imYMV3pzMH7kveyEC4b8IuHJP4Cg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pGsr1+A2;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771697032; a=rsa-sha256;
	cv=none;
	b=fz6Vk5wXKKzE1enFTFRRJdfbUSp9ySNS89Jesik35nJaup/scaO2rUMN5oAqQ3/I9wR9XL
	JWfIayojm26yxBQPXSAzjp14Dmz9mx4AdI0iWYvKXfaPhely04tC5AIhIzfrQquXIOANPN
	SuFnahtbYhN1yoregKq2zFnXnJXZFps=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 858FC4035A;
	Sat, 21 Feb 2026 18:03:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 354D1C4CEF7;
	Sat, 21 Feb 2026 18:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771697031;
	bh=3nAKOmdR4WaTdsGiJ79MmmJcYTDbSE8Pmqh31ykwIqc=;
	h=From:To:Cc:Subject:Date:From;
	b=pGsr1+A2KVrG7oeQlbTQObGcxOALqByMYG1qdanVHwYfRVlbz+XNQXlji+DKwlZoU
	 WGFY2Qwt5S8TullKEXw7c+rt3mtxGK3NYIAtHsn2KuPMpZ/XMGx6sO4rtlsMN2vZky
	 SWMYGVtR1PpDNTWqFrlZrO55Nufr6kSqsAhMb3hYgRPY1qjc/e95xBefIObA5uwsYS
	 oMEOWddRCiBK6p13e0BoaCs3meee6K1aYR6DOtrldcUNSYbavhwNqoEWAND5xQQ31c
	 pioZBj0xr7snUdxdePm9nPI/9Akjnbyo5qX144XGQdukGQXrerqrTJkg4mPqhcyquD
	 0H9SrFg2rs1sw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Akinobu Mita <akinobu.mita@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 0/3] mm/damon: strictly respect min_nr_regions
Date: Sat, 21 Feb 2026 10:03:37 -0800
Message-ID: <20260221180341.10313-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B381B14000C
X-Rspamd-Server: rspam02
X-Stat-Signature: 5b4o4bjx1f4xprrx9epxoj1fx68bzcbb
X-HE-Tag: 1771697032-128461
X-HE-Meta: U2FsdGVkX18mv6ubSm6CDNOmHt+BiR7+xZntUA3qblUfxJiKgDCfqRb7+9yGC0N9yJFpxcu1M5eZpME6zc2ERLfkxNYlpllfV7cMZLoa3oxs5GgI4D7FAxBEYznry5gbeU4p7WZ8BmXp8jRIuZRgNXyIudeiOBWNXOr3Fw0VTAZuZT/fWR5JrZzhQ3OOEbef27NY6Chsq3agPEaHCvWNI4EJKXVC8is3fmaaSDU6gcssgLcxGOknPWTEq2g/Qg0dML2+75cN3nTV8pw+Pqagty+zmRCbC+nVjRsHLgAE3BpjWw+eWHvu5f+hGV9OnCuckYBbON0rbbI2BP5CU1o1G+gy9+ERdqr7b3E7g2P6USlCEDSHTTXO2L4D3kzy6Lav3Xgd56GUmwJrbCYw5LJRZ7xFkdpGSAWvwDGh3rWfI4RBgnKDJN1kAmrRCAnKXgEOfBcAacStsu8AoP8Sxf3E5jvtO1Opgby3vrBAOLn4ci9dAe3cfEXfG5VSpZHtxeupdR1Ups7utmDQ0rHQImfMi53JQDG8JwpuDT9ojxvuHOgLSRz1rFCpnL8hiPwzm3vACpYpGSIKjRGfZ5gAJAOmgcTMvnhEk73JfhfVhi5VUdKYssVWzCGTUqTw6UbfOQvunEq4ZyBW/sceQTi54u4KAuo1opTJiJ4+FzEsZInrqn2WRaxZ/5wbIvNkJzWNj1ycxbj7UdQgHegbQTtUEDseAUUReLAb127bc9W9qgOxtVLFPmU++elY6kU8yMOhvkbIlya5y+PkVJHTFTT3H3YNLDFebYObtzLeljczqR6ms6zTpRmMVQtLjSoeALzV6gQewz4dacLXt2dVWkTiC63MLYyJ9Z4ad24wmedtwXezOHO2aV4A9fdXc/mvwpvxhz1qoCga4y2quNlr/wnF7TXxo44gn5z8Vd5sNQoM++D1cCr3IcXxy/5ftqgosrxuJczKtRhu9KaS9aJ8JvrGPrp
 gQO+ALTM
 G/3a4imHcOayfh3mVirVJvu+HnN75QJFV/srfyhYKvhe8iswBC9obJHiAD8zfy6aOVU4UrnMm+M176uzn2oyioVw2Fr+bbjZ78nw01+UT9TL3D+2p9Lfb6ARZ7ti/6xDGqIQBg8m3D8FFjRWeFd9KYTYd1jcT5mAbHnBE2tvXZdpZ247O0hdumzYiSBRTAI/cONLxijhk0msjnFW7AfXEwVDkjaByF1WoBLBuucqSsuYBeprziG+8GP6myn+8OMIri/KdaW1POBxwyRRokXV4PAg4T0Ds/SY3R0AbwdxzpJqC4FiPrQ4q3YIAtat4RBYlIVQUHSd/YGz+ptgQhQ3pGbcCBVvXarUWG0IEP72wIYzUCENRsirGXHO5iw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON core respects min_nr_regions only at merge operation.  DAMON API
callers are therefore responsible to respect or ignore that.  Only vaddr
ops is respecting that, but only for initial start time.  DAMON sysfs
interface allows users to setup the initial regions that DAMON core also
respects.  But, again, it works for only the initial time.  Users
setting the regions for min_nr_regions can be difficult and inefficient,
when the min_nr_regions value is high.  There was actually a report [1]
from a user.  The use case was page granular access monitoring with a
large aggregation interval.

Make the following three changes for resolving the issue.  First (patch
1), make DAMON core split regions at the beginning and every aggregation
interval, to respect the min_nr_regions.  Second (patch 2), drop the
vaddr's split operations and related code that are no more needed.
Third (patch 3), add a kunit test for the newly introduced function.

Changes from RFC v1
(https://lore.kernel.org/20260217000400.69056-1-sj@kernel.org)
- Split regions every aggregation interval

[1] https://lore.kernel.org/CAC5umyjmJE9SBqjbetZZecpY54bHpn2AvCGNv3aF6J=1cfoPXQ@mail.gmail.com

SeongJae Park (3):
  mm/damon/core: split regions for min_nr_regions
  mm/damon/vaddr: do not split regions for min_nr_regions
  mm/damon/test/core-kunit: add damon_apply_min_nr_regions() test

 mm/damon/core.c              | 45 ++++++++++++++++++---
 mm/damon/tests/core-kunit.h  | 52 ++++++++++++++++++++++++
 mm/damon/tests/vaddr-kunit.h | 76 ------------------------------------
 mm/damon/vaddr.c             | 70 +--------------------------------
 4 files changed, 93 insertions(+), 150 deletions(-)


base-commit: de85cadcf3a95954743146e39ffacc58d2355184
-- 
2.47.3

