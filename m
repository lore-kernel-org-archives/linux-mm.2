Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B250DCD6E4A
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 11:31:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDAEA6B0005; Thu,  4 Jun 2026 07:31:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8B816B0088; Thu,  4 Jun 2026 07:31:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA18D6B008A; Thu,  4 Jun 2026 07:31:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BCD716B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 07:31:55 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 65A5B1C1411
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 11:31:55 +0000 (UTC)
X-FDA: 84842015790.10.07C3230
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf09.hostedemail.com (Postfix) with ESMTP id B06F9140018
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 11:31:50 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pZac7l76;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780572714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ymXHKKH9BjadwjKYoyvCfvApViEWTyl1BloEQRhSAKI=;
	b=oErEFuYcYweKD0M78NJ0rhnzFqI0KBYmaEZrxc0oWogKArdXJ2UPYjtauxPjqKc/ps2Pll
	3d1So8M6KM/kYPkir0aRfLP/ltZJAt2szsNwqyag2GA6sZfZyg/NOCnqJWBqe4Jr8nb2t6
	RVkUzju1hpRDM0PxFLKr8HSrT9ITBMw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pZac7l76;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780572714;
	b=ChLUThpc9CHt3zWwX4acdMMUaLsL/zAHVSm3B4U/UDd/PPi68lLn8Gy4tz6KvzB9JBhnGR
	sBGfnyqSi26YEZGMRaIy5VAfI66WCd8jIcOrq97Wk519CF6invUoySNtAdc3382hQZ6ZIa
	I/K38g2wQie6eArO8Oaf8IY2xdKhEDA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780572708;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ymXHKKH9BjadwjKYoyvCfvApViEWTyl1BloEQRhSAKI=;
	b=pZac7l76/6x1ObEjVLoTZkPIZet7Ej45PAOwBMLniasRrjGfJ/3LtNSeJ5SsAcj+ajSp16
	UkvdSSaGqhdMZEw3Zad1HzeDq/N8o5jcEBJGgc4NDg7hAoWe6FIj4Wmy71dkoJpbbnu3aR
	SBtBUfDy3jgLFcjDINN8em0put0u7TY=
From: Kaitao Cheng <kaitao.cheng@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Vlastimil Babka <vbabka@kernel.org>,
	Michal Hocko <mhocko@suse.com>
Cc: muchun.song@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	chengkaitao <chengkaitao@kylinos.cn>
Subject: [PATCH v2 0/3] mm/percpu: Fix possible NOFS/NOIO reclaim recursion
Date: Thu,  4 Jun 2026 19:30:58 +0800
Message-ID: <20260604113101.89510-1-kaitao.cheng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: kfxbnq9bt1ehsmyaj3acji59wigh53s3
X-Rspamd-Queue-Id: B06F9140018
X-HE-Tag: 1780572710-889062
X-HE-Meta: U2FsdGVkX194HQP05uOGC5PaLNk6dTaGggzAkD3QPZdrDJ12w6PiqoU3LZCbjOr1WLXB1H7kQr86K4LWh5SciR0sBiLr+dFiR7zqodHFlLL2FFcHR47V/ECnHIrnp2DjQjbYeQesp1o2HEJTKgy9E8a3r50zqZZUhyM/hHMg37hPbSk8G6SXpI8Mrk9p54RIj1Hvc29tLHVQE2K89Ak4nZoqSq6NQQwG07FBJZYP1pP1IB9S4r/+4Z6JqzGLIlFyd1lJ7MJo7i5plIcVMuSO6MwLaCL0wtf0kBXwkGk6ZEmCTI2qXPib5To7ZtREKaQDsM69r+37ZV9mnke2/pBduX0diA3Ypiff3UTCSn5XxKd2cEk0RpxnFoMhz8jX2SlWfPdCTu/tKaS7shyca5bjCIo7DovZLZNiZaF0b6fBvNNnd4nH4VEXkxtBUhu3MXKMCxAJ43WY2wyFF+qGaXQKewkcHnjDs/SRxcUIPUtROn0ssNNuuQMTzu4yzrue+IkyAia1fICIwDiEtC4NFVRfFju3q3mMBa4RftZx16PkZxCpzb1wDHy8yqeIsb8EHbLzIS+hNh6Gj4sUoH6HZ/y0SFJS2gPIzSjVOi9E4EjC/IbZNoxeQngcasNKVlhfR5qxxegASgQT+eirLeU7CmOFx++Rsa517vWouQaLSl+17tOm3/666p49IWoRov0u/KsXzH9tLNgDkYx/qn5lWu1F1vKlfiTsn1AJYx4h6Yo6B7RIl82SYfZV6ZWuaoatMgGUkdaInvuc6EpRQ40RksPMX+9vUWRrw1qbgTybtXJVV4eBk62ZvWL7Y7LJ3FJY4XpdmhWoS4N4ALteipQiCw/cvMZNgSanQxnTKsUqpK/cX4yYhMuUez/bqiVJeQ88EuvwOdG2r2sVbsJ9WO2CrexN7NzYay9Cke681WIBAORt7fhbF7qNhLr0v4D/Y+b5DPBSJlv6JThOP0TuIU9AJ4n
 RXLhYxs+
 SaDzWuV09CA/LScLU8AfmyLNzDZpgVHzzdFj6JIzfrlb0ouZefy74098arkEJsyhRYEjPF9F/JI85A+/mUxm0oOPkL34sp6tG+8upLgDknspGbCSy5ymeckt0m2xtWtJMMg4NW6SzJejqJYV9Ai1ZgZPbjl5bionk+qJxKcaDNDuBeESpXUd/7w7S6PwRkNlncym6P7bcBq8lC4ZBRTTMvb6p3vfh3+WQrrf8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: chengkaitao <chengkaitao@kylinos.cn>

Hi all,

After v1 was posted, there were many different opinions, mainly around
optimizing pcpu_alloc_mutex. This v2 is intended to describe the existing
problems more clearly and provide a conventional fix approach.

Commit 9a5b183941b5 ("mm, percpu: do not consider sleepable allocations
atomic") allowed GFP_NOFS and GFP_NOIO percpu allocations to use
pcpu_alloc_mutex and the chunk creation slow path. This restored the
allocation capability that was lost when those constrained allocations
were treated as atomic, but it also makes the percpu slow path visible
to callers from constrained reclaim contexts.

There are two related problems.

First, the create and populate slow paths do not fully preserve the
caller's allocation constraints. pcpu_alloc_noprof() derives pcpu_gfp from
the caller supplied GFP mask and passes it down to the percpu backing page
allocator. However, chunk creation calls pcpu_get_vm_areas(), and chunk
population can allocate temporary metadata or vmalloc page tables while
mapping backing pages. Those internal allocations can still use GFP_KERNEL,
so a caller using GFP_NOFS or GFP_NOIO can enter unconstrained FS or IO
reclaim while holding pcpu_alloc_mutex.

One possible case is blk-cgroup after commit 5d726c4dbeed
("blk-cgroup: fix possible deadlock while configuring policy").
blkg_conf_prep() now serializes against blkcg_deactivate_policy() with
q->blkcg_mutex, and blkg_alloc() uses GFP_NOIO because queue freeze and IO
reclaim dependencies can otherwise deadlock. If the percpu slow path loses
that GFP_NOIO context, direct reclaim or writeback can issue IO to a frozen
queue while q->blkcg_mutex is held.

Second, allowing sleepable GFP_NOFS/GFP_NOIO allocations to take
pcpu_alloc_mutex means that unconstrained backing allocations made under
the mutex can create an FS/IO reclaim dependency against a constrained
caller which already holds an FS or IO lock and then waits for
pcpu_alloc_mutex.

This series fixes those issues in three steps:

  - pass the caller supplied GFP mask into pcpu_get_vm_areas() and use it
    for vmalloc metadata and KASAN shadow allocations;
  - pass the GFP mask through the chunk population path, including the
    temporary pages array and vmalloc page table allocation scope;
  - restrict percpu backing allocations performed while holding
    pcpu_alloc_mutex to GFP_NOIO, so they cannot recurse into IO or FS
    reclaim.

This keeps sleepable GFP_NOFS/GFP_NOIO percpu allocations working, while
avoiding the reclaim recursion risks introduced by making those allocations
eligible for the mutex-protected slow path.

Changes in v2:
  - split the previous first patch into vmalloc-area creation and chunk
    population changes; (Pedro Falcato)
  - pass the GFP mask explicitly to pcpu_get_vm_areas(); (Pedro Falcato)
  - apply the corresponding memalloc scope around vmalloc page table
    allocation during chunk population;
  - replace the reclaim recursion avoidance with a GFP_NOIO backing
    allocation mask instead of only rejecting nested reclaim.
    (Michal Hocko)

Link to v1:
https://lore.kernel.org/all/20260528132917.81123-1-kaitao.cheng@linux.dev/

Kaitao Cheng (3):
  mm/vmalloc: honor GFP constraints in pcpu_get_vm_areas()
  mm/percpu: honor GFP constraints when populating chunks
  mm/percpu: Avoid IO/FS reclaim in backing allocations

 include/linux/vmalloc.h |  4 ++--
 mm/percpu-vm.c          | 40 +++++++++++++++++++++++++++-------------
 mm/percpu.c             | 17 +++++++++++------
 mm/vmalloc.c            | 23 ++++++++++++-----------
 4 files changed, 52 insertions(+), 32 deletions(-)

-- 
2.43.0


