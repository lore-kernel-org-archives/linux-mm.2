Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80415606A338
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 08:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=SfQpNE2V
Received: by kanga.kvack.org (Postfix)
	id 95B5A6B05BD; Thu, 12 Nov 2026 03:19:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E5396B05BE; Thu, 12 Nov 2026 03:19:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7ACE06B05BF; Thu, 12 Nov 2026 03:19:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 594D56B05BD
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 03:19:53 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B4798120513
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:19:52 +0000 (UTC)
X-FDA: 85425768624.18.72CB679
Received: from mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf21.hostedemail.com (Postfix) with ESMTP id B5AF91C0007
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:19:50 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SfQpNE2V;
	spf=pass (imf21.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794471591;
	b=5FYgApDjh7pdfmkDtLZLHHPcQBOv6wgY9VLjiFXuzeGKdJiPQK2nZIeCGMQYQle9N9LhMi
	jSlvfmcnHad4eERDrJfzsVfTnvVISC60tE/Wxx40TucTHeAdENZFI71aGNNt+RACX3KYwK
	3Qdt+bWUl/GotXqiwuLyDQPQiJk8vjI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SfQpNE2V;
	spf=pass (imf21.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794471591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=F8QZgOdwJOQNroHwVPxnHhYXS0/8CxhTeQW2i2TWYhM=;
	b=8Z593IbUNg7/kHBGhZI4whA54PQnj95SdguTb0mS37U39E7vxS3Pzb/gEY8ThQL20cheBk
	YvxXmNRkrVTwHp/4wUNmdm82NIoikegbypWiVZUXS8ZBxvMGgo4TpeHPvNQdfytrSEcVwW
	qSoGK128jXc1d5mKZvBYewDy7d7GDPY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=xwZLJxSxd+oyLwrA+ywp9Z3Hse+KBPkDnLf51AGaCvk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794471589; v=1; x=1795076389;
 b=SfQpNE2VNQM2NX8/USSumPib0sst4z8rfdbRzO4/Aw0fQdPngxja/ZB2KYYZzPjU60c8TH2a
 0S57oe26zbsaaHNWm2zhjXrLpXk6vtt9xTTCSC8ftBMTtiQ+5lbauutu70vAbPhBpw8zCmNttn1
 BXMSq9k02P7FdgM2i2/hz6Xg=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id f982562d78f503d3;
	Thu, 12 Nov 2026 08:19:48 +0000
X-Mizu-Trace-ID: f982562d78f503d3
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Yu Zhao <yuzhao@google.com>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH] mm/mglru: deactivate anon folios into the oldest generation
Date: Thu, 12 Nov 2026 16:19:28 +0800
Message-Id: <20261112081928.3014946-1-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B5AF91C0007
X-Stat-Signature: ouhs1ue1iiug7mhx3yqqq3yowbtand9c
X-Rspam-User: 
X-HE-Tag: 1794471590-709295
X-HE-Meta: U2FsdGVkX19618rEYCHLP2EQOG5vS4anarECHtRhpBCwvvZ9YBmJEfW6C7Y5ldPxjezaX0ETHxkafXiiFZ7Vmm52LlBeYe7M8Hgnhxrf+dv2ZstXgUbXdyV9rcR0hiEByUo7LiNdoIfq5k77//iPEe0rW3be6OKjZ+nDGsGjoD4D+1LRWeLSGH8y+idP2wUDq+zyu811gz9ZLN6FN1jZqy5xiayzWtHHfW3uc0SbAMWZhyRJUB4i70baoL+0v8iuqpPC2vwNa6cwF1m+TShTxISiGh7TUq23krCV48QcZAcl/Wii/W4RKX5Imk3hOfp3MgLxKQ7a3mPMvjZCAVeVDwsKVvE5eLyMGbQRqglTVX+oRR6JBUfSqpDvuqpvbVKIYITpumpg3/jaoFG7McT1nzakTN4unhQv/PJDoi/ADMvatM1fq7YU0TljMTt3ByPjAZZ8XwliCt0d20zBr2Idnjo+B4N6wimWd82sh8QCmZoTst7F84uYWV9qeG7QgatG6SoECSuX4QeAH+h1NJe8tdsQNALsIrHjWY0ww8BWub3CyQT4x4amolMhxeiz4IIS4Rvzt3ky4YjG468Mt6RzPJ82WPZduhmj3Ne45Hgx2Road6fTdYgFVpmfJHILHcQARyoJftguxQS9q83nAay0sYo2lmMA/XWOXHG8DnRd4KY/2ooL59WC3vlkAohOT19LQFaXitRsvof4+nurAUIK7l+gzD40+2XltjU9c+mM5Vp+Inoy1O1J/OfNfnhZ0LojHA+0plTK+JE9KVlcqom8ME/yC6mnloCfzdGx3bVZtXwyWhOsU0+Fm2HVjjgnBF9RMtO3nZxTWUoX17YTKtzyxUlN7H36uTzMNQLathUc/nzCGXCqHkDZZ7pZPr5kx/dxp0xIGeNlzaQDpbDTe4lRv9UiluOQo0AUT901DftE2jfZIx3FadF6zTI/LiPWGUvWzfoidDoy9oOdWJ4OX1T
 fNC8eKVo
 oOaqMIMv6KxTOymFSMVQxljB+l18yLCqs0zPxJ/3hsRQ+01TmZ8WqJGS5pX3gv1yhWXfasmsQ5pHQui4WDvgjp3xiOPFCautTpyguKdU4XxBplfaIq/uM/rZwITHdZmNa1A6RKimiZtwLpmh03/iJWGbzhaGsxekL1d9vPBpzcem16XTaD6lbDaN/H4siBYV262uS0uWUG3FHlTw5N1ER8I3rVIjrIt+G96w0JwuTsLLwGILxVNq+xG/hk894diaAssDI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ridong Chen <chenridong@xiaomi.com>

folio_deactivate() is used by MADV_COLD and DAMOS_LRU_DEPRIO to move a
folio towards eviction. lru_deactivate() does that by deleting the folio
from its LRU list, clearing PG_active and PG_referenced, and adding it
back with lruvec_add_folio().

With MGLRU, lru_gen_folio_seq() places a swap-backed folio that is not
in the swap cache, i.e. an anon or shmem folio, into max_seq - 1,
regardless of its refs. That generation is active per
lru_gen_is_active(), so such a folio never reaches an inactive
generation, and a folio that has aged into min_seq + 1 is moved to a
younger generation instead. PGDEACTIVATE is still counted. Other folios
are not affected: with their refs cleared they are placed into the
oldest generation.

On a 4-generation memcg, 64MB of aged anon memory in min_seq + 1 ends up
in max_seq - 1 after MADV_COLD, while 64MB of file memory in the same
generation ends up in min_seq.

As a result, MADV_COLD can make anon memory less likely to be reclaimed.
It can be reproduced with a single process in a memcg with swap enabled:

  1) map two 64MB anon regions A and B and fault them in, A first;
  2) age the memcg twice through /sys/kernel/debug/lru_gen, so that both
     regions are in the same generation, min_seq + 1;
  3) apply MADV_COLD to B only, A is the control;
  4) reclaim the size of one region from anon only:
     echo "64M swappiness=max" > memory.reclaim;
  5) count the swapped out pages of A and B from /proc/self/pagemap.

B is expected to be swapped out instead of A. Three runs on mm-new:

                     A swapped out        B (MADV_COLD) swapped out
  before             16384 pages          15 ~ 128 pages
  after              0 ~ 157 pages        16384 pages

Use lruvec_add_folio_tail() for MGLRU, which treats the folio as
reclaiming and adds it to the tail of the oldest generation, the same
place lru_deactivate_file() puts a clean file folio. The other folios,
which were added to the head of the oldest generation, are now added to
its tail as well, so they are reclaimed first as MADV_COLD intends.

Fixes: 081488051d28 ("mm/mglru: fix underprotected page cache")
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---

This patch was developed with the help of an AI coding assistant
(Claude).

The reproducer, run as root in a memcg with swap enabled and debugfs
mounted, e.g. "mkdir /sys/fs/cgroup/t; ./reclaim-order /sys/fs/cgroup/t":

  // SPDX-License-Identifier: GPL-2.0
  /*
   * Two 64MB anon regions, A (hot) and B (MADV_COLD). Reclaim 64MB via
   * memory.reclaim (swappiness=max -> anon only). Report how much of each
   * region was swapped out (mincore can't see swap; use /proc/self/pagemap).
   */
  #define _GNU_SOURCE
  #include <sched.h>
  #include <stdio.h>
  #include <stdlib.h>
  #include <stdint.h>
  #include <string.h>
  #include <unistd.h>
  #include <fcntl.h>
  #include <sys/mman.h>

  static unsigned long long memcg_id;
  static const char *cg_name;

  /* force one aging step on node 0 of our memcg via debugfs */
  static void aging(void)
  {
  	FILE *f = fopen("/sys/kernel/debug/lru_gen", "r");
  	char line[512], cmd[128];
  	unsigned long max = 0, s, x1, x2, x3;
  	int in = 0, fd, len;

  	while (fgets(line, sizeof(line), f)) {
  		unsigned long long id; char path[256];
  		if (sscanf(line, "memcg %llu %255s", &id, path) == 2) {
  			in = !strcmp(path, cg_name);
  			if (in) memcg_id = id;
  			continue;
  		}
  		if (in && sscanf(line, " %lu %lu %lu %lu", &s, &x1, &x2, &x3) == 4)
  			max = s;
  	}
  	fclose(f);
  	len = snprintf(cmd, sizeof(cmd), "+ %llu 0 %lu 200 1\n", memcg_id, max);
  	fd = open("/sys/kernel/debug/lru_gen", O_WRONLY);
  	if (write(fd, cmd, len) != len) perror("aging");
  	close(fd);
  }

  static long swapped(char *p, size_t sz)
  {
  	int fd = open("/proc/self/pagemap", O_RDONLY);
  	long n = 0;
  	for (size_t off = 0; off < sz; off += 4096) {
  		uint64_t e;
  		pread(fd, &e, 8, ((uintptr_t)(p + off) / 4096) * 8);
  		if (e & (1ULL << 62))
  			n++;
  	}
  	close(fd);
  	return n;
  }

  int main(int argc, char **argv)
  {
  	const char *cg = argv[1];
  	cg_name = strrchr(cg, '/');
  	size_t sz = 64UL << 20;
  	char buf[256], *a, *b, *d;
  	cpu_set_t set;
  	int fd;

  	CPU_ZERO(&set); CPU_SET(0, &set);
  	sched_setaffinity(0, sizeof(set), &set);
  	snprintf(buf, sizeof(buf), "%s/cgroup.procs", cg);
  	fd = open(buf, O_WRONLY); dprintf(fd, "%d\n", getpid()); close(fd);

  	a = mmap(NULL, sz, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0);
  	b = mmap(NULL, sz, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0);
  	d = mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0);
  	madvise(a, sz, MADV_NOHUGEPAGE); madvise(b, sz, MADV_NOHUGEPAGE);
  	/* A is faulted in first, so without MADV_COLD it is the older one */
  	for (size_t i = 0; i < sz; i += 4096) a[i] = 1;
  	for (size_t i = 0; i < sz; i += 4096) b[i] = 1;
  	d[0] = 1;
  	madvise(d, 4096, MADV_COLD);	/* drain lru_add */
  	/* two agings: clear young bits of both A and B, both end at min_seq+1 */
  	aging();
  	aging();
  	madvise(b, sz, MADV_COLD);
  	madvise(d, 4096, MADV_COLD);

  	snprintf(buf, sizeof(buf), "%s/memory.reclaim", cg);
  	fd = open(buf, O_WRONLY);
  	if (dprintf(fd, "64M swappiness=max\n") < 0)
  		perror("memory.reclaim");
  	close(fd);

  	printf("hot A swapped: %5ld pages   cold B swapped: %5ld pages  (of %zu)\n",
  	       swapped(a, sz), swapped(b, sz), sz >> 12);
  	return 0;
  }

 mm/folio.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/mm/folio.c b/mm/folio.c
index ea3adb6a89d7..c412d9b398e4 100644
--- a/mm/folio.c
+++ b/mm/folio.c
@@ -583,7 +583,16 @@ static void lru_deactivate(struct lruvec *lruvec, struct folio *folio)
 	lruvec_del_folio(lruvec, folio);
 	folio_clear_active(folio);
 	folio_clear_referenced(folio);
-	lruvec_add_folio(lruvec, folio);
+	/*
+	 * For MGLRU, lruvec_add_folio() places anon folios that are not in
+	 * the swap cache into the second youngest generation, which is an
+	 * active one. Add the folio to the oldest generation instead, like
+	 * lru_deactivate_file() does for clean folios.
+	 */
+	if (lru_gen_enabled())
+		lruvec_add_folio_tail(lruvec, folio);
+	else
+		lruvec_add_folio(lruvec, folio);
 
 	__count_vm_events(PGDEACTIVATE, nr_pages);
 	count_memcg_events(lruvec_memcg(lruvec), PGDEACTIVATE, nr_pages);

base-commit: 2dc0136b1fdac153434ab02778fcdb32db5d0dae
-- 
2.34.1


