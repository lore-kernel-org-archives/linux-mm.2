Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D6F1FAD3F3
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 04:01:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6729F6B0005; Fri, 24 Apr 2026 00:01:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 623BC6B008A; Fri, 24 Apr 2026 00:01:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5390A6B008C; Fri, 24 Apr 2026 00:01:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 41A5B6B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 00:01:21 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9BFECA0A83
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 04:01:20 +0000 (UTC)
X-FDA: 84692099520.09.1368D0D
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf19.hostedemail.com (Postfix) with ESMTP id 50F921A0015
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 04:01:17 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=M5c51Ncx;
	spf=pass (imf19.hostedemail.com: domain of li.wang@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=li.wang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777003279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=byksxEzb9nJLBwk663d+8vGN4H+tPBFRKcO5GaHPgT4=;
	b=p9xga17U/CBBtc2v5y66VwqxQ61SZOPEzr6WtYh+g79+mGwQ+mcM2ewwF8VrPEvF9U+ZVP
	GxgxFjFRKV1KXvM11SUdZHBIi/kZj7bhUV5GQQRmzkIqdkjQu7X8oESL4BaqT91HlaaSvg
	JenwE/VkLOkRaV6D86R9OHsR1GHnR1M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777003279; a=rsa-sha256;
	cv=none;
	b=NxzYpyQO18FmSN3/4JC/mGKaex/pCSHyCSDvtMoP+vvIgsN9aE4aOiGKsmuVRGVx4FN3g9
	qCOG/qfFDL3SoljY8k87KpZITSAMaTztlcGU5ex7+ndZe+gd3BsZX4IH2Rqdihw00eEJmO
	3Xsjcohg10JUXHA9gkvVqJwATZnznH4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=M5c51Ncx;
	spf=pass (imf19.hostedemail.com: domain of li.wang@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=li.wang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777003273;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=byksxEzb9nJLBwk663d+8vGN4H+tPBFRKcO5GaHPgT4=;
	b=M5c51NcxbBvz74sZpZC5FRP5+muglkXSkh41uSP6psI1H+4G+Z81buzzSHQXdqJ2//nO4/
	gxdvHJtTWxBEGfcBWrA0haH1rrxWU68HhU7b0y6ivIPv+qo60BaqyPw/47o0XizCytoJOX
	NTjxeDuRlzDuFtMz5Fxkss4gk9fzzVk=
From: Li Wang <li.wang@linux.dev>
To: akpm@linux-foundation.org,
	tj@kernel.org,
	longman@redhat.com,
	roman.gushchin@linux.dev,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	jiayuan.chen@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	mkoutny@suse.com,
	shuah@kernel.org
Cc: linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v7 0/8] selftests/cgroup: improve zswap tests robustness and support large page sizes
Date: Fri, 24 Apr 2026 12:00:51 +0800
Message-ID: <20260424040059.12940-1-li.wang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 50F921A0015
X-Rspamd-Server: rspam07
X-Stat-Signature: ag5wnx7rtfetonz51uq8o8xji87knhg5
X-Rspam-User: 
X-HE-Tag: 1777003277-581649
X-HE-Meta: U2FsdGVkX1/xtEOHEG9BVeB6DadP3qC7+OXzpdTOkM1KFSokyCE0bMvAJRdDviSYqemwRpYslxX6BjKU9b6qaWFSka11vp1oobRWPdUfuEafMJdVE0XgV5V95EpGU/HKEZEgXH2UCdDPTIuqDgprmHdoQExcgRy6MQiX6W+hA1GVtLy7tO1iDB8ikD8ZtGaLiHRyskGAdhDN3lvLrW7w781YNn8Tx+ZlXaAK5p2/op1FcG8HZMFDGycl9DKyQq1UWER1HoRgNbaLFTkhhaRVs4ZB8JDBuHa8eclhpZTqIII2JFTG0Q/I0+bvzg6ZHF353dzqlx/I806M2CU3gcrkMC10qlHAQ9y3Dd16lwuLbyyCJBDERdi+nrtAsm5o2gQXFyDDgax0zKTcleBpe5UJLsrc+Jc0h6pep1LYUWHlDQYCMnZD/CRnd2xF2vPSQ3xNDa6yNL3zDMT0YC1Rvw25q1b6ReNBVKmXlbeRsFk5ktjtsJqltBN9nTwlaSQpkTybQ2IUpVxctU1kVUIsR5OeleZBcgIfGuW3GzyDWvnvkvTzXsXwCvp7NZC81ZQGHqTp+5K0vyuYUnc0WYWOj2kTZjMs6lHArWXYTt436BbeETWPNXzFqy6Sd+/w5dOM6oGnSNQ5hRQP42ks6K7FYht9MP1r9zlPPDuRCQjBq4dDPf7/xTVy6IP5ZbzayrqklRMAxc95H6co95KMTSq5FXNZte/Vv+nlK7XTtfY4od+mowY9EVsJQCAETEdKcGtSexYxAYlX7hPoxwshfvGYzBXzxSW64+xvL8T2ar2oLakGXfvREN1VQXzZDQpUGCABOCIN3NtDgePVKX0o58BwWOORekt+PDrEeW06aoxRKYrODpOaoBO8KKcwmtC4My91/WHqYNpmGbGkc22KvAiAH8c9BZLOaAN92jdG5RrzSH9jjB6Og98FU9JUjxiE6Hin2WRNWQazd16KRH0NGxCEtLS
 qCgMOJLU
 LiIj0XoCOhWeD4qqfa65/DZ5/PPD0RkY0TfZyh8DEve7i5W+rAd9VlrLOkDcx+gjKAcnb49oQEdorXGwaO0C4/gQsIHIRv2ANG/0ZMvJbzXoQw0prGEvJOqeaukAjq/y9ZtpeiZxnTnFpnz1kGhzfxQqYeugEwhf6jXweceGc83WhuVSP/FUPgKHmvnkyxC4oqkH9vl8AMKQ0lhHYCL5cyQD73kOEToLCxNY1K04tqGQFWNQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patchset aims to fix various spurious failures and improve the overall
robustness of the cgroup zswap selftests.

The primary motivation is to make the tests compatible with architectures
that use non-4K page sizes (such as 64K on ppc64le and arm64). Currently,
the tests rely heavily on hardcoded 4K page sizes and fixed memory limits.
On 64K page size systems, these hardcoded values lead to sub-page granularity
accesses, incorrect page count calculations, and insufficient memory pressure
to trigger zswap writeback, ultimately causing the tests to fail.

Additionally, this series addresses OOM kills occurring in test_swapin_nozswap
by dynamically scaling memory limits, and prevents spurious test failures
when zswap is built into the kernel but globally disabled.

Changes in v7:
  Replace my work email by li.wang@linux.dev address.
  Add Acked-by: Nhat Pham <nphamcs@gmail.com> to series.
  Rebase to the latest branch (only one tiny conflict resolved).

Changes in v6:
  Patch 4/8: Use page_size instead of BUF_SIZE
             Declear page_size as int but not size_t
  Patch 5/8: Use page_size replace the sysconf(_SC_PAGE_SIZE).
  Patch 7/8: Adjust the code comments.
  Patch 8/8: Declear long type for elapsed and count variables.

Changes in v5:
  Patch 1/8: Defined PATH_ZSWAP and PATH_ZSWAP_ENABLED macros.
  Patch 4/8: Merge Waiman's work into this patch (use page_size).
  Patch 5/8: Change pagesize by the global page_size.
  Patch 6/8: Swap data patterns: use getrandom() for wb_group and simple
             memset for zw_group to fix the reversed allocation logic.
  Patch 7/8: Setting zswap.max to zswap_usage/4 to increase writeback pressure.
  Patch 8/8: New added. Just add loops for read zswpwb more times.

Test all passed on:
  x86_64(4k), aarch64(4K, 64K), ppc64le(64K).

Li Wang (8):
  selftests/cgroup: skip test_zswap if zswap is globally disabled
  selftests/cgroup: avoid OOM in test_swapin_nozswap
  selftests/cgroup: use runtime page size for zswpin check
  selftests/cgroup: rename PAGE_SIZE to BUF_SIZE in cgroup_util
  selftests/cgroup: replace hardcoded page size values in test_zswap
  selftest/cgroup: fix zswap test_no_invasive_cgroup_shrink on large
    pagesize system
  selftest/cgroup: fix zswap attempt_writeback() on 64K pagesize system
  selftests/cgroup: test_zswap: wait for asynchronous writeback

 .../selftests/cgroup/lib/cgroup_util.c        |  18 +-
 .../cgroup/lib/include/cgroup_util.h          |   4 +-
 tools/testing/selftests/cgroup/test_core.c    |   2 +-
 tools/testing/selftests/cgroup/test_freezer.c |   2 +-
 .../selftests/cgroup/test_memcontrol.c        |  19 +-
 tools/testing/selftests/cgroup/test_zswap.c   | 181 ++++++++++++------
 6 files changed, 152 insertions(+), 74 deletions(-)

-- 
2.53.0


