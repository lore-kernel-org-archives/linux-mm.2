Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C479DF99C9B
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 22:28:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 531B96B02E7; Sat, 18 Apr 2026 18:28:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D3666B02E8; Sat, 18 Apr 2026 18:28:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D1046B02E9; Sat, 18 Apr 2026 18:28:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2A79E6B02E7
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 18:28:12 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B420713B392
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 22:28:11 +0000 (UTC)
X-FDA: 84673115982.12.07990B2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3D462120003
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 22:28:10 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BEJOAkL2;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776551290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=/GmwVYui1RdcJPKs388g61ETL0Pr3JjclcYDKPx/w64=;
	b=ORvela7bjYg3fpVvpkqlzBmksdVp5w1Y9EovLBJAgibBvxCi+HtJ8boE09Qb6Ojk5Izyxh
	J+nPQkzdWXyX3zdO8Hpv3Tg9d2VY7w8yYukHOte80XwMnRtQJm1XFVHfbGC23ZnMoRyWBq
	12t40yU0MuN2XMlYRefQ/b7CYYrhiWs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BEJOAkL2;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776551290; a=rsa-sha256;
	cv=none;
	b=B4yBzy9f1NUghpryeSWFBdjXMFmJEGGZkkPpMyJNYxe0apGu0BnfUIRlnFsfYzdWVPqIlY
	fyDk0+1GAJNbIJPn85aiwwXICaP7v+pkq3CfuB1zvVoeVa7eYBkY5G8bdDqcsf/SiaKbLR
	TplB6/hT4JR9pNSvQbMKubu5XnFshN8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5BD4C6013A;
	Sat, 18 Apr 2026 22:28:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5E17C19424;
	Sat, 18 Apr 2026 22:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776551289;
	bh=9yul95wqLl3nq5JfsYt32CCnOA3waACfBiqcOYDFS28=;
	h=From:To:Cc:Subject:Date:From;
	b=BEJOAkL2isOzj1cSx/MAnwPS02jMcTkjYOc/ynW/2zTqFPO6Rkk+Xpmj2h9Tnre6u
	 7DoGXzuHXy+TRHND6/zjS1XnBytUJ95lPXPeLoJVXPCjsajC9kc7MWmjmHqF/16hDL
	 TUnrW50Ep3mWJuEQ9DYAKWpy1PQGDzadoRZxGHh8guf6YlqVwPz/XJ2o7+aXLN1SDY
	 HkFMqsLOKUMhBc5ZDf4DF8KIAV7S7YpNZU07h+jL8ADnNaowqUQVB4L/wHXAvK//Iz
	 TTFTlnTNK9Y3e2dJXK8yb7nztI1MSqbi5OBRDNDgiawdJBcPtak/AJh6ax+v2XAVP3
	 OTP/lXYsiobQA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 5 . 19 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.1 0/3] mm/damon/modules: detect and use fresh status
Date: Sat, 18 Apr 2026 15:27:53 -0700
Message-ID: <20260418222758.39795-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3D462120003
X-Stat-Signature: u9rgyam1to5ba13sd4nx3mt573nj63ei
X-Rspam-User: 
X-HE-Tag: 1776551290-352860
X-HE-Meta: U2FsdGVkX19T2OhEAZONW7h9MGi2GxSMaagBW1czGWzn4nFAMxWIRdXpMrWGnU4KQcMTBbMp1qjIMylNCELcLEPqBwrsoeF9vmsSVMp2rv4B+WrQDpY0jxI9YpOh8ul5F/jXb4oo3Cz8BUrizV1QS04nhEwh3uMBfhCwJEi6r99qV+DVhk4kMxYH4erhH8xdqHYCBaZwPXd9PRM7M3S1xIWSkKBCVfopK1KmoAGJNaROghqNzvihGVVcvV2/xqVz2MECW9Syu82kQe0QeRhBnD6AWr9zfrnLKrk3uBBNH3t4zl1TyrNdRonV0fDz4I4zGFAc+M5+Ud61Esy8WKeXAapBarjSqcEmpHMpDrZsdzXWz7ZqBgrK6aBxwCifMnt4hs+bTVaJLktB/pHgWfgXTHIuGaSOzfzYn2Pu6fNyf9sb8QNwHw9qkzi1joYe0EA4ukU7lrRv3C/Zp7+cVjFrLW5GHYOdXoDj95r52zm/NxYfww6t2v2nwf/WIJtR1GgQD+swncjZaCixOWWmKaY+zfrL5ALjmIDGs80BOK5K0GLA69kNQzITcabqw3t7hRAqZ2HQlM1PcOXLeU5LZ1tspULCRfF4JZKeHY/juiO2RUnYsYrSgbtthCfiyWd2wYRm+yVXUW69fCGYQNGVE6TQzUhQq+BmkqJ1W2e6iiOeWlrBTM36Klihjj9voQVfV5e5ta2b8HgHnJzz1dsnXJyYVcTilPP81DriQSRAI+YD3W1pgdixVvd+va+arkm02SO60Y+40e6tjkyipW/AU+c8FUQ+9L4DnnG+ObKPCmeH6Bz+ZC3iQdW9cUFPx2TcSHkgNGcs+8XaC0dV6d0MChPH/7vyB5ZCGkZ6z9csmT/cUWzvCeydQLhV+ANLtJVjoKWUMXy1A2CjQXH0tUVUMPeR+SoThWkbkRUpMFMMWaiV92ST01TYEmv1qP2TwqgEyfW/0NCDkONADk9bdALXq9J
 V2PL7qUv
 FG8BfXMH0kfr/g1VCIRDIjLPgxD/QEdYgXebUxHy2QZhnIBIhNTJVpwqEU83qNj8PJwjEILhmFbGEqQk/8N8B9XVGg9ebNnVtcn0EYb8dVBSyXLySC49T2kZWZ4xZ7w5I/QjoF/M6twKUp1PUQWmrU8clSg2rrd3NGI/SutUkEUPqN7WltTFg8LjPS5FYttPJLZ9ynPuCDEXvWPwGAvIqEw8XNEjFXcTz/FsKMAuBIsJrxxa7+zM7YWajX6SyDVTgEwfN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON modules including DAMON_RECLAIM, DAMON_LRU_SORT and DAMON_STAT
commonly expose the kdamond running status via their parameters.  Under
certain scenarios including wrong user inputs and memory allocation
failures, those parameter values can be stale.  It can confuse users.
For DAMON_RECLAIM and DAMON_LRU_SORT, it even makes the kdamond unable
to be restarted before the system reboot.

The problem comes from the fact that there are multiple events for the
status changes and it is difficult to follow up all the scenarios.  Fix
the issue by detecting and using the status on demand, instead of using
a cached status that is difficult to be updated.

Patches 1-3 fix the bugs in DAMON_RECLAIM, DAMON_LRU_SORT and DAMON_STAT
in the order.

Changes from RFC v2
- rfc v2: https://lore.kernel.org/20260418014439.6353-1-sj@kernel.org
- Set kdamond_pid set callbacks.
- Support multiple enabled parameters setup on boot commandline.
- Acknowledge the third patch was discovered by Sashiko.
Changes from v2
- v2: https://lore.kernel.org/20260413185249.5921-1-aethernet65535@gmail.com
- Add RFC tag back, for sashiko review.
- Detect and use fresh status instead of trying to catch up all scenarios.
- Change Liew from the responsible author to a credit-deserved co-developer.
- Move authorship responsibility to SJ.
- Add DAMON_STAT fix.
  - RFC of the fix was posted separately
    (https://lore.kernel.org/20260416143857.76146-1-sj@kernel.org), and
    only commit message wordsmithing is added in this version.
Changes from RFC
- rfc: https://lore.kernel.org/20260330164347.12772-1-aethernet65535@gmail.com
- Remove RFC tag.
- Remove 'damon_thread_status' structure and damon_update_thread_status()
  (SJ pointed out this was too much extension of core API for a problem
  that can be fixed more simply).
- Add a fallback in damon_{lru_sort, reclaim}_turn() 'N' path. If
  damon_stop() fails but kdamond is not running, forcefully reset the
  parameters.
- Reset 'enabled' and 'kdamond_pid' when damon_commit_ctx() fails in
  damon_{lru_sort, reclaim}_apply_parameters() (kdamond will terminate
  eventually in this case).

SeongJae Park (3):
  mm/damon/reclaim: detect and use fresh enabled and kdamond_pid values
  mm/damon/lru_sort: detect and use fresh enabled and kdamond_pid values
  mm/damon/stat: detect and use fresh enabled value

 mm/damon/lru_sort.c | 85 +++++++++++++++++++++++++++++----------------
 mm/damon/reclaim.c  | 85 +++++++++++++++++++++++++++++----------------
 mm/damon/stat.c     | 30 ++++++++++------
 3 files changed, 130 insertions(+), 70 deletions(-)


base-commit: 710b7b26c423290803f447f5ed2fb264e91cda56
-- 
2.47.3

