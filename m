Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E35D3C79F82
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 03:05:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDDDC6B008C; Fri,  4 Sep 2026 23:05:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB5686B0092; Fri,  4 Sep 2026 23:05:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCADB6B0095; Fri,  4 Sep 2026 23:05:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BBCE06B008C
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 23:05:46 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4076AA0265
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 03:05:46 +0000 (UTC)
X-FDA: 85178218692.24.77E1D3B
Received: from mta0.migadu.com (out-146.mta0.migadu.com [91.218.175.146])
	by imf19.hostedemail.com (Postfix) with ESMTP id 7A4971A0003
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 03:05:44 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jjyS1sLK;
	spf=pass (imf19.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.146 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788577544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Lv8emjDSLCQqXX4MOldl+P5GOTzFQBmPFgF9/GTZwgo=;
	b=b+rcbfvnAQS5QGcZgIuusuRz/q+0A+UzzeyXzZQqoonQenAqUgYzltC2Jz1dVjQOahf4d8
	9nITH5X+amTZTh6zlWtBc6FE/yslftbPMi0xsoOpQttWeNkjmRuHmN7v6cWqRDrU81QN8x
	Ep0ylW17Lekt5sIkrE0m3Tl3uSK7uDE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788577544;
	b=LdX6lbX0ElQ7PXtjX6TY046uHlEb+QPJsc7KVqbZSMmA5Rv9g7aW+cOS3O94+Ef2Y1iQbB
	AiZfzRwc1awvvcU6LKxnghfCbPnowis7E5VV+FlLYRTSeILsssXznDpOauprIeQI5n9o+S
	ISh/kL8XdHDxg+NyPntHMjoAksovGNA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jjyS1sLK;
	spf=pass (imf19.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.146 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=wLT7iFs3MczdphYR4AkXje9YdWj0uWa+VrRt5sOOktY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788577543; v=1; x=1789182343;
 b=jjyS1sLKPLphMwjUl3G1ZF2HBLcmNhPySNR4zxAcS88QvzF054XCtu14AWqqegKIG3s1pQvb
 b8QIDdHj9I8FHubHIlAzhTHgyPykidsgXl+mePQcPg81fhfob1uUDiQ62fF7DwOMfS3VFnWkKAh
 GjjNHCxS45UZAIsX4M90Q8T0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 50c0c96e9f01a2e5;
	Sat, 05 Sep 2026 03:05:33 +0000
X-Mizu-Trace-ID: 50c0c96e9f01a2e5
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Meta kernel team <kernel-team@meta.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] memcg: group struct fields by access pattern
Date: Fri,  4 Sep 2026 20:05:16 -0700
Message-ID: <20260905030522.1887837-1-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7A4971A0003
X-Stat-Signature: e6de3uf3nrkq9jpdsf8tj5aqyxgczfgz
X-HE-Tag: 1788577544-406476
X-HE-Meta: U2FsdGVkX19ffIv2JJwkg99wadx47RWhlS6zkcjfa23ss0uinNIJTQ9ieDAkRjVVZGjT0NdcUjXB/G/3d8vqeJx58VUBmgDccknr6cW8qSSv2/c2tlN51h8/RFsiirce7os0xFQJy2f2zCctRDu4HCIANPUJ7RqSKc0BILoJpiVBs7Bb5DP2GfbH7rD0ZLtZshWAMxF9g3XWQHIIlKJGrjSML3pCqqYF0uxqw2t0l+GChpvRzSSpvefqrpe0W4oxSyICmWMGCwoKUhMXkBkdDOI6IYfxOOg43UimUz4rd33Hca5UAyMmK5ThdprnaoQVWWkDHLm4lP7FoKFvhCgCvqTfYnxkMVKWPaaEnSTYYbZq/ac1BbNScNCchK8P0NmNCFpB0bb2MeDZuaWZv4IWNji+RoY483Em4uisB0k3DmcsbIAT24iRkHOgW5jF24UDhDVeNWz5achLmlGLsjcHdo4anaQa6ka2Pw7UrMxArRMeEQA1aGCZDccNM0k3lr6VIO1DKwxSr6VzTeUhu0Edvh9hzRIDJNIz/al3ZLePT3rGjE/b5mzEJ45/qZBSBEc42PZz3D4sPcFqoZWrBlX6WH0URj5dfPAdRaaLS4yCjhGHFrsXRUXK9XKKuOSrRy5HB87iyaWh3p5rUw1WlbJ4Z5DmeqBdAxUQDhkE4RN+PU5pJ883d2D3i8Aa8NWcEWlo0BKpLI1ep9hcgU2RfukWHtNeg6XIuDhuc8O5QdVYhaWw8PL2mw/5Bk4Vy9INQX5E5FdBKBnpmSS00Z8oIAqpu+RjjKL9A+6DOtp5oemR+WTCXf2NAWu45XAOx6YSQ0WOO+Rn9jtd3CxCFTIOUDII2gH0xRGCqkpunfwWlNV3TfS7324/W4Ut+X5qR99VRqCtQoP3RVQHdqIHORHS27j298TRmsJpw0pXoHGIQIh8gsWGzGYzg9aa5UHo1wLogp/p9MuIDjIU4r5IgQ1uT1S
 uPC3dM5M
 MaqEVfWNf6ig1HI8RjCoQkDQJErbHTUnOUkcc4Mkw0MMJfHn0nhbef72iD+LlauVR8Q5ArbQreD7QZRNoAOqDgQlQYEnHW0SQBb0StkXXx02ST+QzwnlmD6JfFGuFBFd8oJZgY0kZnGfPWnQEwY7vsJEX2uKeOvSlUn00B+wyf39s6PGSpYXkuQIbpeMWngFZN+auitaKM3rLCCYwiAW0CZjZQvYimRrIIwhq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Every so often we get a memcg performance regression caused by nothing
more than a field moving. Someone adds a field, removes one, or puts a
few behind a config option. The layout shifts, fields with different
access patterns land on the same cache line, and a bot reports a
regression.

Two examples. commit 98c9daf5ae6b ("mm: memcg: guard memcg1-specific
members of struct mem_cgroup_per_node") moved lruvec next to
lru_zone_size[] and needed commit f59adcf59332 ("mm: memcg: add
cacheline padding after lruvec in mem_cgroup_per_node") to fix it.
commit c1afbd5de131 ("mm/memcontrol: avoid false sharing between
vmstats and events") had to add ____cacheline_aligned_in_smp for the
same reason.

Each fix was correct but nothing stops the next field addition
from undoing it.

This series makes the layout a contract the compiler checks, the same
way struct net_device does it. Fields are sorted into named cache line
groups by access pattern, and memcg_struct_check() verifies at build
time that every field sits in its group. A field added in the wrong
place now breaks the build instead of quietly costing a few percent.

struct mem_cgroup gets three groups:

  memcg_write_hot     written on the charge, reclaim and socket paths
  memcg_cold          only the cgroup control paths touch these
  memcg_read_mostly   set when the memcg is created, then only read

Testing
=======

The cgroup selftests give identical results with and without the series.

For performance, two identical 30 core Xeon machines each ran both
kernels, with the boot order swapped between them so that machine and
order effects cancel. The useful tests run two workloads at once in one
cgroup, because false sharing only shows up when one side reads a field
that the other side writes.

  slab allocs + page faults, slab side           +1.2%
  page faults + memory.stat readers, fault side  +1.3%
  page faults + memory.stat readers, reader side +0.8%
  everything else                                no change

No test regressed. The gains are small but the point of the series is
the build time contract.

Shakeel Butt (6):
  memcg: move per-node objcg to the read-mostly fields
  memcg: split mem_cgroup_private_id into two fields
  memcg: group the write-hot fields of struct mem_cgroup
  memcg: group the cold fields of struct mem_cgroup
  memcg: group the read-mostly fields of struct mem_cgroup
  memcg: group the fields of struct mem_cgroup_per_node

 include/linux/memcontrol.h | 169 ++++++++++++++++++++++---------------
 mm/memcontrol.c            | 122 ++++++++++++++++++++++++--
 2 files changed, 213 insertions(+), 78 deletions(-)


base-commit: 817d340204c513316223ba084615f5906ac49ddb
-- 
2.53.0-Meta


