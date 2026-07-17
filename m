Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F3D6C4450A
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 00:30:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEDFE6B00AB; Thu, 16 Jul 2026 20:30:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC71F6B00AC; Thu, 16 Jul 2026 20:30:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 992396B00AD; Thu, 16 Jul 2026 20:30:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 714566B00AB
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 20:30:34 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F01A04037B
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 00:30:33 +0000 (UTC)
X-FDA: 84996387546.01.2AE1CB3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 786DBC0009
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 00:30:32 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RuglQjDn;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784248232;
	b=7Hh2Ojnmnbp58Yn3+kLXQgvmouyb39K+HSkAdGHxqA+uwJdBu2nQaCvJJvAi8SSR9h0pQ2
	UbtiYwPtn3V4LkPTTQHAfCI9iSMUAWDnPpvvgbgkaGDI1Y27ZoD3EIYtq0Th7g9vIsj38N
	7OcwuJg+s/xermrSEJGz8JWu/DF5LDU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RuglQjDn;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784248232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=xM5gDQraqqXBT37mFYIx8WuUHVtDjm2kQWuZX7uenPU=;
	b=Ijb87NvJydaRtsCscvXAfpej+qjQKZm+mjzmr1hNIaIm7YpMzTLATTft8FvsNRcykrZfzR
	9PbLIMVfwKCCvAaBOuIWidgLKZ/6ZPamOVv5c8xyLMysvfLCjcTmX0ucG7ez/w+f5YB/w3
	7OWLeALlihQuO25qmBO0qvV1xjEOwCI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D8E2160204;
	Fri, 17 Jul 2026 00:30:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D3C11F000E9;
	Fri, 17 Jul 2026 00:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784248231;
	bh=xM5gDQraqqXBT37mFYIx8WuUHVtDjm2kQWuZX7uenPU=;
	h=From:To:Cc:Subject:Date;
	b=RuglQjDn3bYdgeg6ncYPVDXHbOj7ciTiM64J4RZbSLqjMtlMwvz7yMWrfYdvIeOm5
	 eFVRrwi8/McVixBoxsMIiXdjVOjlGsM0Y+Q1U3XRa7w6FWMExDLA04lNLgFrQrUO32
	 Xd7InuA11qiY1xvn82GQyp/+Jb1HXcYkfLhLdsIj0laRWtfP1M/NgMeZbqnbSUN2EC
	 +hWsHlRvOG92a7vu5kBIExeAVzDq8gPaD6TQpOfqzl1ELHDdVs9FivdGYlql5ATWFx
	 T4cNEgTzw7xp0YXRNQ+BpOZJ6LpLKlSH9a1Blg/OYlLMwfK0MZghXQ3PchL3oDcEQX
	 oA1Ovv72fRKgw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	SeongJae Park <sjpark@amazon.de>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 0/7] mm/damon: fix uninitialized DAMOS field and kunit exec expectation bugs
Date: Thu, 16 Jul 2026 17:30:14 -0700
Message-ID: <20260717003022.119437-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 786DBC0009
X-Stat-Signature: t3kfgcqmycfyzdn5r538ueeyfaj6tocp
X-HE-Tag: 1784248232-635618
X-HE-Meta: U2FsdGVkX1/Og3FrDXE/Tb/H650zUreBWZJ54ePvMR/8dVXx6o5+BoCN9TfOzDqCUOELNouBrmIipqe3KFKCJtoLNhaeLC7xVhAnKyhcq1lq0tdrJtGR5+YeEEdRagYdvAJgfrreUeUU0q3aZwxB4lgSGuaNWRPWyAnWqvjZZd9MHaxsmiEIs4RfZzxuHHi3O37wRTw9A202GECnvKoUduNpWvxc7wEpv4djU0c+0m0Iv8alnZB6FosBDspYWcWXCyucfCKEQ2PjP24jncCoDWNrL53o9Ih6Fsu5ODQdFYf1jv3KjPYWAumWQMKkzYspOcj8Pp3wavp5OdAT09hv/ZhagV/HcKUWSOtDA2AwFqOe+BMd6Tl5ZbN0oP13LO4+oHkZm1eguSoMvWkNEKKKnWyGdG5TqJ2ZQ6ppGf26KS+MGAzFqSyC04ZA1LL6vKlV/E1/MSO7hnxbxEUKY/F3cIz4KG5WGnnTrjFhK3llfO2wxWpK4qPihsOV0O4tEsCre8OBYk+lCS0JByb95aXyBLqsdp5pHkyMWn85o5+84N9wifBl8/Hn01eNPhTTZvzLyTenv4dBUjVqGU3jG20GtTGN576514o78coGhH3Ajpksr/xI1bivyXCIOAv60b9tMOC2PouZj1Jy/6oIpGIjzQd4RIkdgUlCXd7QxukErCoE2LHhjQ/ORFyh/3o0w6e0xh7jNbdir6mw1AEyc2Ef3fniuXZGuQ5/HQhaB4U57ftuIpQqDeTOZRVYwQFGpkhnhHJi8OgLITXVT546iCq2fDmqNs0F2djSvngq/tRmdS9qgxfTWGEDyKjfb9jb4Ht/n4X609FUVvas7j86PSDIpsQexUYlgUfFOxgDphwR8QJAH20h775hHdjFuGVmvhqi6jhvTpyp14hZd4gHUmgWciJgZ+ETWpDBiySNWAZ/5E+Frcy0dmy3lxe7ann/78WhKMKEGJFg7AEZHPSvVuL
 8WMUQy7v
 pGz0znOTAYuKZFXAaD2ey1lhteEhPsJkzRtCJ5p7fckU7BSdfqNYZOll6zekMMK3dYHHQMsS9Z1+jLIr+hahVydh1FIp10dV0l10M+o7u3Zf1oU03L7naHxYXRdjQGKGju6xztR6+R/ZODRG2y5df2n9p8jij8Fny515vtK3LFvNY+TJGbwGAlgLEISOpqUxb/tszGCHSatzBvrM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fix a few Sashiko-found unurgent bugs.  Patch 1 fixes use of
uninitialized damos->last_applied field.  Patches 2-7 fix DAMON kunit
tests that do invalid memory access under test failures.

The bugs are better to be fixed and eventually merged into stable@
kernel.  That said, the fixes are arguably not urgent.  Patch 1 only
introduces negligible DAMOS efficiency degradation in occasional
cases.  Kunit fixes could introduce quite bad consequences but those
are test code that affect only test run setups.

SJ Park (7):
  mm/damon/core: initialize damos->last_applied
  mm/damon/core-kunit: check region count before testing in split_at()
  mm/damon/vaddr-kunit: check region count in three_regions test
  mm/damon/core-kunit: handle region split failure in filter_out()
  mm/damon/core-kunit: skip wrong dest walk in commit_dests_for()
  mm/damon/core-kunit: skip wrong quota goal walk in
    commit_quota_goals()
  mm/damon/core-kunit: skip wrong region walk in commit_target_regions()

 mm/damon/core.c              |  1 +
 mm/damon/tests/core-kunit.h  | 28 ++++++++++++++++++++++++++--
 mm/damon/tests/vaddr-kunit.h |  5 +++++
 3 files changed, 32 insertions(+), 2 deletions(-)


base-commit: 1ce4cbd62f48552188b3f6fac8a14b709e97b7be
-- 
2.47.3

