Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFD4AC5DF8C
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 04:35:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7ECAC6B0088; Thu, 20 Aug 2026 00:35:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 776E76B008C; Thu, 20 Aug 2026 00:35:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 667FE6B0092; Thu, 20 Aug 2026 00:35:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 459D36B008C
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 00:35:52 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B7E09A307B
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 04:35:51 +0000 (UTC)
X-FDA: 85120384902.20.B5192DB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 236A8120002
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 04:35:50 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="aA/EjqIS";
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787200550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=0UCl+bymr0EVEpu0WEcn7AlKSOyhvVMhIe4G+bqwAr0=;
	b=ZeiK/8JanuRN3xyFM2gYaRTxNY357OJGp8zVaJPa3LMBQUvFzthBd+P0sAn7hB+L0rHjL9
	xV0ZWrZ4NbKLjqpHRv6IrPRhdUmjPd22teC20YNPJfgXTx1yGCAi1kqy2s4jvAZVFBxZf/
	064cCFKmDKgjkHX5qNqg+Gfmm2aAXzs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="aA/EjqIS";
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787200550;
	b=qp9RYUCnQ1d+VHJ0g98jW4eo727twaMj5PeBN1j5w2dPVkhhqRSANbzZphMrjBiInFoNvd
	BIzEbrnJhsFp8pZxZFMsgmPOS3l1VLyU1Ap38LN2rHzvIHo5HY+oziiepA81+cYJEFew9F
	UbDgP4qRYR/pguvjk/EA6UYmTRFHLVM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3763D61886;
	Thu, 20 Aug 2026 04:35:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE58C1F000E9;
	Thu, 20 Aug 2026 04:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787200548;
	bh=0UCl+bymr0EVEpu0WEcn7AlKSOyhvVMhIe4G+bqwAr0=;
	h=Date:From:To:Cc:Subject;
	b=aA/EjqISqhfzGL9cmUa1qc6uJqWVEsQ+/Nhj2bLZqy3l6S7yFmS5jYWV+J4mm2el0
	 jlzmbAvKkpjpFznDfyAjoSmTNhRDDV8ci6rBOFJlPjovm9j2UXZYJWm/xdMVSj9TiA
	 zfPm8zJTVFMQua/VQs+zL/oaWvqcG+W9fjUq+Fbc=
Date: Wed, 19 Aug 2026 21:35:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 mm-commits@vger.kernel.org
Subject: [GIT PULL] hotfixes for 7.3-rc1
Message-Id: <20260819213548.4160b501de0b9ab41029cfcf@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 236A8120002
X-Stat-Signature: b7xgy9khzeokpwytexjo8kogt3x7dnp5
X-Rspam-User: 
X-HE-Tag: 1787200550-938924
X-HE-Meta: U2FsdGVkX1/hcQTaM7Cwp9Bt4ypfwRMeA7GNmwW/RaHwpvDIfHmdWN10qN7RagHy19Ef9I/0+YSVsyS6RDhEetGiAQJB9cI0gLPbQ8lLnYJ55RIFlA8lKAzjkuMoCitYqViOhZaX1oq5n+U2Cy1muT4kCiLOScvEU+j4j/+w+WVLeZhpSARm0Pyi6LTCIPgpgmRB4x99J6R5iEjRm9fsp+ah1Hg0rjFh8sjjfwPnwrCSpSuz2pIqPSse6FulcyBcEEJsopoA2KIXib2zFtTIb1GW4ExKF7OtTVrS2gYNmEnHW9nlgxeGcc+GL3H+PoVtotXc9RPLNL7xanOTvTBE/NvP2yVad/VwXdpYieS70dvX/1jC4OD+RDM8TudH4z9DfEolyuuG89VhXs9ykY+nZdVxTk/V9AvkbpeYTKPFERgzKRlt2d2wDtFKovJ4WYvR3Odnf22xn53khEnsHfhDDslDbK4ey67U9m+RiChmRxZwjVyZY6zB5S9iF6m+EJMVdkQBg8IJuLKLFeLvneeHicL0UH8V3k+sNpeZL8e2zgnKpVUSVeJb/fUBhsYqH3c78TtvgXPgI+F02qCR82sludFlPZ8mJodZv9nbMYnOtaaByA1PTIZ5it96x0CkX/nxLNzJikUDsr5tm6iO1Cr23rgL7BzzAoIzZ4pb7iUYq7a1vZxcINMbMSsg6fUdL6of9lAQTbhj5fNrjfDoemnrNClQmwUZHrXTgEr5F7YUQkJY6/cRrHzoK9Y0+X/zUEG+4XPpuoV86dZjiR8cBiklsvyZfgrs/RTD9VxyQoBJ7mA5kvSDaNQYrGu3hRXt5SzS2Dwl21DYGZPmuj/6XPqGanEJVzBX0r4Kn34w25AF3FUBKMvWgMebLsWI1FKhQCuNr2yE/y8YlkEHIym/6bHiFmNr5f1YqXcIxh6vetpk4KXMOwrrRThwukix/cYgUOa/VwoN5WwmzqBsNLSWcu5
 bae04fFG
 hb9JBmTNIeZIjaeUnfJtxaJT/UEzJXVv1uOGLgW5G9WR1opgUeFwo4o6TAkXX4s9MY/r8rjYBvgIXfPBISOQPBVGvaipkoMXR9k1zFS++T7TJlJGQIOmE1tHIybrPBbsnN7GEL4q5/XALXgZs2p7QDAcDuSeV1cmr2pttVsuyNxhr6fsS6T3ojELshA3E3X0WszdFC8Zx88bt8tU5byg6HYQdJCa6qxOhzmPXiqokDgfTWQoNp4/k2DkVs/Y3BFdQik8jC/SuDOp8pbY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Linus, please merge this batch of hotfixes, thanks.


The following changes since commit 1ec0e6b6f7321feb769f50d2f094a0aa6c2eda63:

  mm/damon: adjust isolated pages stat for DAMOS_MIGRATE_{HOT,COLD} (2026-08-04 20:02:04 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-08-19-21-33

for you to fetch changes up to aedf2efd18977e0cef7eb963166e2b1fcc0aa321:

  mm/pagewalk: fix stale walk->action escaping walk_pmd_range() (2026-08-13 18:06:48 -0700)

----------------------------------------------------------------
8 hotfixes.  5 are cc:stable.  5 are for MM.

All are singletons, please see their changelogs for details.

----------------------------------------------------------------
Breno Leitao (1):
      mm/vmscan: report RCU-tasks quiescent states in shrink_lruvec()

Guodong Xu (1):
      mailmap: add entries for Guodong Xu

Guopeng Zhang (1):
      mm: memcg-v1: fix memsw and TCP failcnt accounting

Hyunwoo Kim (1):
      mm/pagewalk: fix stale walk->action escaping walk_pmd_range()

JP Kobryn (1):
      MAINTAINERS, mailmap: update email address for JP Kobryn

Phillip Lougher (1):
      MAINTAINERS: remove git URL for Squashfs

Shakeel Butt (1):
      memcg: keep folio's objcg same as its node

Youngjun Park (1):
      mm, swap: don't free a hibernation slot that is in the swap cache

 .mailmap        |   3 ++
 MAINTAINERS     |   3 +-
 mm/memcontrol.c | 102 ++++++++++++++++++++++++++++++++++++++++++++++----------
 mm/pagewalk.c   |   6 ++--
 mm/swapfile.c   |   9 ++++-
 mm/vmscan.c     |   2 +-
 6 files changed, 100 insertions(+), 25 deletions(-)


