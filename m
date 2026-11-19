Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14D38606A320
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 13:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=sEj1W+jI
Received: by kanga.kvack.org (Postfix)
	id 373056B0665; Thu, 19 Nov 2026 08:48:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 349F76B0666; Thu, 19 Nov 2026 08:48:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2615A6B0667; Thu, 19 Nov 2026 08:48:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E6F0C6B0665
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 08:48:22 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7BF37140A80
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 13:48:22 +0000 (UTC)
X-FDA: 85451998044.22.7A9E558
Received: from mta1.migadu.com (out-215.mta1.migadu.com [95.215.58.215])
	by imf15.hostedemail.com (Postfix) with ESMTP id 79BC3A000C
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 13:48:20 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sEj1W+jI;
	spf=pass (imf15.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.215 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795096100;
	b=QQS1zhA8Mw16dyFm4VD3S4pKLTu/KuGzkscVxHGfGrgTQmEHwV3Yk2tBnFLhz6xsU+UW8V
	eDEWdMeFsBzTff5n2vIE5NrXmizhOJKPY4N1Bv3ZFoNwqayJiv1DUT/pfoHZL3yiPZ+Plf
	feknso2NnJb0JP9MZbJTQNj9zMUOJqc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795096100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pzwXTqtS6HcL9/oKJtJiXWjFke+mjP42GRpvF9tQWuc=;
	b=pWtQL7fY2OhrHylkKvX7pRn9bQ10uqnnmv34B6uoI6v4zUZP0XmNSIvl88SxPVuBi3Z3PM
	uPIkiE9IHrVYcW62GzWaGX2qkZYsJEJACLcB40GCk3dMbaZdJqWBny1Yb9NKEkR2kzCZFX
	dl4m4Y7r1RzuMDdTZ7PhInjLnoEUhXs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sEj1W+jI;
	spf=pass (imf15.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.215 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=i/jQIG+BzmHCgyyxPhDxsNPS1TmG1Fi2lnKHys0SzOo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795096099; v=1; x=1795700899;
 b=sEj1W+jIxjlXGYlNBBLdGMcZtnFmsCJGYV9CDs3v8QqM2eRxo1rV/9TC5PNRS6QsQgcPYxjJ
 ApwsEaFDmABFZUWAbOAjoGYRGhDUEtVDNXSIdTUyJrY602bSriy6LV8HJn35EVB36KphSOqq57d
 mxe3gdUAQjOpo0DT//x6dhtk=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 56b6e43b31d1dd41;
	Thu, 19 Nov 2026 13:48:18 +0000
X-Mizu-Trace-ID: 56b6e43b31d1dd41
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <kasong@tencent.com>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>
Cc: Barry Song <baohua@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Yu Zhao <yuzhao@google.com>,
	linux-mm@kvack.org (open list:MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)),
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH v2 2/2] mm/mglru: deactivate anon folios into the oldest generation
Date: Thu, 19 Nov 2026 21:47:40 +0800
Message-Id: <20261119134740.514632-3-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261119134740.514632-1-ridong.chen@linux.dev>
References: <20261119134740.514632-1-ridong.chen@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Stat-Signature: 3ikbrrq9asbpeqx3zrtnezcbanz1b7w7
X-Rspamd-Queue-Id: 79BC3A000C
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam08
X-HE-Tag: 1795096100-212453
X-HE-Meta: U2FsdGVkX19msiovtH8xbghbnDbTCrf4DR2T+dlnWXLKRYuDHMsjJZ+51ue0JeDbnrnRPjsSE40jryEsAnJytR3sWAlWcPghOTSXaQiPZ9dYha6o2Yvz7hTbMejZEmnLFsWhwDfI17oWOf4bMIfcspXrhEbIab2yZR+4XqHf2BNiLtmhUQcSBDfWCiuK7y/kzFn/sHIT9kFQ/TN8NeQp8a5dfTWLYYshBrx3Jds/Oyn065cExnoL1SaVZlbuERSS5qUhPMGgKR8l+SRW6a49uvZT72fco+a/znjhgNxIhg6lp65cec9AhPxdXyA62elOpQe+KCzJIb9b9P60t/R0i+A5nyCnc6nJoIUswzLPOUL4dNNsYBC0k5s74h1Q7RRVo70BAKNguh5rF2ZGp/t4en6W31Bvn3NKNXlKlls/QW4qs8I9vt49zUz/fwkYoFUPL8njZBrIEfl4LZWyqUkImxdoduZ0NPESHQrBwFvG/OPuT2Ir8yZZwDtRTMQlyDQ2nxNOxa+HrDCUwa9nkKxYD1YqvRvw7Ar9HvDRYzIbdK3U0eR+1S/Im+k9O8GGkExzpRoW3rCSM7Hr6AFsk2xmT1fgtaIq6MR+UwhqDlc2ELkNdRLQ8U8gxN3oYU4I+Kx4DK+K7JFQcYliZtkMyV5fTjajmaiD0vO+18yVgcyiLPVET9JLYVmsgrbzd7VP3TVild6fBq4/iDyxo0lTWJqzJA57RP2ybjPH1x38SBqP2TnT/jZ68gzXKi7oLV4XhY2EWO/bRWAMAiwqp4ntAOLyMxSkgyaB5EkDXewonpMv7KkWEbynUg9lUgSS41QwsXry1nM3BK+7G5swsyKSgwrZ5zQxzFZHcQWXQZb66myimvznaPH5+qopsBLLkoPN9uebOPAm6BPNwIyy+R38DoqOdAEuQ8z7hxE05czIFo52ZJRJTqSJzBimBYGGbEMNis3w9GTfpH1eAM9h321OQZH
 SUlcDidB
 3CvgwDB9hbqLous8IS9tRoUZ0Pfu9DzNByQ1uGLXyMe8d8fSeLMfcXI8Go9Htshfq6QlZMgDMHRa/8p+weQhPxo9GCdKqKP3SGo35BPzDyo8ZhRdHC2vj2x8/ePePDpeypxCXKjD8+4cZpDryMN7qxX8gHlW8N0+Pgs7iBClroikfwuh6XB9tiicon7YAOUNfUBuzgQlACmfRC3zcVs7lBVRgkL5cv7I8IQGYbHZb3RodRRllnR9dOPq9KQTeqId5NxSaypLqPHFXUDHpjhnufcTenBBU7pCGfWNWL4zCuLnoc4z2mfuDpICdZK6kB4DIj7Ek4l0iC9epoAoCveUwtAovyMPfL9c4DUgGkUykYHA2yVj2lgboJlbRbCitAKoSpNTOws+XLkTag/LXKwmH7J05xQG4OZ9Yc5cRz86kuLM+Z4JL+prAPxEgDYD97thQ3KqkXxRCSCD7Eg5ReaFO7d9BZd/8+W/F2C5/
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
are placed into the oldest generation with their refs cleared, except
the ones that have PG_reclaim set and are dirty or under writeback,
which also go to max_seq - 1.

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
  before             16384 pages          95 ~ 151 pages
  after              29 ~ 126 pages       16384 pages

Cap the generation to min_seq[type] for MGLRU, so that the folio is
added to the head of the oldest generation. This matches the classic
LRU, which adds a deactivated folio to the head of the inactive list,
and is where most file folios already go. Folios that have PG_reclaim
set and are dirty or under writeback are now placed there too, as the
classic LRU puts them on the inactive list. min_seq only advances under
the LRU lock, which is held here.

Fixes: 081488051d28 ("mm/mglru: fix underprotected page cache")
Suggested-by: Barry Song <baohua@kernel.org>
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---

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

 mm/folio.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/mm/folio.c b/mm/folio.c
index 7a3394e7c5dc..1bfd746d7f07 100644
--- a/mm/folio.c
+++ b/mm/folio.c
@@ -423,6 +423,14 @@ static bool lru_gen_clear_refs(struct folio *folio)
 	return gen == lru_gen_from_seq(seq);
 }
 
+/* add the folio to the head of the oldest generation */
+static bool lru_gen_add_deactivated_folio(struct lruvec *lruvec, struct folio *folio)
+{
+	int type = folio_is_file_lru(folio);
+
+	return lru_gen_add_folio(lruvec, folio, -1UL, lruvec->lrugen.min_seq[type], false);
+}
+
 #else /* !CONFIG_LRU_GEN */
 
 static void lru_gen_inc_refs(struct folio *folio)
@@ -434,6 +442,11 @@ static bool lru_gen_clear_refs(struct folio *folio)
 	return false;
 }
 
+static bool lru_gen_add_deactivated_folio(struct lruvec *lruvec, struct folio *folio)
+{
+	return false;
+}
+
 #endif /* CONFIG_LRU_GEN */
 
 /**
@@ -609,7 +622,8 @@ static void lru_deactivate(struct lruvec *lruvec, struct folio *folio)
 	lruvec_del_folio(lruvec, folio);
 	folio_clear_active(folio);
 	folio_clear_referenced(folio);
-	lruvec_add_folio(lruvec, folio);
+	if (!lru_gen_add_deactivated_folio(lruvec, folio))
+		lruvec_add_folio(lruvec, folio);
 
 	__count_vm_events(PGDEACTIVATE, nr_pages);
 	count_memcg_events(lruvec_memcg(lruvec), PGDEACTIVATE, nr_pages);
-- 
2.34.1


