Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60207C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 01:33:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AAEB6B0088; Tue,  7 Jul 2026 21:33:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 382516B008A; Tue,  7 Jul 2026 21:33:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BF406B008C; Tue,  7 Jul 2026 21:33:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 03A7A6B0088
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 21:33:00 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 72DC116903D
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 01:33:00 +0000 (UTC)
X-FDA: 84963885720.01.551E484
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id D873810000B
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 01:32:58 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HEvBl7SB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783474378;
	b=cafLh9SV6CcHhbsmfllLraod8DWZ2UlVUVZqXhSrALjyJNMCqOJ31ctpb/OjZQQ6b2sg8d
	mcWqrCknvL3eXnHaeguvYIx0z8BFnif/f7SexziEJ9GAez6K+2SRxsJAl98zo2A0IaPmah
	WQQTOkD3FVUQjVP0towl3t3rQDgMuus=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HEvBl7SB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783474378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=I8QrNb/C+cvH7yIXprKVZCOZdxfCmRYXj28pAZUqsXg=;
	b=6Mbq4jQx1uW1Lg/U/YXb1Y/SXaGcCkUbqAckQL/PcaC3Par7rgSVvRhjuWJpL2Lk2Sxtqt
	qtTczJNPD3B68hCeGJdAKBObM25wgYoKlWQ4qP048dKbgt689kxnyRNW3zojVkCkBjsJvW
	vAE2MutsWO1Uu3Os2reTNNcs43HRp0c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BEE264012C;
	Wed,  8 Jul 2026 01:32:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F1EB1F000E9;
	Wed,  8 Jul 2026 01:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783474377;
	bh=I8QrNb/C+cvH7yIXprKVZCOZdxfCmRYXj28pAZUqsXg=;
	h=From:To:Cc:Subject:Date;
	b=HEvBl7SBTjtN3xOHmo6QnCYsDOCSq0tUXKDtcYO+ampOiSjh2eZ9dmSbIVM8E8fcq
	 SLxs2t9uY1KTqpW/c8QT+D6YCmicgfJ/DAH4Wua1W/dRM6Kyrl9WR82hm4mNvkXin5
	 lKR+uz5tKc0535K4zVpZ53pC2VlRT+G7+IpSx7D5Jg3DPhhIUV0U0EzLvJt0VHUIb/
	 YdTa3jJ5pqvmcV+j7suaHWzwRCtoEXy/4wWTLGCWMIjfWHTa2j6pt0ZyG415KrhVr6
	 Eo7jZJyCRo//W+msBiuyD90ibtMFQMMv0OQz5EWeNsPZ3TYxl2cYaEW2mTECiRtbwB
	 Pzv9VOTn80cfw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 0/7] mm/damon: update probe hits for runtime parameter commits
Date: Tue,  7 Jul 2026 18:32:43 -0700
Message-ID: <20260708013252.95888-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D873810000B
X-Rspam-User: 
X-Stat-Signature: 3ig3uhturw1b8mm9gz9t98nf9dthcmiy
X-Rspamd-Server: rspam03
X-HE-Tag: 1783474378-643479
X-HE-Meta: U2FsdGVkX19Aeso6I3+/J3+S3o/lyQfAlkpERnM3JoKxIJq+YHSE+6buvwPX6txVPmNG9vaHJeQIOgrMTtzX5V5SQmZrrhbKC+yWsLL6KTaebNQINV8N5X7Of4qDCSXVMUe2WrvXQGlH7zxwXBzN5c68ie1vAYenRqMaGE5QLP6iohlSSpBpgxzFqEYrBEZbTkFFGIO5ujJi/Wr18HirzZLIOkGPw5v3axQfryWYigmcWGr8RFVGuSeZ1DcpNb0+7irC6iafHET4W9VbLwSkvRiiaFS+WIj7InGSp1Q8+wCYDSvkezA4/0dloNfGRLjZIWEP2oMgr6hAYiWpYKRH/m/NCwh5xRvCUHk+E0mLDqBts5dvgduhN8YY8ec20CpBcIXB26KEKxWnTBG8nR19hqRIzyj5dP/uXkNxKScZKC2Eo3ZLuGtHRYcNZmkKFSzLc05bb7jPfsHuBUE3xivuq7+7e05aDMHLmD4pNSsdkkEU5g2ZiPAJh4nVdyyjyiAlP4uPsrYN5k1t5p6UGJBcfcUDv/gkP5td1sOD7Bb5tWfrwpSpLmfy2iEyWCNF6RA6d/Fn31GJIyjbfVCwOgZzTFSIy67TSS5Lu63K8fHNpUVN3+0fMB6DvrBVPcBq8YyxaXTfmwjWbn6DtHzS5BouQrRbeql2K3d58jcJc7iw3V8pDdC+G7Lit8/Bwf1jMT653unjL+wkzdVpLuFSKcCOBrdD3WgGRri2WTyYJ3CpLQgjG7sdZaDQeLjWWxIwF/pEQzT1XIT/2cAOg0+VLUYPO5EYa0VKADIkWIrd25b1KwhcgKtHQMqF2M+d2ByPq7n1Jhd9kpvJe2OkK+9VljH/d4/VYgf5kSZODvedlWSNhAxLmUAsIh7F/36pSt3b3VznEdwG27LVVpN80R+3T1pxiceey/DsYE9ZkHsLFQrYv9Au0DXdN8wJnGp1pmn+xnwKLkKLBdl2EVdTgbPbHTb
 NZVmPzOs
 rmUKi5NFbWjJzJrqVT0PlImT4BsST9ARDco5ZaA7Z+dJXFswD+tCcvjzZsRmQnwBBaxVw1DCvCmcbSA2keqcrPCBimFdAhRXNkSw61Ylwzxaxq6VXpD0tktae/6Na1ppIsYwBtmiwNSP1/Y3jORrfUYdtOADtDy63JKeKlVaLOjNeA0Gbg5/tzldTp1kwYDnl1eucasDsmygv1ngmoXnL3fBOXpicJzGUWrEQUMHkkvwXLL8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON users can update DAMON parameters such as sampling and aggregation
intervals at runtime.  For such changes, monitoring results that depend
on the intervals should be properly updated for better accuracy.  For
example, the access frequency counter (nr_accesses) is updated.  The
data attribute monitoring counter (probe_hits) is not being updated,
though.  Do the updates for new parameters.

Patches Sequence
================

Patch 1 removes obsolete comments and test code for a function that this
series will touch.  Patches 2-5 rename functions that are being used for
nr_accesses update, to be able to be used for probe_hits without
confusion.  Patch 6 does the probe_hits update.  Patch 7 update
damon_probe_hits_mvsum() to cover a corner case from the update for
better accuracy.

Changelog
=========

Changes from RFC v1.1
- RFC v1.1: https://lore.kernel.org/20260707135038.90068-1-sj@kernel.org
- Remove obsolete divide-by-zero test with comments as a separate patch.
- Remove obsolete comment removal part in a rename commit message.
- Rename name-changed function parameters.
Changes from RFC
- RFC: https://lore.kernel.org/20260707043828.97900-1-sj@kernel.org
- Remove obsolete comment and code on the test.

SJ Park (7):
  mm/damon/core: remove comment and test for nr_to_bp() divide-by-zero
  mm/damon/core: s/damon_max_nr_accesses()/damon_nr_samples_per_aggr()/
  mm/damon/core: s/accesses_bp_to_nr_accesses/sample_bp_to_count/
  mm/damon/core: s/nr_accesses_to_accesses_bp/sample_count_to_bp/
  mm/damon/core: s/nr_accesses_for_new_attrs/nr_samples_for_new_attrs/
  mm/damon/core: update probe hits for new parameter commit
  mm/damon/core: handle unreset probe_hits in probe_hits_mvsum()

 include/linux/damon.h       | 10 +++---
 mm/damon/core.c             | 65 +++++++++++++++++++++++--------------
 mm/damon/lru_sort.c         |  2 +-
 mm/damon/ops-common.c       |  2 +-
 mm/damon/tests/core-kunit.h | 38 +++++++++++-----------
 5 files changed, 68 insertions(+), 49 deletions(-)


base-commit: 29da8f7d1b66215addd212b9b7191a203e322b8c
-- 
2.47.3

