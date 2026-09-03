Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7228C61DD6
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 01:03:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AB046B00CE; Wed,  2 Sep 2026 21:03:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9333A6B00CB; Wed,  2 Sep 2026 21:03:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 848536B00CC; Wed,  2 Sep 2026 21:03:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 58B5F6B00C7
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 21:03:45 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D6BF4C03BC
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 01:03:44 +0000 (UTC)
X-FDA: 85170653568.03.FD84F22
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 54761C0008
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 01:03:43 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h+egqciW;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788397423;
	b=8q3MwnJfXpZcut6NJHbS1pVJTorrhj5qnWkWbJDCIYXQBqCZ3ruUGoSP1PUIASO68AgDo0
	KSsEinTAjvy2WNPkzZEXeWqLSOOACrK7fhEbzZySDlBgYY6UP35m1e9lxyr0xMROyiTwOE
	ywc5TbCkEbE0W1DUIz4CmVDgD+pODI0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h+egqciW;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788397423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=0ONhJWY5DgYVDUUnZ1xlMrMEr8Cx+Nb9XbB8pDmxhHk=;
	b=2ng+c4SYGaKoBQifVCQf9az1t1IDGFIG//IBrCnE8P80hGKGgOxxpfG54cfvWyPoJsSZji
	ObTx887ZhNHcR59eaKBihmU3klZdz7l/NWpa30zsaMa2FIgcoSDQDTbEXdWWZQrTjSz1dc
	o0MoxLN6OiAjj/ExfqclLO4hLBfi7NE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 917E6600D1;
	Thu,  3 Sep 2026 01:03:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CA4E1F000E9;
	Thu,  3 Sep 2026 01:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788397422;
	bh=0ONhJWY5DgYVDUUnZ1xlMrMEr8Cx+Nb9XbB8pDmxhHk=;
	h=From:To:Cc:Subject:Date;
	b=h+egqciWGoWX9TsIcJAj9E+10Dduu+fOKklXNcGnDE5p+hMmzylMqGVmO/W0UphWf
	 s1E32GSyGpmBAB7BLCrKZV78GOKerAxxT/3WeOs+3ZtrVuZ56fDECMNnlOKZpYz+E7
	 uLxleOlms2+ZVfDvUibwFZjCTKxocsA6cjKW7P4kjfZFL0bJAf0ZWQnmROD49Yxjio
	 iLWVAFWUsxxeuku2PW03E8jr6oMq4uGjfOpHre4540vpwLV0M9PO3yziFEW3oG1Dqo
	 TUO1Z4KhV1cdMi6wP6oIrDVIiWsfE2WJtE/6Xd6pXtkWYO4ZSfnqduMTHi4UrL4Iza
	 gEYyAQ5DXzwTg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 0/4] mm/damon: allow NULL or unstarted damon_ctx parameter for damon_call()
Date: Wed,  2 Sep 2026 18:03:29 -0700
Message-ID: <20260903010334.93622-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 54761C0008
X-Stat-Signature: ccb331tudr7cop141ub55gmorzjnwbmu
X-Rspam-User: 
X-HE-Tag: 1788397423-77282
X-HE-Meta: U2FsdGVkX18EnM98zd0RIp8vVyed80d7GcKTMetm03nvc5rSgXrAcqPA2wEaS9a4nxurew/SneOjAxALmzjpEXsHDKyAuASfQ9/Ls0mPoitRJk+HitaQYyVCj0Jynx8fSpziFgP5z2FwVyQlsVHz1kMHtVLkr0+5zjiKxbx15wpgm5WoFhi7LCVLDtFn142YmqKOQrGryqDDVxvnAjUESRXeJw9ZCmnhlTm/tUH8GoYpX9nPC2zJDr0uGPAFBMa/zRHrPKtkFllZL6pHWq763KZozNb6Iq0wUsZxlJhL1sEyDc8EeSFsQPitPnZkTIiaVmo8VVk7rbkwEbyjqBg7MvBGNQnWTaykfKYE43Vt5ADfrQOkr2kI1GQcsxw3Pc4GM1iIQiYvR8rM7jeOQ1KiNh4t7WoKpBC+VmAbxChGPGMnMnKnusNxOp9UOx1w/FemWEp1mfDF8wf7Xqmb6+EewayxHS5r2paNz9EoBtKKzXSjiwy0RibxvO5pg+zpS12usmd5hTvyYq15RFoU/Teu6AjQEBOS8h65HyIpfBMmZTsNMZcLk0nC+pUHmhx54M2waQ16QcJsSR5/ak27H53/Q7tFlgSa81F0ThBpQTkcU6HJyBcXRW+fAV3DMS2Pl2IxEYSnekQRRbL5N0s96BaXaDQc7WrAbCmgmzUzgeSECyXvdITeiQfW4cedu7Vxa3KBAgUMwigw0Ntb9xeemwcPCeaDCx8bEOsfJxx2JnBMNFScJZnYhwe8H8nk7Z9tIB0GQHswzutUEcaA6ozmJ+ID22yDXU5ItSMv6TNftveW4ok2H5qikW+RSyoueRO9bSz9IXEam9gyCeSJFAWFtJ5XpxQRDlI4CushNRy6Qn0yIBYH8kTaNDGJtHAojrBjTnAqsmvxXIyy/VWLS5N+lztGKb6YGaRc6J6Tl64r/ZvGIB7vrBZeGBq6nNWE2eegAFMBkxk3tM4Ybn0hzRmGZrr
 kmCuLMJU
 aHzSrFCOmxjF1WrEtkGuvCJIfnjAAXa0fuXHISPJsGkBxOmk9bCr+t9pgljlSpzG09MuD47Ot1sC6Zr4fNOmts9GKfwmzscvEPOS0ys0SxaNkfg57nzhzWtUJDEDqKxzHjuBJIn8plB89OUCxevaN37tb+v/s+JA0YWwXM856b1Is4h4cK+7vAO7udQDuZzfJ3xQ07glhwdIk1Uhyutn4tSzdKBzK2DNMads2pVvgXOMcwQabZc+m8bZO4SZauuLsLUfCzhsiSZEcVg773kuUMPclLQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Callers of damon_call() should validate the damon_ctx object parameter.
If it is NULL or never damon_start()-ed object, damon_call() could
dereference the NULL pointer or indefinitely hang.  Ensuring all callers
doing the validation correctly has turned out to be difficult.  Handle
the corner cases inside the core layer and remove callers' validations.

Patches 1 and 2 respectively allow passing NULL and not yet
damon_start()-ed ctx parameter to damon_call().  Patches 3 and 4 remove
the callers side validations in DMON_RECLAIM and DASMON_LRU_SORT,
respectively.

Changes from RFC
- RFC: https://lore.kernel.org/20260813035001.97364-1-sj@kernel.org
- Drop RFC tag.
- Rebase to lates mm-new.

SJ Park (4):
  mm/damon/core: handle NULL ctx parameter in damon_call()
  mm/damon/core: set ctx->call_controls_obsolete in damon_new_ctx()
  mm/damon/reclaim: remove unnecessary damon_call() param validation
  mm/damon/lru_sort: remove unnecessary damon_call() param validation

 mm/damon/core.c     | 7 +++----
 mm/damon/lru_sort.c | 8 --------
 mm/damon/reclaim.c  | 8 --------
 3 files changed, 3 insertions(+), 20 deletions(-)


base-commit: 7fe9a8a366a72a631bcb23c2b108669ab182f2f2
-- 
2.47.3

