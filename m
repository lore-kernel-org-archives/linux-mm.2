Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31C08CC6B08
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 12:21:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97C026B0092; Tue, 13 Oct 2026 08:21:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92C7C6B0095; Tue, 13 Oct 2026 08:21:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 842EF6B0096; Tue, 13 Oct 2026 08:21:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6230D6B0092
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 08:21:53 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 56889140B3B
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 12:21:52 +0000 (UTC)
X-FDA: 85317514464.06.2D327F7
Received: from mail-m93245.xmail.ntesmail.com (mail-m93245.xmail.ntesmail.com [103.126.93.245])
	by imf05.hostedemail.com (Postfix) with ESMTP id 60B9A10000A
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 12:21:47 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of zhen.ni@easystack.cn designates 103.126.93.245 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791894110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=7wf1YhTuqEiYv2/swd71gPX7M40ZtjP0seSC1zco3YI=;
	b=C9Uy7xCQbaIoFj6twT2K+5IoOan6fYL60+Yb6Nw3kYiVlKTwCbsOCoj2AuDizuynNfpPba
	w3z8du3XfgLyhoI6fBM7lEt9Z6a2a3cVwqMpcn7MonSTqZxOBl5vxKz/ioKojugsKNneKY
	QOFnekc1Nti9dW4MYtKTWUYMseR6+XQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791894110;
	b=dITSRjdu5hy5otmyIaiDQmQ8jO89bUfgkWsz4nchQlpxh5QRw1BeeElCkW87aEOE5ySjnY
	19X7UWNBg/xgbe7PisGlsiAziFNg6uxF0JbIQ1GOQpcZugclpJEFFdrGpOzsh9GFmNpv8m
	Akq0+GHGfKiXUArFINht4JrzKmv+724=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of zhen.ni@easystack.cn designates 103.126.93.245 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 200407ee7;
	Tue, 13 Oct 2026 20:21:41 +0800 (GMT+08:00)
From: Zhen Ni <zhen.ni@easystack.cn>
To: ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	eddyz87@gmail.com,
	memxor@gmail.com,
	martin.lau@linux.dev,
	song@kernel.org,
	yonghong.song@linux.dev,
	jolsa@kernel.org,
	emil@etsalapatis.com,
	ihor.solodrai@linux.dev,
	akpm@linux-foundation.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	shuah@kernel.org
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zhen Ni <zhen.ni@easystack.cn>
Subject: [PATCH v2 0/6] mm/page_owner: add bpf_iter and kfuncs
Date: Tue, 13 Oct 2026 20:21:19 +0800
Message-Id: <20261013122125.843451-1-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa135361ed30229kunm0bc94a6a5244
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCSBlNVh9MGBofTEodGB9LS1YVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 60B9A10000A
X-Rspam-User: 
X-Stat-Signature: ea4xo743dssocps5sn99sts5o879r4ao
X-HE-Tag: 1791894107-273183
X-HE-Meta: U2FsdGVkX18Q3cjpBU71iuNZlrFm6WAP3lc2i6U2gj0/cuyPr/rG7wfAJFz+mZsYCUa7YnWqOuGKTT1HtpP50DRvGJM4ho9O2TUggoL7gu7TuH8kOOmuZ9B36jvWVfA111Dxyjy5f+svFpRx1PMgD283R60oNKGO8Iu3eY9HH9JyFmioEnd66KIAis3nYaThZfbFW7BFfbFhU8DkeTa7YbmTADhTwOES6XEesoehB3RZmFNJfjRl2cx51/nectm+JlpjscT1ly2tDHaud6NbtYu7nRkBjxtdYjtrWdrasuA5WAoKMJWaJZO32CzGmBoyHVoow2fscqmLcha4gHw7mLJhTqMzl626lT7JTSoNW7Q98VgUU/YL+VMOTJvPNqRhUbcU3myC3+3pAeu2cxpW+xBeM8Z6whi1js2lF0Rm8GQ94pUvbW+0LI9tV3+7uSnZn0Tki2m9bOUa5Znp2LR57Y3XnjNBwXoHlU4c+D3JRz7Zid4t71XTjBnoMdC3sD+IhSrzviXvKu6XWNbwFDgqIQ6gRdFDs7LiTNdQQGVeflJwd/51oV1T/tMob+ktqxefNFBoL0mbMwCTuQNTsLQ5rcX8bwCPwLWzCd2AcjEDJVkWRQ9U9x4G1afxT8axpJ9Pb9NFVts3tvsPlhFxxHe4rkw6zhia6UbWLoJC/uVzVevzQz/dV3mLbvn/NR1oNNLNqZ1w2ZCOfC+tWgp/0CPBLl9Ru7jpEdIyqLaO73rrcxQ8uyaKmuSAFUISFOV1l1YrsBaZ9NW5Mozz7Om7QOK6l0oFtL6qcXdB0LfEXOfQhSCSXZt+LsHEmSTFRUAorY+XNNEtNQXZCk6FMp0d8b+TNH3V5DWPAvfZv+wNXPb7qQIeCJBHDVH0idIfGOF6mjwTTtCOikLFdOPZtuSQRUgkVGTnlxWGwjgPet3L1Msz6CxnsXZ/+js+atug/BSD37RRIj5RK2iA7Gnvrk4cDSI
 UfEFW6LV
 izAcZ86p/EoOIlGrf8wLsY9tGbYCXWVCkDZS6QWhJ7/oE2QjxMgbUuV4YRpSWhaiZgWjGV3f+oDI3zsUr0XXHJXT9lwmaLePGh+BiEecRF+lGA7oGoNfCcf78N0ICb1HWlN+WHG4F2GIfxu4Oek3W7roCoTYN2ktFn4P+XMW9Ql1uLqY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

Introduction
============

page_owner records who allocated every page and is a core memory-debug
facility, but it currently reaches userspace as the debugfs flat dump:
slicing allocations by pid, comm, NUMA node, cgroup or stack, etc.,
means streaming and parsing the entire file in userspace, which is
expensive on large hosts and hard to query live.

Exposing the same walk to eBPF lets a program filter and aggregate in
the kernel and surface only the records it cares about. This series
adds that access as a seq_file bpf_iter target and an open-coded
iterator.

Implementation
==============

The page walk is factored into page_owner_next_eligible(), shared by
the read path and the iterators so eligibility stays identical. Two
kfuncs expose information that a BPF program cannot decode from the
snapshot alone: per-page memcg info including the full cgroup path,
and the stack trace behind a stack_depot handle. Each record is
snapshotted under the page_ext RCU lock, so consumers read a
consistent copy.

Testing
=======

The selftest exercises the seq_file and open-coded iterators, and
validates the stack_snprint and get_memcg_info kfuncs.

Changes in v2
=============
- Route the zero-handle case through ext_put_continue.
- Drop the scan->pfn++.
- Fill page/po/pfn only when v is non-NULL.
- Implement page_owner_seq_stop().
- bpf_page_owner_stack_snprint() now takes the scan cursor.
- Buffer args renamed to buf__uninit/buf__sz.
- Removes the v1 get_nid() kfunc. The node is now stored in scan->nid.
- bpf_page_owner_get_memcg_info() now resolves the page with
  pfn_to_online_page() for an offline or removed pfn.
- Buffer/info args renamed to info__uninit/buf__uninit/buf__sz.
- Drop the get_nid kfunc coverage.
- Enable CONFIG_PAGE_OWNER in the bpf selftests config.

v1: https://lore.kernel.org/linux-mm/20261009112308.240769-1-zhen.ni@easystack.cn/

Zhen Ni (6):
  mm/page_owner: extract page_owner_next_eligible() from read loop
  mm/page_owner: add bpf_iter target "page_owner"
  mm/page_owner: add open-coded page_owner iterator
  mm/page_owner: record the NUMA node in the scan cursor
  mm/page_owner: add bpf_page_owner_get_memcg_info() kfunc
  selftests/bpf: add tests for the page_owner bpf_iter target

 kernel/bpf/helpers.c                          |   7 +
 mm/Makefile                                   |   3 +
 mm/page_owner.c                               | 219 +++++++++++-------
 mm/page_owner.h                               |  58 +++++
 mm/page_owner_iter.c                          | 197 ++++++++++++++++
 tools/testing/selftests/bpf/config            |   2 +
 .../bpf/prog_tests/page_owner_iter.c          | 193 +++++++++++++++
 .../selftests/bpf/progs/bpf_iter_page_owner.c | 159 +++++++++++++
 8 files changed, 758 insertions(+), 80 deletions(-)
 create mode 100644 mm/page_owner.h
 create mode 100644 mm/page_owner_iter.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/page_owner_iter.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_page_owner.c

-- 
2.20.1


