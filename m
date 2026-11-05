Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2C27606A31B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 13:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=jzmklxEG
Received: by kanga.kvack.org (Postfix)
	id 0BEAB6B05B0; Thu,  5 Nov 2026 08:22:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06FD56B05B1; Thu,  5 Nov 2026 08:22:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC7836B05B4; Thu,  5 Nov 2026 08:22:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C46BC6B05B0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 08:22:42 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9C9B8C0A0D
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:22:41 +0000 (UTC)
X-FDA: 85401130122.23.807AF4A
Received: from mta1.migadu.com (out-226.mta1.migadu.com [95.215.58.226])
	by imf21.hostedemail.com (Postfix) with ESMTP id 46E791C0006
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:22:39 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jzmklxEG;
	spf=pass (imf21.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.226 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793884959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=2FQgCJLfUQ1tOKwvKQRjuEs7njOihBYDB9ax1aCR+eo=;
	b=E8auXZk7rNT99nDX+QdDxeMvvamdiPyVXqGW71676/gV2h9CkZFpKUCAiIbHuh+vx1sdiH
	TvG5ZHXmnIcYWgBfX1xzav+OKqxIuc6beStjvm+kerL0PnsEGofUrTjjmUufNu9GpFwtr2
	jrkkb6po1xw9NEkbL8xu+a+Pwy1LH3w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793884959;
	b=oWsV6lZR9C6iA+P8GeKvuMjz+I86K76pJwRxKEtpFQU+g5iqmki+j+856wwTLIjNz9YZxR
	t/Z5/pa7DTa1oSIZmuHd0LvUC1RXHQCJi1cH/LTzO74HnY83Ed2xeq2rv3CN/EXdU/hPft
	gJUKKWVZO6EC8awO0ni8/VemD/Ixi3g=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jzmklxEG;
	spf=pass (imf21.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.226 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=B5OzRACtslAN5zq5uXzJL2D9qtFaozSUjc8us2dI7zo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793884957; v=1; x=1794489757;
 b=jzmklxEGjSMG4vpqZMVfEd/keqZO6+mmvLCky2fgy4WPykWnI+5iFyjiBiPgr7el8wg/6wpC
 WkQQIhPQ0vcKkBZUj6wQthz07FjbtwOwPqYwdp1YJ8Km3bNcl0hKUUmX+lrHR92QfiYlYaausih
 DAJ04Kldd6FNUXy4ZhYuORGM=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id e01c588a92d09643;
	Thu, 05 Nov 2026 13:22:36 +0000
X-Mizu-Trace-ID: e01c588a92d09643
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [RFC PATCH 0/3] mm/mglru: cacheline follow-ups on the reclaim hot paths
Date: Thu,  5 Nov 2026 21:22:17 +0800
Message-Id: <20261105132220.2233677-1-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: o8dok5kiafmpmsm3e1bym9g95ksjsmtf
X-Rspamd-Queue-Id: 46E791C0006
X-Rspam-User: 
X-HE-Tag: 1793884959-535917
X-HE-Meta: U2FsdGVkX1+vU1UmybLDpmo5Ki2QGcmTS/V183bqyDtO0sfi3nKrHtm3rUhCOKmJKY1BauE78m6uyWQNuA5dOo6LzY7lwjJTlVfa3KJSW9ixCM2pWmmLPWGzktjXlBHTQcEGDeJ8Pe8Q48KnjSbmzke+zawR5LzAq2liRHgZNQLbFMSbXnsVrZg9IPrFfV6wg4vdPlKE8krGF1Nf9VFrX0qHD5nrIi0Ifv7svFaOYr/WHUskKuDy0KTDUseH14W7B5/Nbt/YlSKrfupNoZ7e9+udyDQGQltPohSYzIYdxxOYjJTODb1XGWbLL7TDR2vMj6eGLoELTjpfpnxLGlt0JrhtbfCzQ1tSvIF9CQzz23uYX0/f9QraEEmmj6njF8aZIdW/MxUnSb8ddEHARj5v3sGa15tj2OtW9bmNZ4SUcVHfbPW+eCsda+LBQNH/7C+lwlrfj/f7sySuCZCIEB40qb5DucIin4El8E6nMyzVtCONUCTd8h0LxC5HA3N/LVvI7CSYQvGz3PFGjof1FGH0NzDEfGqjyalS8almrRq7zhVtsPskvYp4B3Gf6EIb5UdI7ynEihRdkt1KlKZ9nAmcthrq4AyZXyk43WYIozzNZZ3AAtXHGdMrOmWsfYzw/68ZXiLu3N9+ARm9Luz81rCAOISMCX3niQJoLffgFnGSutM3+hx/VKmlK8i+Qk+AxTUVbQcuRL89HTt2nsj1fGroBVKF5bdAmai/2q4YQ2fwRPFfW517+AZUpCR4X5qLKTdpzHjLa/ap84Xma7oMhWzNT4Bzs5kGC8UZn1Z9OKhvBEo3paJVGXsF29uSJSL3Q0r+m1H8vywKdCMeQuddFsfwHmAKym5WGHu1JvyN1cCvGbFmupiMOzlz5GQ3AWoRgaeoNZM8F88i0pdr3kyfBPBlhVtvCoOQcZtGF7pXnTunktBkegbVarpnnew3rycQsxrdHu9ad03OXj2Dsn7XD75
 hD5qHkqi
 ePeVoNDkmMWDrfUUZPsyEmVE3heyV2xjb/nbjzS8B66bwEjMKV22tAKqFNw1Bd2koMapaSp4c4BZplfJHfNuLln4YEAa6muHVTPQ/z+cutqHh3Uyq6mEE4D0c+y22M2ogzcAJeDzvQbi62A7TYyaQOrNng374J5thWJYao8AKEAypL+0Nj7/VGmb6JeZJgAYo5pF92MogsG2Ju4wQg4IIkvNTP8/iBunIkev7Dk4RX5QpxrvKA2qRsnC7dndNAtijXYTtFgiTaZ5p/0ZW/4G4UObXURI98KuNBNDHpmLVX+VIH8E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ridong Chen <chenridong@xiaomi.com>

Joanne's series to reduce cacheline contention around struct
mem_cgroup_per_node [1], now in linux-next, made me look at the MGLRU
side of the same structures, and at the stores MGLRU does on hot paths,
to see whether any of them write a line for no reason. This RFC has the
three candidates that showed a measurable difference. They are
independent of each other.

1. lru_gen_use_mm() writes mm->lru_gen.bitmap on every context switch
   to a user task, although the bitmap is almost always already set.
   For threads of one process spread over several CPUs, the line
   bounces between them. Read first and skip the store: +2-3% context
   switches per CPU for a shared mm, no change for private mms.

2. folio_update_gen() and folio_set_lru_refs() always end with a lock
   cmpxchg, even when the flags do not change. During aging, a folio
   mapped by N processes is visited N times and only the first visit
   changes anything. Skip the no-op cmpxchg: an aging pass over a 2GiB
   file shared by 8-64 processes gets 18-22% faster.

3. lrugen->evicted[] and ->refaulted[] are updated locklessly on
   every eviction and refault, and the file type counters share a line
   with lrugen->enabled/gen/seg/list, which are read on every LRU add
   and by shrink_many(). Move the read-mostly fields up and give the
   counters their own lines: +4.3% fio IOPS with 24 jobs refaulting
   file pages in one memcg, no change at 8 jobs or fewer. This one
   costs a cacheline per memcg per node, and its gain needs many CPUs
   refaulting from a fast backing store, so I am not sure it is worth
   it on its own; feedback welcome.

All numbers are from an i7-13700HX (8P+8E, 24 threads, one socket) with
turbo disabled and the performance governor, on next-20261023 with the
same config for base and patched kernels. Details are in each patch.
The series is rebased onto next-20261104, which includes [1], without
code changes; the struct sizes in patch 3 are updated for it.

Limitations of the testing, where input would be welcome:

- Patch 1 does not show up in will-it-scale context_switch1 or
  sched_yield (explained in the patch), and perf bench sched messaging
  and schbench are too noisy here to resolve 2-3%. The numbers come
  from a small test that pins two sched_yield()ing threads per CPU,
  with a one-process-per-CPU control.

- Patch 2 has no standard benchmark either. In fio with many mmap()
  readers under memcg pressure, reclaim time goes to rmap walks on the
  eviction side and aging barely runs. The numbers come from triggering
  aging through debugfs with force_scan, which is the upper bound. On
  real systems the gain scales with how many processes in the same
  memcg share the hot file pages, e.g. preforked servers or Android
  without per-app memcgs.

- Patch 3 depends on the layout of the containing structs, which
  depends on the config (LRU_GEN_STATS changes the array sizes). I
  checked LRU_GEN_STATS=n only.

The test programs are small C files; I can post them if that helps.

[1] https://lore.kernel.org/20261023195417.1391216-1-joannelkoong@gmail.com


Ridong Chen (3):
  mm/mglru: skip redundant bitmap store in lru_gen_use_mm()
  mm/mglru: skip the flags cmpxchg when nothing changes
  mm/mglru: move lrugen atomic stats off the read-mostly lines

 include/linux/mm_inline.h |  2 ++
 include/linux/mm_types.h  |  3 ++-
 include/linux/mmzone.h    | 18 ++++++++++--------
 mm/vmscan.c               |  2 ++
 4 files changed, 16 insertions(+), 9 deletions(-)


base-commit: 8b7179210b22f8e48a82c5ceacb9d56a9c4cfec4
-- 
2.34.1


