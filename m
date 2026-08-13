Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53664C5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 05:44:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41BE26B03AC; Thu, 13 Aug 2026 01:44:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F2B36B03AD; Thu, 13 Aug 2026 01:44:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E18F6B03AF; Thu, 13 Aug 2026 01:44:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 04EFD6B03AD
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 01:44:45 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 54B65120513
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 05:44:45 +0000 (UTC)
X-FDA: 85095156930.02.90207CA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id D2661160003
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 05:44:43 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dbqrgx6Z;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786599883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=GWrqvTQp5gX0iQ380NMQ1BcygYRwK8eMayqbx8OVISw=;
	b=qeVQ+km9TtXX47cBQVvkcwsfagQbFa2VbinuJcGhQ4i6dvfeHCNTXZHLFM9gW543tArgPn
	rhgfGjI53acuQyTZiDJBKcjTH7L+msvW5Wzhjhf1AzKRizXHRHT4Gjrugi9i/dxZSxSN1k
	yT83wm3dxcv3ZXntoPK5S9dUxfRqhlg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dbqrgx6Z;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786599883;
	b=kLLxy1N1k5R3LWhmqJnJMcUc0Q0MBPRNW1a098rytI6LDZFXC6TYvF6MYiYIXXTO1w2XWl
	kKeRTLUtiHMSCcDCxm4DFMRRDJYT1ssbyv4muLYi4rTmSOfDBWcLv4teFccUjuTgk4uPLp
	6fMwXHwjeS/AtCp1KnrPSebtGqWQTe4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0B6C9600AF;
	Thu, 13 Aug 2026 05:44:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A4CA1F000E9;
	Thu, 13 Aug 2026 05:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786599881;
	bh=GWrqvTQp5gX0iQ380NMQ1BcygYRwK8eMayqbx8OVISw=;
	h=From:To:Cc:Subject:Date;
	b=dbqrgx6ZkdUXnevKHGzSwRe9qhb6DGHB46sDKOee/I9+8JI0DwJmlzqyLUtJgfmTY
	 3lGr3tDPSfzbGQDlicPe2TtMzmSniCoBBsetipySKsdPdiRN2qIv+IX9G4pz8nQbjz
	 HuHUT0Bok71wNIJhlUGqVESGz4Zz+TzHkO34GfN8vYEaoF7zJfrboJ9hYjuQDryN9a
	 DGTOubeaAQXCQYa0JmiNYF+Qle+S9AQEpyCyz1HPewwijXthOPewNwEhVTLRsW4m9w
	 Oa0UZ8dVJDu6Bxaqa78BSC00tG21ci2uqBiWKnwDE9ebXlsPph0qR8vcOQRURGAYZA
	 /gdVG8YK3bAcQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 0/3] mm/damon: move zero damos quota target_value handling to the core layer
Date: Wed, 12 Aug 2026 22:44:27 -0700
Message-ID: <20260813054432.101197-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D2661160003
X-Stat-Signature: ty7o5oa174bfaoob5rxf4kuay7amywmz
X-Rspam-User: 
X-HE-Tag: 1786599883-343308
X-HE-Meta: U2FsdGVkX18HRcBzVxksAz2v9NfQc8TRCWHrVLVfG2G9PwkmNl/46L3ehH8WbVW9lQYcYQAGYjZFrNY8IrsdylhnyIQm39ybE31XXgKCpmeEUkPPXu0LXG+krn5t5Gd+oP5BQ4EkiWyExQKWikjVMnLpPVs7lujT5h3ahqzUwLSJwTRqRBv2JSyYx/N5iFm3MglfWbQHLRmwCJMDMnMt9xIaTFT6tSxZorMrPiKzteg9c9IQGDCLJxLLnVSmaMyFylzLtQi0QZdUufQ2h6r8B3Y31qa86YE/WhdR4Kt3/Kh5ueRj/6do91Xr14qSgW5yxjGykqwsSWdKkyZpTqOhJraGESw/S0R4D3YhjOvTq7ffGHq1Aeb218S/bMEB/DDxECq+8dAWIfprxHHg1NiYofzeIjdIFIAwJPY7Vx2Q+dzGRGpULRa0D23cPrv7TT3k65K4irwfIQM94EmfozZfcE/Phk2MaKqcR1Qw2ShCHmcsh2KCT8hTXkpckEPa/Zy3Esr3lBRD9Cu5fyMjIk0YyP3IMzqYIGXhvq49bqpMHPxTlKaqRqdk+hwyCKCUuXWzDd42w7CSTLZDhyvHacTgYbdpd76zRt+iU86RW1q7ETyDx7g6vlplZ7m958pti8T+qr5HpvGkXJYygB8rIdDbbDt84XQOc9P6YMp3EWYIyXCiwcMDUW5CRMlB4ZB9qsCTw0lWR4zV/Cq5kZNDBtwr8/9go90OFce7NSpc9YgsU/YVEhtNMuNsDlFVFLOsFGijmV7UKjGKsL/wMvwX8NeglpP1A1kxePh14QpaVeyAYyqoXMhfJFxzp0H+R3tJbouL0Q2eYeRMPR20PRhsiEQCRQf82XRZ6yNuzkktoWLsDFNQHVx6mNaMNXlUooPQAdrLflgFIxeBVlnSXBYaXZNZyodldTkv/aVfeBwJjWJ9tuFKNjpJQy2YioIaisLTBIywr1Neh/ujLYR8ZBzf9nb
 9PI0vvfQ
 3gqwXG8Q+kNs4sJrvhwXYRY10zxNxR5JI0eKJ4bXObGqsaEUjomNZB3pSoBwknPsGWjGbBADky2r+xL5VB5R3O/3UO3DwhwYHSd80uc50GHl/4E0lHOY+clU3dotewbMVv0KP1UadXCLNOeoMPXNnR9mobBOM/5b+Yr7dHbJTis4Ex2qVPSl/86qn7GUMLIhO4KrApkFJem6AQsBo5mcBFojXE7OuevKhlQHpieODxs8liTaRI5ONrwaHgND/8vm/Dpp787Ic3U56zk5dP4xKO/7BeBozWYHCxt/kgk3i+ixCsFs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Having zero DAMOS quota target value can cause division by zero.  DAMON
API callers are checking the target value parameters to avoid that.  It
is easy to make mistakes in some of the multiple API callers.  Move that
to the core layer.

Patch 1 adds the corner case handling into the core layer DAMON
parameters validation logic.  Patches 2 and 3 remove no more needed
DAMON API callers side handling of the corner case in DAMON_LRU_SORT and
DMON_SAMPLIE_MTIER, respectively.

SJ Park (3):
  mm/damon/core: error damos_commit_quota_goal() for zero target_value
  Revert "mm/damon/lru_sort: error out for >10000 active_mem_bp"
  Revert "samples/damon/mtier: error out for zero quota goal target
    values"

 mm/damon/core.c       | 22 ++++++++++++++++------
 mm/damon/lru_sort.c   |  2 --
 samples/damon/mtier.c |  3 ---
 3 files changed, 16 insertions(+), 11 deletions(-)


base-commit: bb9dee2c45b87e872d6b1d5f812ebafaa952b7c5
-- 
2.47.3

