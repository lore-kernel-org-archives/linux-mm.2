Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB1A9FCB619
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 15:29:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECE096B0005; Fri,  6 Mar 2026 10:29:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E02DD6B008A; Fri,  6 Mar 2026 10:29:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA9BA6B008A; Fri,  6 Mar 2026 10:29:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BB44A6B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 10:29:24 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 60B7B8C034
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 15:29:24 +0000 (UTC)
X-FDA: 84516022248.30.3FE59A2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id E965F1C0006
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 15:29:22 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Qgi/yg6Y";
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772810962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ZTLOQ5CpXqh03t93vNLLHcQOUrV9y1CLQ515bQpfNYU=;
	b=vR7XnKIr3f4MVgsVD8ipYIQMw7AvbWAPrJcIo4QArJyl1+bOLpOjG15fpBz9AKRUoUIa0s
	bD6c2DN0v+WGVgCcdUYva8pmfyryiAFCVBVeTYMcbHGXKbuo8nreUvz6sI/fxlBfdU2MYB
	MdSPENzKjiE4X0VrfnzxSuFf34LN6Yk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Qgi/yg6Y";
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772810962; a=rsa-sha256;
	cv=none;
	b=LrwNPMzr18CCutih3nQtFj9FUHGy34aQQmFrPgy31Vfvb85IoQZxFzaNRg74DBBLbaRGwE
	MdFqryR9VDZYlHpSnfceyBuZMBVdrg7FyN1nvH1CfrbqERcS1JKStlabQvr5kDUC7CCFwT
	j/V8mJjSZE8/oUyMVXz6k32HiaCr68E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5074B60131;
	Fri,  6 Mar 2026 15:29:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4954C4CEF7;
	Fri,  6 Mar 2026 15:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772810962;
	bh=E14iF6Uxk2Oavef0L2q6s8ESqXWplXDEpDkb4fZORcU=;
	h=From:To:Cc:Subject:Date:From;
	b=Qgi/yg6YyYTyLiY4iliYNCvbDyAsX7fmBjIJZtx3q6lXMGKGskn3AusoHZEoAo7Xq
	 WVm6qfAtTEYZVoRsGKb3glk4HeyjbZeW7bf02n2Ffszbi6+LTEZ6Nu9cwn3YWgTxIj
	 qFnNxsocQ+IamtHf0XxvtietST9EMuZZgelM3gEz+Wu1Ndh3xeLRa3WuhAaSBuGMBS
	 aNtfTvEbkLyma6YdoX9qaxaWhMh4Iu23gu+P1VGJ4Dd9r9YeMJ8kmCVpLG1bVxYief
	 BpioUcuHSy29+erlfpl5jSLLv56UPXQ12/NaPCBq3/Rb6wIjrPQeM/f/NvjUMC3hfw
	 CCNXnK7ZiZuPQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 00/10] mm/damon: add optional debugging-purpose sanity checks
Date: Fri,  6 Mar 2026 07:29:03 -0800
Message-ID: <20260306152914.86303-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: kfwdsna6ojt8h8hu4wo938xn3iz891q5
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: E965F1C0006
X-HE-Tag: 1772810962-915026
X-HE-Meta: U2FsdGVkX18euD4NL5I00bFczjQffwkJV3aGFxeWGB57HaKT8yZF4I4Yr9Ie4s9bs0UeP/LwHvnc3ghjfrkMIGiLy2wV4G8GQLbNGYsVYLeWikIw21XTIaUy1jK4dhGVqoztAHVTYxNDNhGpzQ/t6h78kPUfXEXpp7+S7hffKo3dfixOfQRrYSDFWf3e1yPE/tMAULc0qXoxu2uEU40qxDO+wp19dR65IBN59qsH4nTXFuUdoyhXE2NTMfiQ/tSmDZCeHpCj2BSx0I/kDIz8dypWs8jMQ0EXkUpXNK/A+tcC6I8TuCddLH0OXl3/hR/JAMIEfoSK/lyFlnzkyVE51WMSCbJ1eLVoAC8u8RvC8JZgZtVmes6jlKzxTy2eveSS16ZbVeiw48X8SKXy9fYHrD1hC2AjqczX2M9lASNzbcFanHVsSergC1zivA0SFreH48atmTst7SIOrLm6xYX4HN4uYABc6xRBxWkfAGmNwBOL8kyIE6exRKKtFdCWpGGXPDAxOeA5FXNni06r5xi+dnAwAfAzNlHEHSfwVVaNh7x0q8MIoeYFbZAwhRGLRGdyVl6UKV9A9xdLcAxo3dG/pLmeCFvEE5J6j7WjNZYF8OckgzsZacdn3pDrq2ldZK0G/XzX6mXDrWCxGIBo82CC8q0KD9eD3Hsehg3szhSJq0Cv5JB2kxNAXNF3GsvvVQ5ez0jo52Phn1izi8Zre6995f6X/H3f4fKDP3w12Xe8g9Aaux64KU0BheSyC0l6SY0reBbvd7W+8xA0V1aas3BiYcClSAhWB491p8Xk80Djn1BFNCCAyCORbsgdc86kyLxSbIsBzTDhucTkA8erbEqDjK+7x0F1UST6j0K6sSNh4m3B3Lju1rXqlinceNlJPn4wpQKl8XklNCy0BPPHW8WirFFvD8UhqCCEXA8eGFH81/1qLAozbFFCiy3+d8Mev4EnP8QPhbcoks6WrpDaxCK
 gtif7KNa
 T15x7RCoXeObqBOm5mfdPJG5hi27LHZHLsVCVAvAHNsFJuSsgxfBoKa+8N+V0kPTFvur1gnFW/C4NsBe/dFA4iDgl4dtommn+HUBfHrd7RiiSAOb+s0C/e7KrmQaHJk1D3LMfE/ujTucULFvQalYsDqq0oOJb0X7UlavT4AHPkhdE/W3NPDy+M60peMfUngCpITVPCIJ3oIfQQcO8gthNVhz9DOYDjFDyflgFYLbj85Em4hwTWvIfW1zc9z9HbYwnfTwYGRGRhqh8eN8R8eb+E1mw4A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON code has a few assumptions that can be critical if violated.
Validating the assumptions in code can be useful at finding such
critical bugs.  I was actually adding some such additional sanity checks
in my personal tree, and those were useful at finding bugs that I made
during the development of new patches.  We also found [1] sometimes the
assumptions are misunderstood.  The validation can work as good
documentation for such cases.

Add some of such debugging purpose sanity checks.  Because those
additional checks can impose more overhead, make those only optional via
new config, CONFIG_DAMON_DEBUG_SANITY, that is recommended for only
development and test setups.  And as recommended, enable it for DAMON
kunit tests and selftests.

Note that the verification only WARN_ON() for each of the insanity.  The
developer or tester may better to set panic_on_oops together, like
damon-tests/corr did [2].

[1] https://lore.kernel.org/20251231070029.79682-1-sj@kernel.org
[2] https://github.com/damonitor/damon-tests/commit/a80fbee55e272f151b4e5809ee85898aea33e6ff

Changes from RFC v2
(https://lore.kernel.org/20260301174327.76849-1-sj@kernel.org)
- Rebase to latest mm-new

Changes from RFC v1
(https://lore.kernel.org/20260221193629.19332-1-sj@kernel.org)
- Fix WARN_ON() failure on kunit UML build
- Fix Wformat-zero-length issue
  (https://lore.kernel.org/oe-kbuild-all/202602221352.odZW8x1R-lkp@intel.com/)
- Rebase to latest mm-new
- Make warning message less verbose
- Use WARN_ONCE() condition
- Do the verification asap
- Minor cleanups

SeongJae Park (10):
  mm/damon: add CONFIG_DAMON_DEBUG_SANITY
  mm/damon/core: add damon_new_region() debug_sanity check
  mm/damon/core: add damon_del_region() debug_sanity check
  mm/damon/core: add damon_nr_regions() debug_sanity check
  mm/damon/core: add damon_merge_two_regions() debug_sanity check
  mm/damon/core: add damon_merge_regions_of() debug_sanity check
  mm/damon/core: add damon_split_region_at() debug_sanity check
  mm/damon/core: add damon_reset_aggregated() debug_sanity check
  mm/damon/tests/.kunitconifg: enable DAMON_DEBUG_SANITY
  selftests/damon/config: enable DAMON_DEBUG_SANITY

 mm/damon/Kconfig                     |  11 +++
 mm/damon/core.c                      | 109 +++++++++++++++++++++++++++
 mm/damon/tests/.kunitconfig          |   3 +
 tools/testing/selftests/damon/config |   1 +
 4 files changed, 124 insertions(+)


base-commit: b2de0f05a00142f219d8f6e96b22c8f19fe0446f
-- 
2.47.3

