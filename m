Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C44EC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 14:56:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D4106B0121; Mon, 29 Jun 2026 10:56:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15D7B6B0123; Mon, 29 Jun 2026 10:56:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04C296B0124; Mon, 29 Jun 2026 10:56:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CD2BD6B0121
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:56:41 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5908586D84
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:56:41 +0000 (UTC)
X-FDA: 84933251802.25.4E3BDFE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id C4D5940007
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:56:39 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="eU/k2Zti";
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782744999;
	b=f7XameGfmS9OsNXX2uGLUDH/fHZumo9GS1l1vl7HX/Tu0phtqrDiIHQoASxjbSyi/GPnNL
	0BzF73OxlDBZgyltTJvIgSfRs5UBBRqK6hHTC0KtkRrKOJM2+8tKcgJ5oo89jrNIiir5hu
	XOWEX57uM972hGLJg6BtccXKvPwyToU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782744999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=UzWU4Me4IIb1YZ7xC+da7RUfQPj8e+Q+gI/W5LlD530=;
	b=aK5fwrL/a3WY/3FmW8PMiqoQLel/HkW3139XOwd9x9kHLoqz8HUOXme1PnV0N4EgDTI4wZ
	XO7LvBlyRruCR/1LCa7FdDe5JPXrOCZzfid6Wn1pZeNoypAinIen6LJisKJxsZo03xuMaJ
	TxcAy05VcD7DZH9iZexy9jvmOc0xI/0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="eU/k2Zti";
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DCEC841744;
	Mon, 29 Jun 2026 14:56:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 666941F00A3F;
	Mon, 29 Jun 2026 14:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782744998;
	bh=UzWU4Me4IIb1YZ7xC+da7RUfQPj8e+Q+gI/W5LlD530=;
	h=From:To:Cc:Subject:Date;
	b=eU/k2ZtiggJzLKB6N/h3ekSHuXEFvvxTuHsNUCvt3BMkKk34KwIqJyXFjA2cxdjFM
	 08yP2tYQM7ByK4lzFUmUQzVEUpSoqHh+Mttcr5hxyk1899yibNC7OHdq9oHJ/7aXcS
	 065uWXUqfgwULYoaXHSPuMF08GEV83YlaR9uF3SvrHb2zKv8U27CiYiTpFtY7vsLum
	 8yo6sJAj92rzTYuTjWlCjDSzQS/BDsjhKLe0GXz5yFqOsoMYLhYLizQZXFzw0+0a3i
	 dNRaHs+ZyR+D7PwOzmqIhD8TFly4EL49TkqW0vQSJOx3/0l4IOea16f9fyDJC6nNzb
	 EAkspDiPbx5Rw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Shu Anzai <shu17az@gmail.com>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3 0/2] mm/damon/core: detect internal variation above max_nr_regions/2
Date: Mon, 29 Jun 2026 07:56:27 -0700
Message-ID: <20260629145630.134891-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C4D5940007
X-Stat-Signature: utyqm8b6s6r13snyicy1ys46f9aiwmn9
X-HE-Tag: 1782744999-337680
X-HE-Meta: U2FsdGVkX19XGfZ7JHgrFIiwuh0cnC+8K14PELXzfXcM3rXzwNLsloy2x4KW1Zybo35NMOV4usrSBhgeGoLHWW5asBSGR1GDc7lHE5QPLPe+3ewb0oVqY+XFxy1EsGbj1irbLI8VjmgWoJk81BzAbFyfAc2DsFkCebiVUaHQRqT40a3L2ire6yEmF7QhvTtd1R+bFlH3pDJN45TeMJDLrw/IZGRP7CWv+t6Um5rHRIQcCvEPZOtUH4HKOfqiNHuaX9TNd/bO8oXNQs0aXsl0ykuN6KfFBLOMmM+h0H1kXAfYfIMtWGn99k8/b8OuO7RhZ9PJHvlQL/VBlIMGHNjsxep4THce6bF+5gZLt1pUZB2JqYbPhCeZe5QzPAYO9oVPN7EvjQVrpLS2aZ2O6JY3EsusV6s+GwTfv2S47wHnE2O7v+CoGyR0/t/fiXIfim8bLruhyJ5M+6h6TqO81a1NkPYoKpbZNXpNYK1sTXx12P3Fg7PKS0mNer1E9y0ayTmM7Ngs3kGCAnjaZxOBrYjqW2bWazDi1PitXZJgaVN1bhZgIVZq6W2oJP0fzANk/Hi01sN1ehjc2TVPgpUy72UCsNu/onD6twMkLQdjDDwThXQ1mHEYjywutAxlSDx1ARGuOJsaVo/qcXUiHiHz6IypkVCh1G0DNps/Ea4897j9tjxOY4Y0r3kVCbrbiIm/9S1XAkzRukklDmHfdrKlcMM74uQdxBuL7z7KIIF9kJ9AHhW5FwTi7L5Uu5Ynp3MOxi1VWCMPh6TFMbKooOZ3nGoyJMGEfMV8/vlLTJvzsaWKz3qQuwwr2UkDylBnWE13U3rLIMqhL810sEM0baTu6fX+pCHqTx5LGJM6WDH3kWBDtPsrqqiFJ9zloYpdSjRUh5b0XFAZJetMeBFW7cLZl/Y4gN88Wv0JcZDWwzeGBDzvKmgf8u9+Fn40DLVzbH62gHjMNdt47wI/13wXsJKxsf7
 ndxrPip8
 YwUFZbnlpkYwXm2XTewcLiagXk+gDtddq/OSMqQ7cEntcJbgxbZTJ7fRVv2pU7DbmGyu2ameet0Um3OnwLHIOAMLVBSwf7slDo7K6yPheUJ2si6kVcc5zIy5xIbGICB0rf534q5NwjiNSgk6ge9U9e19aEmzPHLx94ggKJoj9HX/eLluhQWk909AOpAEQY3iEda7uJEpUrn63eyz4DIlt6iui/Ph/esYINwWhCwLOHrKFCnzNq3cadZyNnv1rV8kH4CPmFacKNHdb5k05AjFdkgtJZs5++7cv39ZV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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

Thanks to SJ for the suggestion to drive the split fraction
from the remaining budget rather than an age-based filter.

Changes from v2
- v2: https://lore.kernel.org/20260626085851.70754-1-jiayuan.chen@linux.dev
- Collect R-b: from SJ.
- Rebase to latest mm-new.
Changes from v1
- v1: https://lore.kernel.org/damon/20260521045236.115749-1-jiayuan.chen@linux.dev/
- Some feedback from SJ.

Jiayuan Chen (2):
  mm/damon/core: split a fraction of regions when nr_regions exceeds
    max/2
  mm/damon/tests/core-kunit: test split above max_nr_regions/2

 mm/damon/core.c             | 49 +++++++++++++++++++++++++---
 mm/damon/tests/core-kunit.h | 64 +++++++++++++++++++++++++++++++++++++
 2 files changed, 108 insertions(+), 5 deletions(-)


base-commit: 86100fb7e27ebb5da22fc8a2810eebcf8cc897e8
-- 
2.47.3

