Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A586E606A31E
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 22:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=INqyGfNb
Received: by kanga.kvack.org (Postfix)
	id BF1616B09FD; Thu, 22 Oct 2026 18:39:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC8FE6B09FE; Thu, 22 Oct 2026 18:39:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB9186B09FF; Thu, 22 Oct 2026 18:39:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 766796B09FD
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 18:39:58 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B58F61A031C
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:39:57 +0000 (UTC)
X-FDA: 85351731234.21.23B955D
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	by imf29.hostedemail.com (Postfix) with ESMTP id E6B7D120008
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:39:55 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=INqyGfNb;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.171 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792708795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vrt05BYvp4Ozl6KKfhC1LOwi1Z6E7PnJMIwc9/gE0cY=;
	b=QKVdNZG+E48RGFuGkCs2pfcKQVj0CzjG+OiUrzbkRXtkrcOhI2JsUo9lMGAYLWnN55YSvA
	g4BSiXgWoapYnyOgF8kE+P7tFCks6tDpYdQMR/kw2oGHzXbnZEWnJkkft9Wg6Jkv3GwBNF
	rLj3uyE+8NpJAhTHZYqvjwOpW2CNkH0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=INqyGfNb;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.171 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792708795;
	b=h56GLrPMwef9ggCES0FkuTZWFmLRb/hDmtmmhMPQdbvo9Q7MrJKV4/7mI4+YCoGhCE49jj
	pNvfuWdme7Dsd9mH6Nmm7fBfgCU63MiYFdKyHwFaiwERYqSJrw5MQ7MBbfQ4jsn01VE0bJ
	0TfEmgTRGg+PGVP10AhyIdaUKA1oCxg=
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-8ab37e44643so2632917b3.0
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 15:39:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792708795; x=1793313595; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vrt05BYvp4Ozl6KKfhC1LOwi1Z6E7PnJMIwc9/gE0cY=;
        b=INqyGfNb1wbTJ5gUJ19kroFZ8V70vtXWvm5rYe13w8ZM44jNE7rfZumsvuNX+bBf2S
         Z6jrjhh/tJlhp0VcJgKWcKg90xuXyNf8HYJDujFKEQKSQvVdE8685hBzkpuxP/PnMhx5
         gYYKmQMJGh7r46HQeD5NrUSdcz2wEFw123w7u3cDainne0JwRYjGhylYtqRG4gWSXmmJ
         9lC6yJSerEH0VmGiwKagFw5AOriOSuJuJmTvmj8CWh5KaSVWNMFmUE3fVtaJ+Pa44vmE
         5pK6qGpzwz2Y63F+JUqIrioPy+EBHezW0ID3RCtAwFB1eGR7pCHQttB7e1GV1YGa/mmo
         zQkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792708795; x=1793313595;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=vrt05BYvp4Ozl6KKfhC1LOwi1Z6E7PnJMIwc9/gE0cY=;
        b=Up7+P+vtrZ99K5DN0A4oMnmQzvt8D8eMopvhorrcfoPDjsDakEd4KJd63mCJSP7KaR
         MOL92QQsGOrYFmcFO7WHQ/ev99trp4zqsJRcBDl8cOROUMW93nujFocHcqiJrWTE4tVI
         /iBP09eHpy2A6EwQyEJoarao2nKIGR3EVV3blu3qr8/yBb4cg5seKrbQ5Al/45cK/uXL
         4tIBMDyxiIcRD+ILqtxOqVLq4dF8YyupiX3cpGO6CBhrIYPjLVQt/GwhJ519BB+vyGlh
         wXKuEVZEXeVGsrXfq2ghgINI5FuoKnc6E+PCFrt/tVKpv3sDED3PXTYa/RhgJ70uozPt
         S8yQ==
X-Forwarded-Encrypted: i=1; AKwUvBzjJmjMKTvFUVtDS6DKl27yR4Qk1cgCDxyG8Eg0w2M8qH6g6URr6KJ83FDCNfbiQEK3pnCt8qqLUw==@kvack.org
X-Gm-Message-State: AFq9FYLy+0SOV7YyDbTcEbOQQdPixGGyQ6tC172QvUx+OAgi9n6PUuJe
	TAzL2ALFKGIn9gpDYHNDYrTVJCQhY6mabx8H9/ztVe+XUKMa1hbwf7UL
X-Gm-Gg: AYBFou3jhikzsjA/k+kjqkbQ1smmVXHHRP2cHTtig5c5PB54YVFZfs0nekS/EgNI2fw
	2X3mczDCTW7N0q2Se6uca2bmxi0Y9pHsM980+NJI+ZuwqK37HxustefqVF5uumZdVmvqBjNuOm8
	XDGaBEVvawSua9x6hgZbWmLlKWnUOQBTOvSc7MsIn0epb05ZeIjJe9QH6JTppjSP2pbikAaXTRL
	qyfE8lKzGSS9fk64N72mB31vdSs5HoU9aMA5IzqsULQhJSbg8pwDars6sjq5WnAI82zx82LiIZQ
	fiOLXE76+IUL6ACvAvL6lFwSDy/kg1NLOIIBh+J7ozrPnPdMkjnhJ+AJoLxLU+5RQ1pRuEYIgLO
	Y3yz98Y0UjOO4I7R9zweQMigV7xx6NT7X23LbfMBZ5Cbqz+dcNwHRlgwRh2wDkm0fYsbXogxGTV
	3o4YI556D1xwgzugZvMK6/ipDAKvUiB9EWdzwwr0h+LIkLyWRkZu5LSz2WadWxEzG1nkdbA5c6q
	6XUyScnTBRr5vTzHobxH7llkgbEvI6J3FuRydfgvcsElpjXK01eO9GLeW2jCag8vf3HunIeE+3j
	5y1aBODiXTb9wCNbNFA4bMF/s87ZweWf
X-Received: by 2002:a05:690c:386:b0:8b0:d554:a7c with SMTP id 00721157ae682-8b157db8fa9mr3158447b3.79.1792708795054;
        Thu, 22 Oct 2026 15:39:55 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:51::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b1561c5e46sm5013287b3.43.2026.10.22.15.39.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 15:39:54 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 1/2] memcg: reduce cacheline contention between lruvec stat updates and LRU lists
Date: Thu, 22 Oct 2026 15:39:29 -0700
Message-ID: <20261022223930.138779-2-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261022223930.138779-1-joannelkoong@gmail.com>
References: <20261022223930.138779-1-joannelkoong@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E6B7D120008
X-Stat-Signature: zdw4uy7ghn5nrjrzy8byozm6wymeyxrz
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792708795-185443
X-HE-Meta: U2FsdGVkX182f4wYFEz78dk8qvy31HhSwZ1jMJ+1QLY7cgn+auRNXH2uaIFhy1EE0RrB2rrOeSNu9RCXRkiV8tgaRNedz1ZW6OrMDMwZHDtSwOgEhZ310UyfnzgmrvSSfj/BhOmgiOa7PMRVqv/VgDwgZCYvON6fveoUh4yi7t02sFCc6ZgN0ozn7pnfBZ4gUslE1kaeI/PRP8rFLfsvc96cThGoRV4YU6vtpb5LAEnYrq6R/NDsJXWRpE2WGqtJrq1IY1prdcjHdVIHNBhk6NM77AT2HycvcEZjk0RtLoCpufsfU3GedlirjChLSzxmCShjz9Hn+BLx4Wffx8ud8Zt0JPA99pai1xt64hIR4rVzgy1g7mVed1MJ2TZYkVvKh2Kj1ZdUq2pNc2mnCeglA17GGpzH9hc8fAFgiEkQXkXNr5J/lwkuVEksIw3xy+1EXsrSuLXe720YOqc5Hr3Q+GZGuISJ2v1aDtdc9VIw3HyZ6x3DagtITuNjlqEbxRVgmLo3apbRu2bhsMfs/LkjjMC8mXZjun4vCFOMKndBdd+ZR2RL7U2nczcW0xKwVvOiNgqwOky58qkHNYEOwGM2rQ1ixfRVouPL5ELmbXTqOXwF0bQ8D13tj0n+3hpqRE3vKV9MrzFT7H88yVNPd6zd7cu3p5bMUZzZnljFCzei1Ts/U350348SR2iDbVTdxAXHinsGCEhWYICA8DOMC0bkmgHtpkhWlIfdj00l6ZfrYUyciXi6L7JlmLc+f9ytdNzpuQ/tiBiFRk3qBAMUVq4m2zI3/+gBLrkVpiehjcAEzIJzOLQ27GNIMKJRVnn8FRTyVBN0WUrKfXxpqKPQIBZnzSs/XMTuuBPFPtIyNvFMB69hQew2/z4Ee7F9SH+VY+VnqOyYKJRNVigujK9828y+Jm1PLN8+Ioh6Z2abiYCq4tHmbDgAOnYD/Yus+95lLqMwnMNoCd5XZaqjuem15Iq
 gyWQEaE7
 v0FAXCGyVOXu2ExUFRC0QsZUYwEOVAXza4JgSiRsX94NbehsPtIfxR77ZDyZ5gaqRNwJGgRr7S6Mu9X6NOAX2ekTofC8+FCeovpdpx8dec+V7GhzxLKNQt3oOfF/tzP95uR0PTBACpD9+Hva2yFR36Gi9Ap9sQCo344+vUcLzi/2cR3Ya6P/ueBcNnG+gpaZKceSOlaGHjKQJuFFzjnttzx0TSziXyvcWDBMsK6AgbLTnt+rXhwR+IYW11IKhq8aszuGvkXxUG7Kvhho0x8WPIEVJ5L7t/IIFxIqcL+DVaEMmOQczaPpoLitfgzoot5Q+Xny2Z/iLrtR9q7L8MVPHId+3Lt22q9MF99fRPT8R3h0scgYy9PU7roHMkAwQUqxrGp7zKdlpgZ2Msw32GBRw5J2B5Q96KKlcITWjKGvuNUGjq7d0+ASxvRcNVaud7+0Ha1ixXlLyyvpIJCpj/BV2FECLg334kgUpdGxu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Every memcg lruvec (per-node) stat update reads the memcg and
lruvec_stats_percpu pointers in the first 64 bytes of struct
mem_cgroup_per_node. These updates are extremely frequent (eg these
updates happen several times for every page that's faulted in, freed,
dirtied, or written back).

The memcg_pn_read_mostly cacheline group keeps those read-mostly fields
on a different cacheline from the lruvec, but Intel CPUs do spatial
prefetching [1] and fetch cachelines in 128-byte aligned pairs.
Depending on where struct mem_cgroup_per_node lands in its slab, that
cacheline can be paired with the cacheline holding the LRU list heads.

When this happens, every stat update also pulls in a copy of the LRU
list heads cacheline, which is written to constantly by other CPUs under
the lru_lock. The stat update has to fetch it from another CPU, which is
unnecessary overhead since the stat update doesn't use the LRU list
heads at all. But even worse, the lru_lock holder then has to invalidate
those copies and wait for the acknowledgements to come back before it
can do its next write, which makes the lru_lock critical section longer
for everyone waiting on the lock.

This was found when analyzing the output of perf c2c for a benchmark
where many threads fault in pages in one memcg. It showed the first 64
bytes of mem_cgroup_per_node as the most contended cacheline (over a
third of all HITMs and 5x more than the lru_lock cacheline) even though
there are no writes to it. A quick experiment adding extra padding so
that the cacheline no longer shared a pairing with the LRU list heads
showed that this removed most of the contention, which confirmed the
cause.

Fix this by moving the memcg_pn_cold group, which is only touched when
the memcg is reparented or freed, right after memcg_pn_read_mostly, so
that the read-mostly cacheline is paired with the cold cacheline
instead of the LRU list heads.

Results from a multi-threaded fault/free benchmark in a single memcg,
run on an Intel Skylake machine (80 threads, 2 NUMA nodes) with threads
pinned to CPUs showed average pages faulted in (and freed) per second
across all threads, over 7 freshly created memcgs per run:

                     before    after
  shmem, 20 threads  4.74M     5.59M   (+18%)
  shmem, 80 threads  7.94M     8.66M   (+9%)
  anon,  20 threads  3.04M     3.08M   (+1%)

[1] https://www.intel.com/content/dam/doc/manual/64-ia-32-architectures-optimization-manual.pdf
(bottom of page 62/800)

Link: https://lore.kernel.org/linux-fsdevel/CAJnrk1ZezmmzrYdf8KP6re_a76izMS=qGPeC8ZZXiteHyZZC-Q@mail.gmail.com/
Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 include/linux/memcontrol.h | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 69e1bcc67c58..69ed283f7db9 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -95,6 +95,17 @@ struct mem_cgroup_per_node {
 
 	__cacheline_group_end_aligned(memcg_pn_read_mostly);
 
+	/* Touched only when the memcg is reparented or freed. */
+	__cacheline_group_begin_aligned(memcg_pn_cold);
+	/*
+	 * orig_objcg preserves a pointer (and a reference) to the original
+	 * objcg until the end of life of memcg.
+	 */
+	struct obj_cgroup	*orig_objcg;
+	/* list of inherited objcgs, protected by objcg_lock */
+	struct list_head objcg_list;
+	__cacheline_group_end_aligned(memcg_pn_cold);
+
 	/*
 	 * Keep lruvec on its own lines. Sharing them with lru_zone_size[]
 	 * regressed, see commit f59adcf59332 ("mm: memcg: add cacheline
@@ -114,17 +125,6 @@ struct mem_cgroup_per_node {
 	atomic_t		slab_unreclaimable;
 #endif
 	__cacheline_group_end_aligned(memcg_pn_write_hot);
-
-	/* Touched only when the memcg is reparented or freed. */
-	__cacheline_group_begin_aligned(memcg_pn_cold);
-	/*
-	 * orig_objcg preserves a pointer (and a reference) to the original
-	 * objcg until the end of life of memcg.
-	 */
-	struct obj_cgroup	*orig_objcg;
-	/* list of inherited objcgs, protected by objcg_lock */
-	struct list_head objcg_list;
-	__cacheline_group_end_aligned(memcg_pn_cold);
 };
 
 struct mem_cgroup_threshold {
-- 
2.52.0


