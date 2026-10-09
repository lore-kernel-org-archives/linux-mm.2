Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6125CA6018
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 11:23:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A46166B008A; Fri,  9 Oct 2026 07:23:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F4D26B0093; Fri,  9 Oct 2026 07:23:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C3306B008A; Fri,  9 Oct 2026 07:23:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 620686B008A
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 07:23:36 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DF86F1A0342
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 11:23:35 +0000 (UTC)
X-FDA: 85302852390.05.A1EF59E
Received: from mail-m1602365214.xmail.ntesmail.com (mail-m1602365214.xmail.ntesmail.com [160.236.52.14])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4DC42100005
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 11:23:32 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of zhen.ni@easystack.cn designates 160.236.52.14 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791545014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=+fgvajKwulQLcEFMFGzDFOAsp6rq+o9X9a1q1pwb3AU=;
	b=zOYVBqyYimYGm+pbhLgAsZaQuMfAfYrQOE5S9YDIqxzR82kc8wGCRbf1U2tlb9K0sff/E2
	m8MBHwgF+sDhlc0FELlvbTBaIiz1W+TN7vj1M+rYmp4RZw6kk8OwjBrFdc04z6syx/zvEZ
	bCdWKI1h1OyJh2DaRnH+89Ab1kn5yZg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of zhen.ni@easystack.cn designates 160.236.52.14 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791545014;
	b=amYaYHoSYUN6c64C4PqJ2W2W1L4HPCgoQ0S6KD3bQKzKyBDx8vJ3VetH9h1ZaaGFixTkol
	e8NkX/RJjGso3eLN634WElpBKa2bCwZQeBn8Qf5V33YcH0NWzbpWiZfrh48mKE27GZyLdC
	j+aKm/X2hPIqXlLv+hEAD25HWxEJLaI=
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1fe29019d;
	Fri, 9 Oct 2026 19:23:24 +0800 (GMT+08:00)
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
Subject: [PATCH 0/6] mm/page_owner: add bpf_iter and kfuncs
Date: Fri,  9 Oct 2026 19:23:02 +0800
Message-Id: <20261009112308.240769-1-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa1206750320229kunmd33b3e054cb272
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCTE5OVh1NSBgaTh0eQhhOQ1YVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4DC42100005
X-Stat-Signature: m8qw68uuddsoffaqpr3irgnxbhhz1xa8
X-HE-Tag: 1791545012-533684
X-HE-Meta: U2FsdGVkX194qMOje8IZzq73lXOdlBOc4H3RY+aXkDcsC47gNZP7DVRsRjOBo1dmiy3IrOugV/kGD3EOLLGQ873pyYQhR5UjDSJ0U12VK91ok5ujhk6nkZzLA28At18+Nhic/f1RkAMRzNxR+GA/jdPhthnrpeS7FHKqAtg9fntVBvFJa9/cYYAagBgfwtOkl5hmP/NtDe9T9UDbQdSi+OwX5bWPY3NXteSUyhHvcZ70enHGvPxrtj80kzCO99OZfPbu1nQVMSEmJJVPKpzsOlon/xyohwTh5dQqJVW1hw+EuavU6T2/ItEeEIv2+bhDKwg2RVAXdqR+9LnYqdx0MbzN8c90nc/svO1HdOLLWmkKoJaoAZ17/0hk+T1ZMqKDdJPa7YkcxgjJlT/3pDP496ItpLFKlfH3FFR+Fin0aoGZx4/GHhw5Ig40ttPl2yaRzb66oKTDjxSYLFuoJNIK49MPHi8o9TT8kgywfr18zg+pt08MeZVBRlX0WiBBiztY9lARStRwRGLomnsKVTMEV0SDV70FNoC+hXz5dpi3YttDZrHriJLvWmAVgbl3gKd50fHI51br5uHaw5QnpQWpf1ZPB5SdE3A88yGln7lWsfCFez2pC1JV1xwz4eT+ZQsKeZhIzRSDMjn5Ojc+XSP0zeXwqn5c4Tryh8ud47TsRyjJhJzAV+SwJP5afTbA+aJmqpIyazgIO1v/YnL/z+hnP4dzl4uHpdk+2Cr54jAJjYUZ6MSbPqpAHsGmlQLE62kmEkXyNzuDNxjfcZJkzoFy1bFBbBFu6+iF1XHLBHAW+smqvxjvN1DCBWM1GlGojhjD74AHJtvjJIR3O+DX3Fa7sdb6I1+Oks+bbQ8y5+qnBdNm8xxcg86zAZn2TKywa6OGi3CwBcQLSzfZFy1xUKw4jqmhO9ZgJKOajbLgDVKxxz8JE3JeIuO9VA9G3zsdBOr7uAYb5lPJVZ3Ksc56oRE
 KhEZRL/V
 vYee6urBZ6qtSpuD9710VMj4ARb4ofI5q3zDy7yKvjSLsqhHyER8Cku4WGNdFL/jCgrkg7PVLWY+pQfFN5SWhRnNEe5nr8Ac5B+aPvG+kw+oL+N4=
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
the read path and the iterators so eligibility stays identical. Three
kfuncs expose information that a BPF program cannot decode from the
snapshot alone: the NUMA node, per-page memcg info including the full
cgroup path, and the stack trace behind a stack_depot handle. Each
record is snapshotted under the page_ext RCU lock, so consumers read
a consistent copy.

Testing
=======

The selftest exercises the seq_file and open-coded iterators, and
validates the get_nid, stack_snprint and get_memcg_info kfuncs.

Zhen Ni (6):
  mm/page_owner: extract page_owner_next_eligible() from read loop
  mm/page_owner: add bpf_iter target "page_owner"
  mm/page_owner: add open-coded page_owner iterator
  mm/page_owner: add bpf_page_owner_get_nid() kfunc
  mm/page_owner: add bpf_page_owner_get_memcg_info() kfunc
  selftests/bpf: add tests for the page_owner bpf_iter target

 kernel/bpf/helpers.c                          |   8 +
 mm/Makefile                                   |   3 +
 mm/page_owner.c                               | 219 +++++++++++-------
 mm/page_owner.h                               |  58 +++++
 mm/page_owner_iter.c                          | 180 ++++++++++++++
 .../bpf/prog_tests/page_owner_iter.c          | 173 ++++++++++++++
 .../selftests/bpf/progs/bpf_iter_page_owner.c | 161 +++++++++++++
 7 files changed, 722 insertions(+), 80 deletions(-)
 create mode 100644 mm/page_owner.h
 create mode 100644 mm/page_owner_iter.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/page_owner_iter.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_page_owner.c

-- 
2.20.1


