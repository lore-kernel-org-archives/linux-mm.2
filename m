Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 571FCCDE008
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 08:59:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26B256B00B9; Fri, 26 Jun 2026 04:59:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 243B46B00BA; Fri, 26 Jun 2026 04:59:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15B2C6B00BB; Fri, 26 Jun 2026 04:59:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DC9DF6B00B9
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 04:59:48 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 791441203CF
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 08:59:48 +0000 (UTC)
X-FDA: 84921466056.14.2521D0D
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7D67A16000A
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 08:59:46 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nNwYgbHD;
	spf=pass (imf08.hostedemail.com: domain of jiayuan.chen@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782464386;
	b=iUotTsHV/nfu7SkUMvHBFly0vkUaRa8UmSMnx6IcABVrIa3+m5d55DhVpW6XQWj0wvdImx
	oX6Wx68Ts8VZbYrux+tgtRUQBrpMMZNM0Y4RUGJaMQujU/wz6NlWeBjuLmRxhgOBYw2fad
	YAtmFHKkOPH9I0Jas3k62/JAzlklzNQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782464386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=4Btdrgv+2MYn8HqFl/2dPPY1UPaNThih8AbcIgKdCzc=;
	b=MBOTnrjTdqkZDNVDrKO9Z3F5qfD4JetwvCCFpjSusx+DrE6NRTBoXrAasLXaPurtVLS8XD
	tHGM2HHpZN5F+FFvFGJjnLcaRlHpBY8n5mTB0P4VBWYctFtC3LE0c/MSxE4eUaOcnblZZY
	gFZD8YYtSnMVO9d/mqeioBY+yhQUtJk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nNwYgbHD;
	spf=pass (imf08.hostedemail.com: domain of jiayuan.chen@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782464384;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=4Btdrgv+2MYn8HqFl/2dPPY1UPaNThih8AbcIgKdCzc=;
	b=nNwYgbHD3alMle7JcMKnIFN2udtNhz3R7njzknZnJQKa1+YVM+/1w17vrd+tN1sp9D0uDK
	VcEQ6wltXoyGV8LZy44qi5p3LlghwCipWLXbV19SO3chnyLrt/OFGER+JT6GsLlX6I4wWP
	o1rlqV+ejZIDIEkfXIGxPexpm5B7H5E=
From: Jiayuan Chen <jiayuan.chen@linux.dev>
To: damon@lists.linux.dev
Cc: jiayuan.chen@shopee.com,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shu Anzai <shu17az@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] mm/damon/core: detect internal variation above max_nr_regions/2
Date: Fri, 26 Jun 2026 16:58:36 +0800
Message-ID: <20260626085851.70754-1-jiayuan.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: xth8yrq444hqs8pfgwa4ygoz79azum6r
X-Rspam-User: 
X-Rspamd-Queue-Id: 7D67A16000A
X-Rspamd-Server: rspam02
X-HE-Tag: 1782464386-260913
X-HE-Meta: U2FsdGVkX19rfpjxYel3EXD/rU8MDv2TW8NiKDyf3JHs+ndo3IC/xVaOGwJbk2hM+qurojemCdzvv/P5dYi5MDunxtRXlTv3o87z3Tp5HaZQvEvmqxx7XTh1CYXztsEqhKgH+Cck/UMMscujl02RsytfN3ZvuZTFRfcm+o7REU7hW3JRNKtexW5sPpwbTm9umSPkkprTtyu839+SrPfHMKNhlLon5wsStHzedbQ3A0AltEG1Ugvh9h4Ki54jSjRi9qesajHERvUAg1SFmfUILfrT/4j+5O1emHTAw5Bu2jB9kzFHlqPKaeajP9H2bOOc/SnnnriAz61Nd17Zg0K7maugZMDIXXfMK9y+kp0a0kL4hSDZYVULDHviHg4GhTjA6r59Qcmzcq9Vv5efm1ndnb9z1ZRwEVto0v1c63vObvh+Fkxv4E31IpiLge8G3J5t6cBy+WTJ0/0JnnRaUMHEk3PY9QlStlsTkwp2Je/a+vCnyjwLrJ9RJjzajDJOpdNkQJ0/yWHvYd8QClj0OaM7cN/CDIDwsRs2udiYEa7gUvx+ZuDDZqFXYG02kAiYzAejduOZA0Qwke5EASYSzQSItgplNAWnxM9ZX4d9bI5jMSrr+2SDKaMk92X2Fogo5YCFFrGW+sDlcWK3XIvfcAbhkjkIsZsg5q4Bfzc4LlbEy4cKfCStZh3FNOID4f8jn7DztanBjYWrCyfLyR27GIyBfaMM0vVzdH9i8r3+/xUa0Y5Aii3OqAGtAg/ahaqIJOlOSAXF/exbc2jkWpzugDMGSAPgfMhISbrSUBSdhSDyWZs8vB2wQj35xMBAA8800H7MnARNe4BIXw1l4+JUavC8EX8oKKpSSJMubgkbXjMhC+QzypYrLTNctkHyzOZpFO3J847F77GQdeB+5yrNvDy8RqsTj2x3++g3BeisZXEVhq0PISZ/e27fwsL+YQ+LKjDeuYt2wMHcw1hdcQp+NxK
 +dS6gjO5
 IaQYjGNVhCsHBCiepNhNlwLYP7RQDdt1FaiVTEsyrAQ/PrTOa3FCmH7EBag97eFe8pbjj3mKkXqjmy7JxVqkyHYnA03Re23lXY/s2QfP7/j/xt2LSU/26ViRioIcpM3eq+TtrL4jtNIOOZw4BQkBJ2WsFvQhRhUGWvC9cDy6pMpM5WW9cJajewMy5LEDSsua2KeO9Px0QHIqITayKbIIWIDm5EhoU6qVLG9xnLHcEumQ6GOv2R2hHgadry1tbvreY+e44IdhR+oQBTiE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sorry for the late.

kdamond_split_regions() bails out early when nr_regions is already
above max_nr_regions / 2.  A large region that picks up new internal
variation after that point never gets split, so we lose visibility
into its hot/cold structure.

We hit this with damon-paddr on hugepage workloads and damon-vaddr
on processes that mmap a large anonymous range.

Example with max_nr_regions == 1500.  A target ends up with 799
small hot/cold regions plus one big region (an earlier merge
collapsed a uniformly-accessed range into a single piece):

H:hot
C:cold

      r1     r2     r3                 r800
    HHHHHH|CCCCCC|HHHHHH|...|HHHHHH..........................|

    nr_regions = 800  >  max_nr_regions / 2 = 750

Now a cold subarea shows up inside r800:

      r1     r2     r3                 r800
    HHHHHH|CCCCCC|HHHHHH|...|HHHHHH........CCCCCC.............|

The small regions can't merge with each other (their access counts
differ), so budget never frees up.  r800 can't be split because
nr_regions > max_nr_regions / 2 returns early.  The cold subarea
stays invisible.

Patch 1 keeps refining on this path: when nr_regions is above
max_nr_regions / 2 but still under the maximum, it splits a fraction
of the regions instead of returning.  The fraction shrinks as the
remaining budget shrinks, so the count approaches max_nr_regions
smoothly.  A useless split is undone by the next merge cycle.

Patch 2 adds a KUnit test for the case where nr_regions is already
above max_nr_regions / 2.

Thanks to SeongJae for the suggestion to drive the split fraction
from the remaining budget rather than an age-based filter.


v1 -> v2: Some feedback from SJ.
v1: https://lore.kernel.org/damon/20260521045236.115749-1-jiayuan.chen@linux.dev/

Jiayuan Chen (2):
  mm/damon/core: split a fraction of regions when nr_regions exceeds
    max/2
  mm/damon/tests/core-kunit: test split above max_nr_regions/2

 mm/damon/core.c             | 49 +++++++++++++++++++++++++---
 mm/damon/tests/core-kunit.h | 64 +++++++++++++++++++++++++++++++++++++
 2 files changed, 108 insertions(+), 5 deletions(-)

-- 
2.43.0


