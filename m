Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F4FC606A319
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 11:24:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60A2F6B06BD; Wed, 21 Oct 2026 07:24:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BAE76B06BE; Wed, 21 Oct 2026 07:24:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AA926B06BF; Wed, 21 Oct 2026 07:24:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 296EB6B06BD
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 07:24:58 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9C62FC051E
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 11:24:57 +0000 (UTC)
X-FDA: 85346401434.13.FE002D1
Received: from mail-m605.netease.com (mail-m605.netease.com [210.79.60.5])
	by imf26.hostedemail.com (Postfix) with ESMTP id D73DE140003
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 11:24:54 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf26.hostedemail.com: domain of zhen.ni@easystack.cn designates 210.79.60.5 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792581896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=fYQedfSsWo5LMmpMHGI7ycvMtfsOZlKk03CQjYqp/4g=;
	b=Ai2wI6RUqDp5iVdB2a8j/6NUnvUkJ35dasnh4D1vVlo8EdnIjts6rCCNq8IYkBj1oDuYvl
	K2PemhGz8sPQG3N4SG01NcA+c67HqVMBE3iCqcKrA6ZDTKvbokv7NZ+Ah8VssATv0hKyUN
	Q3HgXt+fUjFyEJDO3E8zfbqvvEPfN0Y=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf26.hostedemail.com: domain of zhen.ni@easystack.cn designates 210.79.60.5 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792581896;
	b=fGZ1ymA3Lniv5BJ+weaqcvbFzUzEUdBc9eDNzuHd6DNS6EP1vDkFfk1iL53MoY2jP7T0vT
	ejn1cgcCf8xnV0oZHKVpe4K6ITC+spnwL1w+mPbkyKpxfJPK13PLGdFBKkustJrozYz1Uq
	m/EQ0wHhU+edS2eUpV00xlgLGX1Oyk4=
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 204f151a4;
	Wed, 21 Oct 2026 19:24:47 +0800 (GMT+08:00)
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
Subject: [PATCH v3 0/7] mm/page_owner: add bpf_iter and kfuncs
Date: Wed, 21 Oct 2026 19:24:30 +0800
Message-Id: <20261021112437.1799213-1-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa15e34e6900229kunme08c1fd526accc
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlDGEofVhkfQxgaGExOSklPSFYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D73DE140003
X-Stat-Signature: bymu81pnejs74diwnr5x7red7jj8oufm
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792581894-553918
X-HE-Meta: U2FsdGVkX1+V3UGM+IPqN9bQA4M/3rKmeAR5zI06ebmv3c/6Tlf/+ilnx5vLu2nIoJkAat62QVEkcLTWypY7imNOcg8T7M1Rty7EKNny3f4vqNRVzzVPPVFiXM4yGVQQ3eQpGYMDiOWS6sHD4WtPUrXpvBqOrJAkyRjoL+sDZ5LRjF+U1VJfswDSZM62ExNvVOoV7MxfS6kALYx/WHPWCGG/nzchICuDUplyjtRe2iFUF5wfbR4QaRoG5zAoN4Yvz7cf6BCxdGT+jKNBxiO9IVYofJDqS0Zjb57urLnNZNRSfb0Ar30zTw5odoCXj3a9mxqP/MxzIE/UXSTip1X2nSp2lyAI8hFDx47TqKvrTJIkQsfb7bEieDeXLf+esWio+/WDRoj3IZYMKe9mDd6H1hT9WBHWoW5qmmUvDZoh9HI5xGsEeu2KNH0NVCTJldAcnzFI3hjtM176g9kS4gtXR9aMVUBnU+gexvN/FprcIiGsnT8X0+0K2av0GWml+VLyOlgjLboYl5HCP2u9rKUQhRyHlN1BQJTVUdSNZpuid5wn5geigJBhaYWhP+15C9o75abPaE28Lov/32SgXqHej079gOT8CHedX5V696V5el0PSfGPonr60RXr9VmjzZDDyg1XXCWn0H4dYk8oCmkd28oq8hZ4Ct9b66Tj+XQTcK3V8twEUzS3/miz8BFYqKHJeXjOke6yYFUWDUick8Njd+yEs0ruwQawrzSm8R+4nACxqutBUAgAHaoqPq6APoSut/GdjyJEOE/e+S2bVm2y8zR5FNxWogzqYM9gvHFT5P9BfoS9hLDN1GssCeupkBqHPAGHVLPAvaodmb7HNzvHFLeWoVyoOdo5Nk9Iatf2pi6f/C80jLwIsnSgi7lKJphjchCyNgGGTmf634ubnnfFyauA3OegK/y/5N4Kue3dxL1x8lIMhCeFtmzY4F8a3nVL5Jlh7k1mqTaFFbx9RxI
 HCmXwk27
 w+EeRQ50UR4p4ENb5ymhjDhVWiGjkV/KZa/KOyUtNExxZeCawuPcNW5QeuZ6w1tkRB3E2CMMFojgEzLZ6mUauayfhMArcxXq1qoNRui04RjeY/tsFTmzckiNMbosECZ3ocv2MNUvuv1KAK9fKY9UvaIlyyG+46CmLv8tJ+6McUeBdiBZz+nnvJoXXRUr6yYAFlSVyKmGdyO4gwql2EAR/F65FwWm49nPmwNdxHvvYP+mIDH5w8Naa6h73+jVqy+JeHUkq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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

Changes in v3
=============
- Add a mem-hotplug read lock across the page scan.
- Drop the live struct page from the scan cursor and the bpf_iter context.
- Check the page_owner_inited static key in the iterator.
- Without scan->page, start at min_low_pfn - 1 and let next() pre-increment.
- Gate the kfuncs with KF_PERFMON.
- Enable BPF_ITER_RESCHED for the bpf_iter target.
- Check ENODATA/EOPNOTSUPP from <errno.h>.

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

v2: https://lore.kernel.org/linux-mm/20261013122125.843451-1-zhen.ni@easystack.cn/
v1: https://lore.kernel.org/linux-mm/20261009112308.240769-1-zhen.ni@easystack.cn/


Zhen Ni (7):
  mm/page_owner: extract page_owner_next_eligible() from read loop
  mm/page_owner: protect page access with mem-hotplug read lock
  mm/page_owner: add bpf_iter target "page_owner"
  mm/page_owner: add open-coded page_owner iterator
  mm/page_owner: record the NUMA node in the scan cursor
  mm/page_owner: add bpf_page_owner_get_memcg_info() kfunc
  selftests/bpf: add tests for the page_owner bpf_iter target

 kernel/bpf/helpers.c                          |  10 +
 mm/Makefile                                   |   3 +
 mm/page_owner.c                               | 252 ++++++++++++------
 mm/page_owner.h                               |  60 +++++
 mm/page_owner_iter.c                          | 232 ++++++++++++++++
 tools/testing/selftests/bpf/config            |   2 +
 .../bpf/prog_tests/page_owner_iter.c          | 193 ++++++++++++++
 .../selftests/bpf/progs/bpf_iter_page_owner.c | 157 +++++++++++
 8 files changed, 826 insertions(+), 83 deletions(-)
 create mode 100644 mm/page_owner.h
 create mode 100644 mm/page_owner_iter.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/page_owner_iter.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_page_owner.c

-- 
2.20.1


