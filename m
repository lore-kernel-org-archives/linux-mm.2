Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C9E0CD4F3D
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 04:52:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 820116B0088; Thu, 21 May 2026 00:52:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D0166B008A; Thu, 21 May 2026 00:52:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70D726B0092; Thu, 21 May 2026 00:52:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 60B826B0088
	for <linux-mm@kvack.org>; Thu, 21 May 2026 00:52:57 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 167311C11ED
	for <linux-mm@kvack.org>; Thu, 21 May 2026 04:52:57 +0000 (UTC)
X-FDA: 84790207194.25.813C5CB
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf28.hostedemail.com (Postfix) with ESMTP id 44EFDC0009
	for <linux-mm@kvack.org>; Thu, 21 May 2026 04:52:55 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uARqszmD;
	spf=pass (imf28.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779339175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=N7qfxh/zfMOAlXTKCwcPQJBPsWRq4EyvbHE/YRBH0T8=;
	b=lIvSFGyi2lMGENGn/jfdIak8bwdjRPthL504Ha889kUsle0T7rRzLHou0I+JZ/49VwJU/N
	Nxvloo29tBKQzhVulzHO+N+M4o2rFNcbGcwZV3e7WGKfHKRM1Qqm2aFW7n+tbCSivU0fFp
	xVZ4eouQQk/Wd6oIFqz/34/C9xjwglg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uARqszmD;
	spf=pass (imf28.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779339175; a=rsa-sha256;
	cv=none;
	b=KstqPjDevZyrkHwhZdnJFH0PRH8Dy34GupSOgDwT911JgkZEqNPuqLq4iy3ZA9ElKTTiir
	OwvpOc3N/El6MG5frnjv/XnEpDgjgVuUly93EmJxuBT5/PFCu3J61dnWdq8TlwDQ7aYqxx
	twOnN5I8ouuVUii9IMA34EvPrknsfKE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779339172;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=N7qfxh/zfMOAlXTKCwcPQJBPsWRq4EyvbHE/YRBH0T8=;
	b=uARqszmDfkqT1jfFDWvswzOrjg5aZWiOcyLKMsZb86BzRZynvJdgn61Eez2N9NDFgZHj2B
	TIzgkZy5eO0Y+tthvD3YJwx+8+YWEUogOBXkfAlvp5o6qeyVp4Pqwoq7pwy2AKWqqzgOxy
	8ga6myNIfl4HRMLojD2HcmOEn5tn5tg=
From: Jiayuan Chen <jiayuan.chen@linux.dev>
To: damon@lists.linux.dev
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shu Anzai <shu17az@gmail.com>,
	Jiayuan Chen <jiayuan.chen@shopee.com>,
	Quanmin Yan <yanquanmin1@huawei.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] mm/damon/core: detect internal variation above max_nr_regions/2
Date: Thu, 21 May 2026 12:52:22 +0800
Message-ID: <20260521045236.115749-1-jiayuan.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: sgocfcrrm13ntf8gmaxpan11dckzcu8f
X-Rspamd-Queue-Id: 44EFDC0009
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779339175-467571
X-HE-Meta: U2FsdGVkX18Ms/0FjG8wexv/ZXcq2QDctL/KxmsHovMcQdLqpab/Itp4sDL6nqXnIXHNwpdGqEhCFQR4qUr8SwAx9NQliEEVVXBX1XA08CzVK/kYOpkw83qqc8l/gtQyJhFMVx9IFEPSVHQn+xCwPWGSwykByM72x0BAS5RpTz1Ati06PeZV7vwBRjF5PgP286Xpgq326gVndXqidpIAhaeCteKWtJAgVswRBJP+1cQPYfHvE2oBHoNs0WMkIxz87iI/AR6l1qgqVPuu5H8rJeV/7WPRO89eGsuYobxO8qJ2frmFojohqf0d6I6ejYtHPqNNLX7sHA4YGDOjiDarUie39I+vDOAYT3VFxTlUQjWr37+alYHx1+WW897rhjcv4Wbfzvbs0tF+vZji0IQPFyP1Fn905mLRfAIXzq95/SGm0sHdtsJ+QOAE6LgqJmqz/4G6DS0aOR9Fh/NFI8R+gGmhf/77GgKCiLKDSrufBdtEo4ize8rCFHh3andhYwGbnlGLnuDyI4CJZSP4cuKhEEsX3h/EYWT7nsmkdyTOhVW2yO4JWAlZGhl1Yb8A82v1wUYVo8r3JMmE9sg+Tg31kcfCVIlTrqIX1H2DY8xHoW0pT4jyNVvKtSICJ6aFrdgl8EaAnC/B3O74AWbd8v0Y0BFlqH2VS4kBLy3heXxCxNyv7nOKV78qV07txyhbw8HRNZLivZUM03TkRJ5I899w5VbkB5+ObCnEWb7Jpn2vZIYCc2L9fH0hdpufYg/9dB0+y1FlNBjIpzc/bw2pcr87uZOE7AJre8pWApxgLITjKkapSJcBZhL+aJVFroonKyeWSG1jWSVUbbgb45yibiaFxokge69iR27EbrrbXVAcJ+WtG2uVSzQFzT9YPwRwd5AIhfi1u22gsPCgI6MnpcTlZR2IvppknX33O0qx+yPA3TvL+Tj87jq5+4cxo0RP1DQ43rSDtuG8stNTo//RzZp
 YoFAg4XT
 1DPq06phSoP6WDK5E5vkx81UAo6o6tP4QG9gFEvrp5azX/32McqOomHjomy4Xxkekn1U/6Ut3q6qmR/YwPMsREQP9ILGqXZC3+y+3KCTLFD8NiQYQo0azaHUVB924unkRIufdEmDQIfbqxbkV1Ugx7nQvDh7eRPkGXs7c3VJvWJg9T2Jg/zGRWsmlpZWEof0ztIUaxiIZWBfOs/IQDz/TLopoV5/fixNoVcKRwoqp+FKplhS6IQdVO0tckg==
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

On our production tree we added a current_nr_regions counter (no
good upstream home for it yet, so it's not in this series).  We saw
nr_regions never getting close to max_nr_regions, and the picture of
the access pattern was too coarse.

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

Patch 1 lets this path still split regions that just changed
(age == 0), up to whatever budget is left under max_nr_regions.
If a split turns out useless, the next merge cycle undoes it.

Patch 2 adds a KUnit test for the case where nr_regions is already
above max_nr_regions / 2.

Jiayuan Chen (2):
  mm/damon/core: split age==0 regions when nr_regions exceeds max/2
  mm/damon/tests/core-kunit: test split above max_nr_regions/2

 mm/damon/core.c             | 68 ++++++++++++++++++++++++++++-------
 mm/damon/tests/core-kunit.h | 70 +++++++++++++++++++++++++++++++++++++
 2 files changed, 126 insertions(+), 12 deletions(-)

-- 
2.43.0


