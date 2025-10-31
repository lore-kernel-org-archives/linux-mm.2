Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 517A1CCF9EB
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 06:54:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B5368E00C2; Fri, 31 Oct 2025 02:54:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93EC88E00A4; Fri, 31 Oct 2025 02:54:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 743448E00BA; Fri, 31 Oct 2025 02:54:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4F8228E0045
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 02:54:14 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E60B6589D8
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 06:54:13 +0000 (UTC)
X-FDA: 84057495186.06.E0FDC8D
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf19.hostedemail.com (Postfix) with ESMTP id CDACD1A000A
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 06:54:10 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761893652; a=rsa-sha256;
	cv=none;
	b=SkLqyboahyp1VNPlKTsYMvsJInKn3yrJf72fNxIkRt/zoLyC85xVGjMb0QHBe5DxAsMawG
	O1FWbqWtxN6aTqx7aXGYxs9F2FKSFJeK7u+gJHx9/wSngJpveKq+Z//OB3jDYgYLH/WxNP
	eAMYgkGrdQ163Xx8fKnOpuJehlaaFzI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761893652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=LhaAAcr8zje6NL7JjxmWSI1q8D949PnfOC3SLcWfp8A=;
	b=qs42lnI/dYQ8Elfa9uc66AS+c3AdLSija5b84wmZLgBHwVb+79/dRRDJ8XoBVt5I/QMj+W
	3UA/XqwaCMYJb9IYeZeK3jJdcl6Dqr7X3//GHj+vqEMNsd2R2SgL+e2iqNo/urW9ZZ4hCA
	c/HIgwc0KpxJ1hcV4HHlA1sjD/gKuhI=
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 31 Oct 2025 15:54:07 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
From: Youngjun Park <youngjun.park@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Chris Li <chrisl@kernel.org>,
	youngjun.park@lge.com
Subject: [PATCH v2 0/5] mm: swap: small fixes and comment cleanups
Date: Fri, 31 Oct 2025 15:50:06 +0900
Message-Id: <20251031065011.40863-1-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: okw5j8rmudxbttdk7md1d154ird4eq7m
X-Rspamd-Queue-Id: CDACD1A000A
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761893650-529290
X-HE-Meta: U2FsdGVkX194eW6Hzcjq2u3PeKPO5xCUhQ2csDUtQ11obBNKKdUb2grL0M4EoKILvlqYuQSk62rtjifQk0w3DhraqntzhI2CIYw5HFUf5YJDee3V3ghb0Gga2Co30ibImK1cQTO7TqqnYhuLQ8RzDd3ozoyFmkIqch7F6lLbBpH4tolOz+2jt3iHsrWmRIbgH5lQTK9n50kizjzJ2e63zDCprsM23dbmtwdqsjzUCwMWeSjZIDn1e5j3ropcGx/NjH/rVHXj+Imb8WemX3NdAVGqacTb88zV9Qhks/PVAfUBw5GzbLAZFFT97pUmM+nJQianwornpAuB8qSvPGei7J672wgGMakY2IFZdwkHJiFvpoijQCHOG6rSU3XYxHi8w8s1Y5nlf8Nt7GCg2StOoT+yePgGOieQgPgzuOcR6QM1+DvDgCW1pUqtRJHJ14zoN3PiZJnm0mh24KgMIVWN1ntymQAwZIyF82r4+VQb6EpqoP2aCqmi6hae3Kt24nWbn49oDoXuYaIAaPe78VslLYklr1AZ5u/yzAPTHoRP8JYGKel8hDQtrJ8W82+r4w0BprG20smIpMMS54FVbcRBSMGp6tjnqlUa+ZXHzhuB8aExZTM6j8vIUYkAWlvy3j+TuxMrEn2itcxQ/javTFVKM8zvLQYNHTBZoU8S0A5rKHiyxMMdgZX8RShQbJ+7Ib+90aofYz6jqOLLr6r/Hr6TUY2xasZdvcqkzTJwdyIR23hRvzJ7CX3v5cDkg8bsPdpRlbV6FRuK3VRPJNDE+6WKZBxhBfzc+Z8zCfNTQ0/qDPDLScd1LFlLNEq2rPMb5L9qv56ShJo8TvSkx2zE/lbeZw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,
This series provides a few small fixes and cleanups for the swap code.

The first patch fixes a memory leak in an error path that was recently
introduced. The subsequent patches include minor logic adjustments and
the removal of redundant comments.

This version addresses feedback from Kairui Song. Thank you for the
review.

---
v1->v2:
 - Reworked the error path in setup_clusters() to use a single exit
   label as suggested by Kairui.
 - Added a Fixes: tag to the first patch to identify the commit that
   introduced.
 - Added Kairui's Reviewed-by tag.

Link to v1:
https://lore.kernel.org/linux-mm/20251029085659.2005942-1-youngjun.park@lge.com/
---

Youngjun Park (5):
  mm, swap: Fix memory leak in setup_clusters() error path
  mm, swap: Use SWP_SOLIDSTATE to determine if swap is rotational
  mm, swap: Remove redundant comment for read_swap_cache_async
  mm: swap: change swap_alloc_slow() to void
  mm: swap: remove scan_swap_map_slots() references from comments

 mm/swap_state.c |  4 ----
 mm/swapfile.c   | 34 +++++++++++++++-------------------
 2 files changed, 15 insertions(+), 23 deletions(-)

base-commit: df412f2f12d492234da858e4dbaeabed9ecff3c4 (mm-new)
-- 
2.34.1


