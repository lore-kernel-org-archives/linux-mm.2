Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00B1DC9833E
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 08:58:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE2506B0088; Mon, 28 Sep 2026 04:58:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B92FE6B008A; Mon, 28 Sep 2026 04:58:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A80C56B009B; Mon, 28 Sep 2026 04:58:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 785216B0088
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 04:58:44 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E9D1E1C09F7
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:58:43 +0000 (UTC)
X-FDA: 85262570526.03.66EF33B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 633BE160006
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:58:42 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KCC4hCff;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790585922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=zRvkh9OOneOJqU2wdlUkVFuqM0bBnkKnmh6zryJNhBo=;
	b=8rTJzsuK9kTDCFlB52Scs785VGrEXX9xC7H4NVpoGjuO7J/nAXSZhqG9VPgBHfT7o/S4Ah
	tQ1Nf9+4TLZf8XrSABVwHWJ0itm3Vq8uGErOF5PfaTSlZQvBLkWSQGAhfMa6tZYOPi4pqD
	wbpkoTmJfJevNOgm3BK3RMlbdYDqFFI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KCC4hCff;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790585922;
	b=jgXHIPZGJuCvS1oagRKRF1jFYIjWM7/xt+SU8etRSLWpjgAZzeJM9eZ6GYgn0bZwRtw00b
	FXFRxhVSgtONvZ/fX+0xdULC6VfajNSce8x7IryR2ss/VC0W4q1O1muskKAU4LygZS9LR4
	uwI0bTQtggNQtZxTRXsJWEmLqedXpCw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 98D4C42E9E;
	Mon, 28 Sep 2026 08:58:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E2581F000FF;
	Mon, 28 Sep 2026 08:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790585921;
	bh=zRvkh9OOneOJqU2wdlUkVFuqM0bBnkKnmh6zryJNhBo=;
	h=From:To:Cc:Subject:Date;
	b=KCC4hCffLBTujGpfM0vlV61kHxmWeskmD3ttbzKJjZY2I+VEJPl5/cj2RW7iVcoc0
	 eVAd0MSWliugM0IG22R9sE/iFWlNFTKqYx1uVvHytkzrOV7mGA7jKwoXnf8SKsLJxX
	 GGUih1gIZGCQMvReXH5//OymbfyH3okQQ1mK5ADkDJkV+1W8fPjmsMQxrNtQXkl5F+
	 1s4KbS8sGm24J0M5nBhlFTjdg3DhDcSJQTzCdhjK2GKQpP2yPvQPxJ+VlsfaNwfmGY
	 rf00wrgn7Y7B/52hdoKo5rg5MF2hvvSBsxOwQHxOHoxBJZG4A6aMc4hWoEur2z/rg+
	 g7uZYPeeDljLA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Bijan Tabatabai <bijan311@gmail.com>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3 0/2] mm/damon/core: preserve quota state when constructing schemes
Date: Mon, 28 Sep 2026 01:58:32 -0700
Message-ID: <20260928085835.7675-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 633BE160006
X-Rspam-User: 
X-Stat-Signature: uhqhw8n3unhaq4fayygkbzdxc3j3iofg
X-HE-Tag: 1790585922-257307
X-HE-Meta: U2FsdGVkX19vPjzvH+o91BpiowwTHmbmvLiFWQjCXEdG4DeFDik5SjD+d5J8/N0DzaFbmCx+/wZG30mFumalZYIld/ufEUdQGDv0V/9ghoBID+6Tldlsv8P0J2jjv5ZQkenSlSYfg/4IiIE9ElZaMz8rb9w5owdG42mz5x7DX6WmT0+K51M0K48svUkTCDQe+UkwglpHFsSxK5czXuvBz56IHSEgQcli+CwrGk525/1Ii2QlT+camicKKg0ZyLrA+8errFqyEifHowcue3Hcjr7I16YPbD6hNbW1E+ZBDup1vyHlWJYSqeuGR3H7lg1QKrRrf6vqTpdLONXWNRVX6DkbYw2W9IPAi4EdCdQ7Ske8Akic17WS/sT13cbCg++DPiTDXqVxH8Y9vWlbrK3oL3oIEofl+9Yq4NvxlMhLkw5FP9x9TuQaB40KtyLkVIlPypULD7dvLMMODY8fr2DtEDjXkrGYQXQKajwm+9jNQZdvCQXMub7GqJH0hp9n1s2rqQmf9wtmjLsTv8huYp6rT3eBY6hHPEYEtkJZjdyYg/bY5OfPCVZK8bToIhbjgBPwdpGMZ9RomtSSB3Q0lzrrfKTeqj40T2Ad3fZMceBa+fcf4TjKD2iMJ0L3oe4CuJZeC58xQnBHU+9stGr/3EoLK6Hx3PiBbbly+WOZXK5B8xp/Sx5lgpKtNxRHa76yQtEMpxsqGmY5vyj7AZYEFUjSbUtoazsmYz+UuS0fc8U4cOv30Q4mZ7X4VvCmQO4BzJnyJFVpiJa5WGo79s4tkpUewDvA5Pn09786axcLwFjNSnz88y/EweODBMSjkuWZDoVPie5yqSt7zs8m7pu1aiqtZMwsh96pfUry6+9ZSsOn2mTSexeqcoeHd5W9VlQyylKdd9bXr+TY16S6wc4a30c9JNCOawmhUMMV92qDB0nndQv0rrT4AtqCbEJITx7gMzYrcGcJ3yhs1gQ/7tCC5zh
 j/Tmpgdo
 xFt9AXh4Lr3t9+uog6QKBUFq24d8bkNr7izPJOLVyL8monOgV9JYGgwJqa9FKCeaX/x++3cPcNvGpqQhfWBTHwrqo6sle+xowhaDU7qO7j5h30iSXUaOMn62obdsvhmPfYqXeK/zIqThtNKskar8ClvByHk38rNLCT14C/m2tC8pU9AvxkHkk51bCWJpcZaFDx17FWOvUyQTa2/WUAD9CEpkLRuiKzxJ7Ue5BQ6AdWMSAN1LKaZ8ZM3p0SYqTKBwKD0kNJf+rJzyOr7HzLf+xt7tOhA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Karl Mehltretter <kmehltretter@gmail.com>

damon_commit_ctx() first commits the running context's parameters to a
temporary context for validating proposed updates. Constructing the
temporary schemes clears the running schemes' quota state because
damon_new_scheme() initializes the quota passed as a parameter before
copying it to the new scheme. Even an update later rejected with -EINVAL
loses the running quota state.

Initialize the new scheme's copy instead, and add KUnit tests for the
constructor and for accepted and rejected context updates.

Note: below are test results and changelogs that could be removed from
the final commit log.

In the v1 live test with damo, a scheme with a plain 64 KiB size quota and
a 60-second reset interval uses its quota, and a full "damo tune" with
unchanged parameters then lets it try another 64 KiB within the same
window. With the fix, sz_tried stays at 64 KiB.

KUnit was rerun after the rebase on x86-64 and i386. With only patch 2
applied, the two new tests fail. With the fix, all 46 DAMON KUnit tests
pass on both architectures.

The v1 DAMON selftests showed no new failures (QEMU TCG guest; the
wss_estimation test missed its accuracy bounds with and without the fix).

Changes from v2
- v2: https://lore.kernel.org/20260924201615.4478-1-kmehltretter@gmail.com
- Collect R-b: from SJ for patch 1.
- Rebase to latest mm-new.
- Add a note for starting point of test results and changelogs.
- Fix typos in patch 1: s/detault/default/ s/occationally/occasionally/.
- Update series subject prefix.
Changes from v1
- v1: https://lore.kernel.org/r/20260921003047.12041-1-kmehltretter@gmail.com/
- Collect SJ's Reviewed-by for patch 2.
- Explain the running-context validation in the opening paragraph.
- Clarify which quota is passed as a parameter and use "commit" for the
  context operation.
- Point Fixes to commit 60bd24f272d0 ("mm/damon/sysfs: test commit input
  against realistic destination"). Drop the redundant stable version
  comment.
- Rebase onto mm-new. No changes to the fix or test logic.

Karl Mehltretter (2):
  mm/damon/core: preserve the quota passed to damon_new_scheme()
  mm/damon/tests/core-kunit: test preservation of quota state

 mm/damon/core.c             |   6 +-
 mm/damon/tests/core-kunit.h | 107 ++++++++++++++++++++++++++++++++++++
 2 files changed, 110 insertions(+), 3 deletions(-)


base-commit: 0fa0454423ab5bbe40db5783aab8ae29b40adf89
-- 
2.47.3

