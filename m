Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8ED7E8538E
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 19:45:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE0D66B0098; Fri,  3 Apr 2026 15:45:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E914A6B0099; Fri,  3 Apr 2026 15:45:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D58466B009B; Fri,  3 Apr 2026 15:45:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C20786B0098
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 15:45:40 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6213E1A02C1
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 19:45:40 +0000 (UTC)
X-FDA: 84618274440.18.7CC1C99
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6CECE40006
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 19:45:38 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=FqSQOXC+;
	spf=pass (imf17.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.179 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=FqSQOXC+;
	spf=pass (imf17.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.179 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775245538; a=rsa-sha256;
	cv=none;
	b=miX+9Pca5lAmHNPAtsgOmfTFn1tmgL/yR4gappqg9bfDOCgHde64+euIb8SeBR89jqjulH
	3XSPdeRyYEp13QM9MN6/O4CTzFfjjJRjQUEePwE+fRwfV1DkXdy4cCev6zOd9ymOA4+n25
	TpuXLNrF1H7diSgiUxNykSyEQKl0SuM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775245538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=MkCnZMc51A5ktMZ7NvfpuZ1Tvt5XekG9z+r9y+GS9pg=;
	b=MCjKZMMuAOoYPdAaUuhka/rckoX7q27BS3JOaE0u8xAbEIFEpRJfGXxvZzmXBPh/Lsm9J2
	zBg5Epz4+jyxW/5Yzpq2ltBPBpQxwBOugppVcjk5Jd32dM93+oIL1GLrxy5jwHJ8iGu/Yo
	qH1BgvYUJES6Q/TXypd4HtJhxXJaavI=
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-50b2b289925so20029141cf.2
        for <linux-mm@kvack.org>; Fri, 03 Apr 2026 12:45:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1775245536; x=1775850336; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MkCnZMc51A5ktMZ7NvfpuZ1Tvt5XekG9z+r9y+GS9pg=;
        b=FqSQOXC+/LFywVau0/He2XC7niJWiSUGakNpz5UO0ZZaLB0G2SsdG9uQysPDJpsEwd
         vkQrjkERE+SIlqDL3vubxBPtD/Xkf7/H18UOINdNKyJBiahyBX9ISSXbwkYtw4Eig6Uu
         JC8X8qAnwsEQxzhabOedFe5TrRzY8gu4cmBNJgePv6QMewAbCjRpO2whJeukC0h0S6Jx
         zfF7lW5rRdqVqd2G46ZkMlMyh2U7kuLEi9izmu4Ix6/mXFK+OfYzihJefc+ASW1eSmUb
         OC7eMoeAtlZym6ZyiufOasX8PezVfpQaS3iWbcI9E5mv4iYk9NO7Dzw5YSW6jdnyJcc0
         Np1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775245536; x=1775850336;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MkCnZMc51A5ktMZ7NvfpuZ1Tvt5XekG9z+r9y+GS9pg=;
        b=WsGlxCpWUcJ6Jg4bVZ65CjqAzvwgaTs48OaXpJw9WDMiCRht27NLM1Uyh9pNpjK0b2
         1TCkfci/ODJbf4KX48EB5LLuH5LZVeUuMR76aKzCJrGTBOcqjrkghVjWo89DBGE78jLM
         MR6J+r5PRbC6dbVLfab2e+/fhGg+N966FdSAZYu8sqSYiQCjc15vAAsxpvzzCnUIuTlq
         cNgbaQ71E+KeAjIsizrWZkfa1rcYg6h3E33XUWdPMb+Oqny2FAACPuHYP3PpDNQGVLJQ
         nwsBdQ5jGuyzGWrMI76gbtkpb2n3V4YInvKnXKsBV6CC1blwNzM6Vy0dmka35Aw9ha5B
         reVQ==
X-Gm-Message-State: AOJu0Yy0aHOMdAyMiD9/IyiKIEp1M8g8+mVP8IVdnDUTAZNyCktJyZOm
	S6ySV5RHQ05pwNa7WgGxsTlhWtQd0gfHUdKK2GT+1bxQzoEPX2qKUJEuhff6pGc6Xna/BYex5KV
	HjbOx
X-Gm-Gg: ATEYQzzEW8ilU62LACXOKD/ldaslZ5wugQooVLXjJMSXxa+GtoVbxbxujYz+SyFCU1c
	p+s3w7+7O7GKVchG+TggzCXKFnGnUgCBZggqxVvQHokBrRI/mSpLo7RItowE5zsVG0KtewaEIAu
	2iukZLicmUkT94MOqi+KF7Ziup6hivMzs4g9c59atNLuRgKrEW1or5Z5qYOPtf4whhdPC+HK7Q8
	5XJU5/sslabSx4NO8a5+IngpkN3kdo3zx+FqbD3XPgrukNrkouxFQt18Xg6sUbQ4IT3Ffz/6+fR
	cR0wJH77LjFu1NDn6cJApXzrGCi/bE6GP3aNUiazd6cEGE/hDEEyDWXZcE9KW5We/3gVzFOpjl8
	vTjrWyDLn/xdJtVsZccKdmmC9m/mCOz5MYzrTOGuyBHuiYScKGTq+UIbl5Ged9/lKO+b+iLnLrr
	bOxkWqgGeA4mVkU7YSD9QRlxQPLBmj60zo
X-Received: by 2002:ac8:6e8b:0:b0:50b:8689:bd4f with SMTP id d75a77b69052e-50d62b0bf34mr47427901cf.55.1775245536394;
        Fri, 03 Apr 2026 12:45:36 -0700 (PDT)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8a5976e223dsm65418606d6.45.2026.04.03.12.45.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2026 12:45:35 -0700 (PDT)
From: Johannes Weiner <hannes@cmpxchg.org>
To: linux-mm@kvack.org
Cc: Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Rik van Riel <riel@surriel.com>,
	linux-kernel@vger.kernel.org
Subject: [RFC 0/2] mm: page_alloc: pcp buddy allocator
Date: Fri,  3 Apr 2026 15:40:33 -0400
Message-ID: <20260403194526.477775-1-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6CECE40006
X-Stat-Signature: fxa8tpxxoh7btggycctts56t5jcq5wf4
X-Rspam-User: 
X-HE-Tag: 1775245538-829577
X-HE-Meta: U2FsdGVkX1/AuEdZ5BVI5gAc6jF0KDtRV+uCpwEdxnKb0Bu3C0yqRQnznO9F9p9pvrLmVaQvECkDQRfCB9R2CqOEm/1597sszbI+hSGgUpaauM32Cj70VbkYw0vR7Qg8LG7lHAuMXmi1hfBBv/cr3FBQO2wa2ON4xNW9uRwfHI4Jdat09FwZ2bbPtccqc5edYzY3KgsvAczkzTiqtQj9lppmGAJ6qghHZzZOMLWCsxplphaJaZKV/XISpYk1xJ16tGhqrlWy8cXTBEdG68E8xOUUACHyrXOMjUyV62nP4qqfJRP6sUvPF8g8ZfHONejUsFRjY0pisjwoVIiOvHbIIbbStggKOiH4/O0WgP1NP1zqUwMTQ25MRQSgH+0KHHm4QcXvRonKor2Oed26/yUVtmm6RgjP22iS5BAOEujsbPZl6zOq2aG098oxU/P89vMh8+VNafK6YwbPz/DrZo1+h0/LztyiivNaqOJghxRNQnt8GTo/3FZeH34pOa0G2Wi+kMhJg6dZof8++V8BT1QJNzwJs5kX5sY18gtHKzzTuNGyuZMwc6sipXxpL5w4Ebbuq1wbgCHkavr+AdeUUucDGJgC400oH9AkLqL85OadUpbBVte5xc5Qnrf0dOFsiTlCA8V5dZjsz/5LKA2uTYtHBESuzDjYyZTI0+TF/TSM1+6mAd4ayciWJyc0XEA0jEYi5PNWRgqXHpjC2tXsaku6EhmVmYHnU5Fh2rMzkQ8Zh3t830dkdeUq4ny52HtUMWKLubzp7w4C32VRN1EYAFZ53Lkhag+T4ZcfhwFdDboMQ47X2LD0Jmahyt2hN3xcIZu1TXcZZWzw3ltSJxQXuE6MMv48mJALh7xgW4wWXRQNlHRpajI0ysxfNL18zt+Wmb7GL4tUcG1taBCk5dWZlJSV3P4fa4DMO5+nsoDFmtcJSm31ZrmqlE5g8ogqtaoxcnQlFH/aQM60hCudXQHTFky
 WllchcFK
 4jqO21ilD4Wykidmwh+X3sq4JrUzBkoZNCiLUGPQF+hxCkc9u25oLFsv9jnNxCnckbm0qtTdXDP67NYRCR/bJ5kTP7T0z2WzxQciyuY4yk6yCkNaeieGeMnI9v0Rumoj+IoFw69zOc+6fVRuxhdPOI6NjUp3ytpMKBVIK44VtHycEb0J8okgQmSX3fwk+vEHek7mpfpJGMvbHzQDYoI5NI/WWJEs3/tYQ4vbKWmVBhdjnbYy4DEpJsz+TdA1kM83jDdMFt448zSC441WG9YHIz4ogQ0/httZk4GZNZEyUQXmT4XCQfVOA5I2TJHUqDVaf1A725/2wJ7pHkpIWCsKQaUGHxB086ZpKXLTagDKOUof7ci9lzYb9C/OJdDYAdWLGSpWfrobqbFhiE24DEldBoBKalw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

this is an RFC for making the page allocator scale better with higher
thread counts and larger memory quantities.

In Meta production, we're seeing increasing zone->lock contention that
was traced back to a few different paths. A prominent one is the
userspace allocator, jemalloc. Allocations happen from page faults on
all CPUs running the workload. Frees are cached for reuse, but the
caches are periodically purged back to the kernel from a handful of
purger threads. This breaks affinity between allocations and frees:
Both sides use their own PCPs - one side depletes them, the other one
overfills them. Both sides routinely hit the zone->locked slowpath.

My understanding is that tcmalloc has a similar architecture.

Another contributor to contention is process exits, where large
numbers of pages are freed at once. The current PCP can only reduce
lock time when pages are reused. Reuse is unlikely because it's an
avalanche of free pages on a CPU busy walking page tables. Every time
the PCP overflows, the drain acquires the zone->lock and frees pages
one by one, trying to merge buddies together.

The idea proposed here is this: instead of single pages, make the PCP
grab entire pageblocks, split them outside the zone->lock. That CPU
then takes ownership of the block, and all frees route back to that
PCP instead of the freeing CPU's local one.

This has several benefits:

1. It's right away coarser/fewer allocations transactions under the
   zone->lock.

1a. Even if no full free blocks are available (memory pressure or
    small zone), with splitting available at the PCP level means the
    PCP can still grab chunks larger than the requested order from the
    zone->lock freelists, and dole them out on its own time.

2. The pages free back to where the allocations happen, increasing the
   odds of reuse and reducing the chances of zone->lock slowpaths.

3. The page buddies come back into one place, allowing upfront merging
   under the local pcp->lock. This makes coarser/fewer freeing
   transactions under the zone->lock.

The big concern is fragmentation. Movable allocations tend to be a mix
of short-lived anon and long-lived file cache pages. By the time the
PCP needs to drain due to thresholds or pressure, the blocks might not
be fully re-assembled yet. To prevent gobbling up and fragmenting ever
more blocks, partial blocks are remembered on drain and their pages
queued last on the zone freelist. When a PCP refills, it first tries
to recover any such fragment blocks.

On small or pressured machines, the PCP degrades to its previous
behavior. If a whole block doesn't fit the pcp->high limit, or a whole
block isn't available, the refill grabs smaller chunks that aren't
marked for ownership. The free side will use the local PCP as before.

I still need to run broader benchmarks, but I've been consistently
seeing a 3-4% reduction in %sys time for simple kernel builds on my
32-way, 32G RAM test machine.

A synthetic test on the same machine that allocates on many CPUs and
frees on just a few sees a consistent 1% increase in throughput.

I would expect those numbers to increase with higher concurrency and
larger memory volumes, but verifying that is TBD.

Sending an RFC to get an early gauge on direction.

Based on 0257f64bdac7fdca30fa3cae0df8b9ecbec7733a.

 include/linux/mmzone.h     |  38 ++-
 include/linux/page-flags.h |   9 +
 mm/debug.c                 |   1 +
 mm/internal.h              |  17 +
 mm/mm_init.c               |  25 +-
 mm/page_alloc.c            | 784 +++++++++++++++++++++++++++++++------------
 mm/sparse.c                |   3 +-
 7 files changed, 622 insertions(+), 255 deletions(-)


