Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07798CD98F2
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 14:10:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FAA36B0005; Mon, 22 Jun 2026 10:10:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B1B56B008A; Mon, 22 Jun 2026 10:10:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C2E56B008C; Mon, 22 Jun 2026 10:10:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4D88F6B0005
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 10:10:44 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B8DEE165BBA
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 14:10:43 +0000 (UTC)
X-FDA: 84907734366.03.2B1DAA6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 288C640017
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 14:10:42 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gcv08X6g;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782137442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=J9rAqV+BtrJJS3bA6hXAT31xn9dA5LK7yhOjyVOIFTU=;
	b=ZBs64xi1rjkGlLeJUdJK3E6kAWbwqJYPXsyAKpGeIa6j0iJMUP8lfkgvpNJiYL8FoZq6WQ
	OXuabNm2Vt+7Rc9Pb6WLMn3k2HNn0c7NsdXGb9m08Zc9TSNOnQlG9TC1H3fc7S7eUiFq7Z
	61+mKvqVr3ZGFH/SFTRWLtk+XHWfAFo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782137442;
	b=7G6pvEE3msrphmQakNgxM2eLTmAK4TGRyI27gwLn3BwS1cVGWrN81vjwB1ifzfx1Vx8DYT
	IU5X3V3opna7kbXlX+XZkNYWR2kXQftFGCz/7Wo0wIGeE4XEKLk/Q4/Tk60/uvAKYibnB0
	8ZMIf6pL+vyOipcWD1FM2nc5DWYIKcM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gcv08X6g;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 229664352C;
	Mon, 22 Jun 2026 14:10:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F7891F000E9;
	Mon, 22 Jun 2026 14:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782137441;
	bh=J9rAqV+BtrJJS3bA6hXAT31xn9dA5LK7yhOjyVOIFTU=;
	h=From:To:Cc:Subject:Date;
	b=gcv08X6g+i3LbrmFn2qQmBt8NVRzGcb4Q8CY7KbQ/jd26MwiQqtKCDJ/rcrAupG35
	 Qq6NQ33NLOmy/DVUyS4OXRoHQweV8dgowskar4kXyD4fWUgO3rdjPqw8CaqM5SVsSo
	 YCq3PHQFmNpv40lgnjtlGKkUgKp6V8ltuADGJEg3r8XERIm1snV0mzCmq63/PW4/eL
	 hrenBujrrOs/KW5WQSSBQlPXPccbyVaW2vtpKSe2bMxLdw8sHSND3ZNlbexQVOC2Pc
	 s+8ys4Qd9W/7bVWJBmjWVhG7GfLFDljJZczYkahTJQLpUv4ku/Xbs/wIBssdVu/skW
	 3IvOnE+NNA8mw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 5 . 16 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 0/2] mm/damon: handle zero {sample,aggr} intervals for DAMOS quota score
Date: Mon, 22 Jun 2026 07:10:23 -0700
Message-ID: <20260622141027.29145-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Stat-Signature: d5w79k95kfiipf4kfrjzy6sge8ncjhsz
X-Rspamd-Queue-Id: 288C640017
X-Rspam-User: 
X-HE-Tag: 1782137442-730477
X-HE-Meta: U2FsdGVkX19y5HBA1mzBnVyzJvL0eKF7legj+kbK0WqcgGeJP3qnc1CywaF8p/G/+yWYshxBuxDrmnurXRknimf4GODMnMyVIaVGq6DmR5W0ZRXn4osfEAgKmxsEG7gEVf3Wvp0J+gTdEKWbWahhVEIoJSiwApIxQgTa6h5foN9n7Stem73RjjOdSHx8MBd+T0ZHbtdabyGaRZE4Xv6eOmgKRqfYEnknu+7kukTRicpfB7GebshLuQbtuslSwvEt9lyMuvfYppYTBW+b6s7o5Tmv8fdGWh8QLUJ+pqyvBHUPIZly+hZALLthGSPsk82QGSVnaa6cHacuypDqqKOU8jiPi00l2k4Lvn1QfGCMdut3W2ImH6nIUd7YPtzporvydkqsIT2STsigYxzHls9E93oXqJvcy+toxcXnedv36BRcplfxV6OgfKKJfw26sDL+KBbGkWte5ThVN6dmPoKWZD03NvWFr1thve5B6714ee2dEA22gMw0LYG4lFucw0NSKdxALtwnoR8y0Not444Fc//DQ7Lv0mn3vkBUxoVUlRscwBCxXfU5yMdpVemDzrYMddBPaAhBXWRecy3g3gEhLzULRLnALk4o2z0MYk0RmD7TwLydyrQaMscl3CC/bRQ1bIBiYKNuwiqbXW5LWC1TKGx8JLMpy7w7zIA5XBG22R9ktdzNOH/AW/mUHAe8zG4bB0iDnt4bV3Wk14FVl8FLPJLHqdkXNKV/2NpLZLEGMI+i2INwa7hDJPCirkvLEl8aKaFMWxQFdcXymhQz54b6tbTsgXkl5+nb5T0wSn8YbWNCGH8qBY9baTEltZifgW4rOsU4nELz1teruzHWObUr989GIM9K0NTPn/YqBrs8ax+eO7NVBdQfjCD9EWpby4ExPqixIsKBri2LFwmquzSkH+hLGCXqqi3BfVnSNG72829AEfx8vMxvb0SBzm0HZw3rT+S/Gj0G15bUqMAi4Co
 mmh+KY3d
 IOlwgizbJ0suiDxNVRcB6SZRiLTcKHtCZfg3Ty7ERRGbPeAL80cbFfSfzAoxwb4kUxr/g/MxKou8hw7Acdvmy7H5nlY9nwbu43o7A4GODNJRre/tYuUDagnaFNu7CqFmxprodhfgtBi9l/S4Tn8x2GOCagqK+2+jaqJIl9wjd6Foa3i3Ma15pP9xDwCAPDUE/d3ys9geYxksloBOVngChWSXl9ytBhrnj4eDcDg3QVXHX1ZorjmwQI036nNV9FRdm46Or
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When the intervals are zero, divide-by-zero can happen during DAMOS
quota score calculation.  Fixing it alone enables out-of-bound array
access.  Fix those.

Changes from v1
- v1: https://lore.kernel.org/20260621154808.86431-1-sj@kernel.org
- Add out-of-bound array access bug fix as patch 2.
- Add the RFC tag again.
Changes from RFC v1.1
- RFC v1.1: https://lore.kernel.org/20260620171413.89555-1-sj@kernel.org
- Wordsmith commit message.
- Drop RFC tag.
Changes from RFC v1
- RFC v1: https://lore.kernel.org/20260619205144.150664-1-sj@kernel.org
- Handle zero aggr_interval case.

SeongJae Park (2):
  mm/damon/core: handle zero intervals in damon_max_nr_accesses()
  mm/damon/ops-common: prevent >DAMON_MAX_SUBSCORE freq_subscore

 include/linux/damon.h | 8 ++++++--
 mm/damon/ops-common.c | 3 +++
 2 files changed, 9 insertions(+), 2 deletions(-)


base-commit: 42306d32afd75f28e3f13a1259c3b52191b4ff2c
-- 
2.47.3

