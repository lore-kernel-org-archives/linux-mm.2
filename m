Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76656C5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 22:59:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B91C6B008A; Tue, 18 Aug 2026 18:59:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16B826B008C; Tue, 18 Aug 2026 18:59:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 080866B0092; Tue, 18 Aug 2026 18:59:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CDE1D6B008A
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 18:59:21 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 32F9E40348
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 22:59:21 +0000 (UTC)
X-FDA: 85115908122.08.6254B93
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id B5176120002
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 22:59:19 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YywxxtcO;
	spf=pass (imf29.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787093959;
	b=5QoJ951L4qo5lHY4d2m4IaH1cQuM5fWW6h20lzHMIgVjL/A1GYvSnZ4W1x0uO0drkaz0iS
	rx7pfjRHpcnAt76LTTlvcpRO0ltHdPVcwmzP+xdE/UlirqiuAr7sGpGcnKxREw+pLPG2x2
	K9ze73ulzWNd7j5bOMoTe1Ju4ZhDEyE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YywxxtcO;
	spf=pass (imf29.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787093959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=nZlIcwwyt/9sQJAinLxhgqP1mzgfQO7bK5vlLoasW3g=;
	b=7chLGt7wQ1Qa6+Nx/kVT4LNhpATJwITjbd62JI8J7isgzUnLlPmmckptdIFmhmLPG9Jgic
	+eH5lgyS75HHVvHqjpNgJp685ej3eW9KfpTbRW8UGhv9rsXxMkZPpbM+Gt/AjhCbW+LH6L
	mKALk5X7PfOOb7PgvKzWzCrNYZvCmR8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 053F4601DE;
	Tue, 18 Aug 2026 22:59:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 123DA1F00A3A;
	Tue, 18 Aug 2026 22:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787093958;
	bh=nZlIcwwyt/9sQJAinLxhgqP1mzgfQO7bK5vlLoasW3g=;
	h=From:To:Cc:Subject:Date;
	b=YywxxtcOxqVjEjaiNndj3EUR6JsfvB1zdKb/c9lDIaG/2qq8HkxhT+xQKVuYW0pu/
	 RnvVkzSS3obTCNYhw4icdyJSqCtA8y5iKypqGaUw65Fk2y76KynZ83hdXHgYWAQTOb
	 uNrkOXYXfFBQXgo6c58T4bd74jV06ogPiu5LBrx4N+Vr/j4lQLUrjpOa7xMBX7TV7M
	 vuE5ByLbq36tAc7R+rT9zqXL3DmzO+WtfVlKUdlCWo2pHSU/ql/2Ec2/s9zk5awnfc
	 Xv2BCJ9HUnDco54A20qqxe+ylP2pdV0xJSfSaHCLBbjfzeUxI+JwwYHkTsX8fl9LCj
	 eGJH7NNtK4lUA==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: baolin.wang@linux.alibaba.com,
	david@kernel.org,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	ljs@kernel.org,
	mhocko@suse.com,
	npache@redhat.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	surenb@google.com,
	vbabka@kernel.org,
	ziy@nvidia.com,
	hughd@google.com,
	ackerleytng@google.com,
	usama.arif@linux.dev,
	joannelkoong@gmail.com,
	hannes@cmpxchg.org,
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [RFC PATCH v3 0/4] mm: enable lru cache for smaller large folios
Date: Wed, 19 Aug 2026 06:59:00 +0800
Message-Id: <20260818225904.55236-1-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B5176120002
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: s6gmdimzcpz971sfkr7yn6b6fjckswtu
X-HE-Tag: 1787093959-29403
X-HE-Meta: U2FsdGVkX18uTSPrTc7p/+lrHd6uFBFwB2lkevUm6H89Lx+x06ejXLqEDc8FSzS1BRy5LBRr3dcnp75pmAsH6wNf8Dg6wZwDlMXRRhRllkLFigNaD6nULDLHsqKqPv7q19M2gMyna0XGZ05NN1stSI5IRgi7n4vfZ0KpSlxJjRMxWxgx/gqoXIVSSxQtCAXlbXgZdinb/XKboZ3C0Y1Qeh9ZpuK/Vmzq2nd/RiOdyprRn9xxEPL9hwwt1+EelU4pFFx8KtbwFTIFmZZyWmPtezlUhfqkQyGs+auaD74vDhdxId0ElPxTFNA7iALWLH3aUxukm1aUGlvpKb+2oUAftp95xGWVAK0NHu9avWbnoyL/FD9kTY72NPdcEasormUpGc/vZ307O1H9bK0HqjZcT4+QFbv4W78KPIgwqMGBu4eMm/NAEup05nKyZiJxMl38qVolR5ljVrHlqtik4fD/T/x8xfUsiZyxHZwlTRsffPvKFyPsu7sH0EBDUtmIHRNR7VU//G+hqqcEUsIFWPdL6OpXXKSb5Byvhf5RpFy/VeRCn3DgEBe+vGgKvuKZLWu25Eisz5WXP1FfErW67Dt7V/uZkOYl2OX25Yhba3UK9E9o+CzOi/BzsWi4B5nYUqYqyrVWTQDtl1hfBhFznqRthAoXbdC11g9KepImttfJwJXohWLbGVVdjZm62RoSiT7eZ6Mdm4ZqdLggPgjDbBYrUn/Rb8Mw+k6gTcuMk7NmEV9XvvlolH1Uco9WfnXgehTkIc/NLMNLgh5dqDxM6q+jrlhppor4O8r5gpqepVFY5xdSoTleACBaRUyq5AppV1gDYDPdHeBv6Jga9cLRD52Rv48fmbfrskmsms3wc2lvi03BRq06hak2Ay5V3I6aDUxD2zKCoKd9boFyY569ReeYqN0TitNgp6ozSX/iVm+eymG2miktY1XnfUHZARWMV3aVJUC98+2obczBwlOS87G
 QS2hr/80
 LfcU3H91AtZw/zcNF0aB0WSJhHyFvgnr4VVdymQi3Nb5QYv/NjzJkm/js531Dlkz46a9m/vCJ6RB2jIFsFphJEjwcLMHm0tlrkl90pPra/yfPn07vwbcwu4miPm8vZQwGN0aOX5TH8YK/hYIH/3XgLCTTjJcSSYEtXfBJ8PfXeLOJuhdSZP2N5juxRluLPV5/G0P/DTdM4R96xCNtUyLF8qwCZaEpJCt8g71zK+TelZ6zrXw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patchset enables the per-CPU LRU cache for large folios with fewer
than `FOLIO_BATCH_SIZE` (31) pages. It also limits each per-CPU LRU cache
to at most `FOLIO_BATCH_SIZE` pages to avoid negatively affecting
accounting and memory reclamation pressure.

This is particularly beneficial on systems that use relatively small
large folios. For larger folios, the benefit is likely to be smaller
because far fewer folios are expected to contend for the LRU cache.

* Use the following microbenchmark:

 #include <pthread.h>
 #include <sys/mman.h>
 #include <string.h>

 #define NUM_THREADS     20
 #define MEM_SIZE        (16 * 1024 * 1024)
 #define LOOP_COUNT      1000

 void* thread_worker(void* arg) {
        void *addr = mmap(NULL, MEM_SIZE, PROT_READ | PROT_WRITE,
                        MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);

        for (int i = 0; i < LOOP_COUNT; i++) {
                for(int j = 0; j < MEM_SIZE; j += 4096)
                        *(unsigned char *)(addr + j) = 0x55;
                madvise(addr, MEM_SIZE, MADV_DONTNEED);
        }

        munmap(addr, MEM_SIZE);
        pthread_exit(NULL);
 }

 int main() {
        pthread_t threads[NUM_THREADS];

        for (long t = 0; t < NUM_THREADS; t++) {
                pthread_create(&threads[t], NULL, thread_worker, (void*)t);
        }

        for (int t = 0; t < NUM_THREADS; t++) {
                pthread_join(threads[t], NULL);
        }

        return 0;
 }

w/o patch:

$ time ./a.out 

real	0m17.760s
user	0m8.207s
sys	5m46.067s

perf lock report:
                Name   acquired  contended     avg wait   total wait     max wait     min wait 

                       21414857   21414857     30.07 us     10.73 m     101.94 us       880 ns 
                          42890      42890     11.29 us    484.21 ms    123.08 us       923 ns 
                           1678       1678      1.57 us      2.63 ms      5.77 us       985 ns 
                             52         52      1.46 us     75.98 us      2.69 us      1.07 us 
                             18         18     17.82 us    320.69 us     58.92 us      1.62 us 
                             18         18      2.36 ms     42.52 ms      5.31 ms      1.47 us 
           rcu_state         12         12      1.98 us     23.78 us      2.62 us      1.47 us 
           rcu_state          9          9      1.72 us     15.49 us      2.27 us      1.34 us 
                              2          2      2.42 us      4.83 us      2.48 us      2.36 us 

w/ patch:

$ time ./a.out 

real	0m16.292s
user	0m8.587s
sys	5m13.787s

perf lock report

                Name   acquired  contended     avg wait   total wait     max wait     min wait 

                        2641286    2641286     46.87 us      2.06 m     107.92 us      1.01 us 
                         235275     235275     10.57 us      2.49 s     115.32 us      1.02 us 
           rcu_state       1982       1982      7.58 us     15.02 ms     31.72 us      1.26 us 
           rcu_state       1929       1929      7.42 us     14.32 ms     30.50 us      1.43 us 
                             86         86      3.61 us    310.19 us     13.89 us      1.15 us 
                             20         20     19.70 us    394.03 us    108.07 us      2.15 us 
       tasklist_lock          1          1      2.13 us      2.13 us      2.13 us      2.13 us 


* Build the kernel in a 1 GiB memcg by -j20 with zRAM configured as swap:

w/o patch:

Perf lock report:

                Name   acquired  contended     avg wait   total wait     max wait     min wait 

                         782337     782337     17.61 us     13.78 s     402.22 us       896 ns 
                          55459      55459     19.48 us      1.08 s     117.59 us      1.01 us 
                           7826       7826      8.01 us     62.68 ms     19.03 us       887 ns 
                           5324       5324      7.83 us     41.68 ms     37.59 us      1.11 us 
           rcu_state       5144       5144      6.27 us     32.23 ms     25.17 us      1.58 us 
           rcu_state       5142       5142      6.35 us     32.67 ms     30.55 us      1.48 us 
                           3855       3855      8.74 us     33.68 ms     42.32 us       996 ns 
                           2770       2770      9.22 us     25.55 ms     27.83 us       914 ns 
                           2342       2342      5.88 us     13.77 ms    318.75 us      1.00 us 
time:

*** Executing round 0 ***

real    1m46.847s
user    25m10.848s
sys     2m57.282s

*** Executing round 1 ***

real    1m46.423s
user    25m10.072s
sys     2m54.348s

*** Executing round 2 ***

real    1m46.308s
user    25m13.800s
sys     2m58.963s

*** Executing round 3 ***

real    1m46.155s
user    25m18.079s
sys     2m59.721s

*** Executing round 4 ***

real    1m45.980s
user    25m15.493s
sys     2m56.959s

w/ patch:

perf lock report
                Name   acquired  contended     avg wait   total wait     max wait     min wait 

                         202647     202647     34.27 us      6.94 s     467.82 us      1.18 us 
                          51819      51819     16.26 us    842.46 ms    245.55 us       885 ns 
     inode_hash_lock      15169      15169      8.58 us    130.21 ms     23.23 us      1.04 us 
                           5306       5306      7.54 us     40.03 ms     31.53 us      1.17 us 
           rcu_state       4945       4945      6.97 us     34.47 ms     30.00 us      1.76 us 
           rcu_state       4899       4899      7.03 us     34.42 ms     24.65 us      1.42 us 
                           3923       3923      8.56 us     33.57 ms     27.51 us      1.08 us 
                           2212       2212      5.23 us     11.56 ms    222.79 us       965 ns 
                           1412       1412      6.35 us      8.97 ms     23.09 us      1.77 us 

time:

*** Executing round 0 ***

real	1m46.463s
user	25m17.448s
sys	2m49.524s

*** Executing round 1 ***

real	1m46.274s
user	25m12.178s
sys	2m53.522s

*** Executing round 2 ***

real	1m46.362s
user	25m13.115s
sys	2m53.005s

*** Executing round 3 ***

real	1m46.036s
user	25m17.627s
sys	2m53.477s

*** Executing round 4 ***

real	1m46.329s
user	25m15.130s
sys	2m51.508s

-RFC v3:
  * Rather than hard-coding `< COSTLY_ORDER` to enable the lru_cache,
    allow the lru_cache for larger orders as long as the folio contains
    fewer than `FOLIO_BATCH_LRU` pages. Also limit the total number of
    pages held in the lru_cache. Hugh may prefer this approach as well.
  * Clean up the comments and `if` conditions in "mm: improve large folio
    reuse for LRU-cached folios" based on David's feedback. Thanks!
  * Properly drain the lru_cache when splitting folios. Thanks to Sashiko
    and David!

-RFC v2:
 * Make __wp_can_reuse_large_anon_folio() aware of LRU-cached large
   folios. As David pointed out, it currently does not account for
   large folios residing in the per-CPU LRU cache.
   https://lore.kernel.org/all/20260709081536.82768-1-baohua@kernel.org/

Barry Song (Xiaomi) (4):
  mm: allow smaller large folios to use lru_cache
  mm: improve large folio reuse for LRU-cached folios
  mm: drain LRU cache if necessary for splitting large folios
  mm: batch lru_cache draining in deferred_split_scan

 include/linux/folio_batch.h | 25 +++++++++++++++++++++++++
 mm/folio.c                  | 10 +++++++++-
 mm/huge_memory.c            | 23 +++++++++++++++++++----
 mm/internal.h               |  4 ++--
 mm/memory.c                 |  6 ++++++
 5 files changed, 61 insertions(+), 7 deletions(-)

-- 
2.34.1


